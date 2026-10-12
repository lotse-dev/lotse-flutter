import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'lotse_backgrounds.dart';
import 'lotse_capture.dart';
import 'lotse_feedback_opener.dart';
import 'lotse_masks.dart';
import 'lotse_replay_recorder.dart';
import 'lotse_retake.dart';
import 'lotse_screens.dart';
import 'lotse_taps.dart';

/// Wraps the app once and gives Lotse what it needs from the widget tree: the
/// boundary a feedback screenshot is taken of and the switch that masks
/// [LotseConfidential] regions while it is taken.
///
/// ```dart
/// runApp(LotseScope(child: MyApp()));
/// ```
///
/// With a [navigatorKey] it also lets Lotse open a conversation when the user
/// taps the push that announces a team reply. Give the scope the same key as
/// the app's navigator, with go_router:
///
/// ```dart
/// final navigatorKey = GlobalKey<NavigatorState>();
/// final router = GoRouter(navigatorKey: navigatorKey, routes: routes);
///
/// runApp(
///   LotseScope(
///     navigatorKey: navigatorKey,
///     child: MaterialApp.router(routerConfig: router),
///   ),
/// );
/// ```
///
/// Without a router the key goes to `MaterialApp(navigatorKey: ...)`. Without
/// a key such a push just brings the app to the front; the reply is still in
/// `Lotse.instance.showMyFeedback`.
///
/// Screenshots black out [LotseConfidential] regions, text inputs and
/// platform views in the image; the screen itself never changes. Wrap a
/// widget in [LotseUnmasked] to show its text inputs and platform views, and
/// set [maskAllText] to black out every text as well.
///
/// With `Lotse.init(heatmaps: true)` the scope also records taps for heatmaps,
/// on the screen a `LotseScreenObserver` reports. Taps on a
/// [LotseConfidential] region are not recorded.
class LotseScope extends StatefulWidget {
  /// Creates the scope around [child], usually the whole app.
  const LotseScope({
    required this.child,
    this.navigatorKey,
    this.maskAllText = false,
    super.key,
  });

  /// The app.
  final Widget child;

  /// The key of the app's navigator. Lotse pushes the conversation of a
  /// tapped reply push onto it.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Blacks out every text in screenshots, not only text inputs.
  final bool maskAllText;

  @override
  State<LotseScope> createState() => _LotseScopeState();
}

class _LotseScopeState extends State<LotseScope> {
  final _boundaryKey = GlobalKey(debugLabel: 'LotseScope');
  late final _controller = LotseCaptureController(
    boundaryKey: _boundaryKey,
    maskAllText: () => widget.maskAllText,
  );

  final _taps = LotseTapRecognizer();
  late final LotseBackgroundWatcher _backgrounds;

  /// Null while the app did not ask for replays.
  LotseReplayRecorder? _replay;

  @override
  void initState() {
    super.initState();
    final key = widget.navigatorKey;
    if (key != null) lotseFeedbackOpener.attach(key);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_onPointer);
    if (lotseReplayOptions case final options?) {
      _replay = LotseReplayRecorder(
        boundaryKey: _boundaryKey,
        options: options,
        maskAllText: () => widget.maskAllText,
      );
    }
    // Idle until the server asks for a background.
    _backgrounds = LotseBackgroundWatcher(
      view: _backgroundView,
      capture: () async => switch (await _controller.capture()) {
        LotseCaptureSuccess(:final screenshot) => screenshot.png,
        LotseCaptureFailed() => null,
      },
    );
  }

  RenderBox? get _boundary {
    final box = _boundaryKey.currentContext?.findRenderObject();
    return box is RenderBox && box.hasSize && box.attached ? box : null;
  }

  /// Screen, size and the scroll offset in the middle of the boundary, for a
  /// heatmap background.
  LotseBackgroundView _backgroundView() {
    final box = _boundary;
    if (box == null || !mounted) {
      return (screen: null, size: null, scrollY: 0);
    }
    final center = box.localToGlobal(box.size.center(Offset.zero));
    final probe = _probe(center, View.of(context).viewId);
    return (
      screen: lotseCurrentScreen.value,
      size: box.size,
      scrollY: probe.scrollY ?? 0,
    );
  }

  /// The context each scroll view dispatches its notifications from, by its
  /// render object. A scroll view hit-tests opaque, so that render object is
  /// on the hit path wherever the scroll view is hit, also between the
  /// children of a grid. Covers every [Scrollable], `SingleChildScrollView`
  /// included, whose viewport is no [RenderViewportBase].
  final _scrollables = Expando<BuildContext>('LotseScope scrollables');

  /// Every scroll view sends one when first laid out.
  bool _registerScrollable(ScrollMetricsNotification notification) {
    final box = notification.context.findRenderObject();
    if (box != null) _scrollables[box] = notification.context;
    return false;
  }

  /// Hit-tests the global [position]: whether it hits the app inside the
  /// boundary at all, not something above it like the retake bar, whether
  /// it lies on a [LotseConfidential] region, and the offset of the
  /// innermost vertical scroll view under it that can scroll, if any. One
  /// that cannot, like a shrink-wrapped grid inside a page that scrolls,
  /// says nothing about where the content is.
  ({bool inside, bool confidential, bool offScreen, int? scrollY}) _probe(
    Offset position,
    int viewId,
  ) {
    final boundary = _boundary;
    final hits = HitTestResult();
    WidgetsBinding.instance.hitTestInView(hits, position, viewId);
    int? scrollY;
    var offScreen = false;
    var inside = false;
    // The path runs from the innermost target outwards.
    for (final entry in hits.path) {
      final target = entry.target;
      if (target is _RenderMask) {
        return (
          inside: true,
          confidential: true,
          offScreen: false,
          scrollY: null,
        );
      }
      if (identical(target, boundary)) inside = true;
      if (target is RenderLotseOffScreen) offScreen = true;
      if (scrollY != null || target is! RenderObject) continue;
      final context = _scrollables[target];
      if (context == null || !context.mounted) continue;
      final scroll = Scrollable.maybeOf(context)?.position;
      if (scroll == null ||
          scroll.axis != Axis.vertical ||
          !scroll.hasPixels ||
          !scroll.hasContentDimensions ||
          scroll.maxScrollExtent <= scroll.minScrollExtent) {
        continue;
      }
      scrollY = scroll.pixels.round();
    }
    return (
      inside: inside,
      confidential: false,
      offScreen: offScreen,
      scrollY: scrollY,
    );
  }

  /// Sees every pointer of the app, also in the browser, before and beside
  /// the gesture arena. Does nothing while heatmaps are off.
  void _onPointer(PointerEvent event) {
    final sink = lotseTapSink;
    final replay = _replay;
    if (sink == null && replay == null) return;
    switch (event) {
      case PointerDownEvent():
        final start = _tapStart(event);
        if (start != null) _taps.down(event.pointer, start);
      case PointerMoveEvent():
        _taps.move(event.pointer, event.position);
      case PointerUpEvent():
        final tap = _taps.up(event.pointer, event.timeStamp);
        if (tap == null) return;
        replay?.tap(Offset(tap.x.toDouble(), tap.y.toDouble()));
        // A heatmap belongs to a screen; taps on a dialog have none.
        if (tap.screen != null) sink?.call(tap);
      case PointerCancelEvent():
        _taps.cancel(event.pointer);
      default:
    }
  }

  /// What the down [event] knows about a tap, or null when it cannot become
  /// one: outside the boundary, on something above it like the retake bar
  /// (F9 in `docs/PLAN.md`), or on a confidential region, whose tap
  /// positions could spell out a PIN.
  LotseTapStart? _tapStart(PointerDownEvent event) {
    final screen = lotseCurrentScreen.value;
    final box = _boundary;
    if (box == null) return null;
    final local = box.globalToLocal(event.position);
    if (!(Offset.zero & box.size).contains(local)) return null;

    final probe = _probe(event.position, event.viewId);
    if (!probe.inside || probe.confidential) return null;
    return LotseTapStart(
      screen: probe.offScreen ? null : screen,
      ts: DateTime.now().toUtc(),
      position: event.position,
      local: local,
      time: event.timeStamp,
      slop: computeHitSlop(
        event.kind,
        MediaQuery.maybeGestureSettingsOf(_boundaryKey.currentContext!),
      ),
      scrollY: probe.scrollY,
      viewport: box.size,
    );
  }

  @override
  void didUpdateWidget(LotseScope oldWidget) {
    super.didUpdateWidget(oldWidget);
    final key = widget.navigatorKey;
    final oldKey = oldWidget.navigatorKey;
    if (key == oldKey) return;
    if (oldKey != null) lotseFeedbackOpener.detach(oldKey);
    if (key != null) lotseFeedbackOpener.attach(key);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_onPointer);
    _backgrounds.dispose();
    _replay?.dispose();
    final key = widget.navigatorKey;
    if (key != null) lotseFeedbackOpener.detach(key);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _LotseScopeMarker(
    controller: _controller,
    replay: _replay,
    // The retake bar lies above the app but beside the boundary, so it is
    // never in a screenshot. Passthrough: the app is laid out as without
    // the stack.
    child: Stack(
      textDirection: TextDirection.ltr,
      fit: StackFit.passthrough,
      children: [
        RepaintBoundary(
          key: _boundaryKey,
          child: NotificationListener<ScrollMetricsNotification>(
            onNotification: _registerScrollable,
            child: widget.child,
          ),
        ),
        ValueListenableBuilder<LotseRetakeRequest?>(
          valueListenable: _controller.retake.current,
          builder: (context, request, _) => request == null
              ? const Positioned(left: 0, top: 0, child: SizedBox.shrink())
              : LotseRetakeBar(
                  key: ObjectKey(request),
                  controller: _controller.retake,
                  request: request,
                ),
        ),
      ],
    ),
  );
}

class _LotseScopeMarker extends InheritedWidget {
  const _LotseScopeMarker({
    required this.controller,
    required this.replay,
    required super.child,
  });

  final LotseCaptureController controller;
  final LotseReplayRecorder? replay;

  // Both live as long as the scope.
  @override
  bool updateShouldNotify(_LotseScopeMarker oldWidget) =>
      controller != oldWidget.controller || replay != oldWidget.replay;
}

/// The replay recorder of the [LotseScope] above [context], or `null`
/// without a scope or while replays are off. Internal.
LotseReplayRecorder? lotseReplayRecorderOf(BuildContext context) =>
    context.getInheritedWidgetOfExactType<_LotseScopeMarker>()?.replay;

/// The capture controller of the [LotseScope] above [context], or `null`
/// without one. Internal: apps never see the controller.
LotseCaptureController? lotseCaptureControllerOf(BuildContext context) =>
    context.getInheritedWidgetOfExactType<_LotseScopeMarker>()?.controller;

/// Captures the [LotseScope] above [context]. Without a scope the result is
/// [LotseCaptureFailure.noBoundary]. Never throws.
Future<LotseCaptureResult> captureLotseScreenshot(BuildContext context) async =>
    await lotseCaptureControllerOf(context)?.capture() ??
    const LotseCaptureFailed(LotseCaptureFailure.noBoundary);

/// Hides [child] in every Lotse screenshot: the region is black in the
/// image. On screen nothing changes. Wins over [LotseUnmasked].
///
/// ```dart
/// LotseConfidential(child: Text(iban));
/// ```
class LotseConfidential extends SingleChildRenderObjectWidget {
  /// Marks [child] as confidential.
  const LotseConfidential({required Widget child, super.key})
    : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMask();
}

/// Shows the text inputs and platform views inside [child] in Lotse
/// screenshots, which are blacked out by default. A [LotseConfidential]
/// inside still hides its region.
///
/// ```dart
/// LotseUnmasked(child: TextField(decoration: searchDecoration));
/// ```
class LotseUnmasked extends SingleChildRenderObjectWidget {
  /// Lifts the default masks inside [child].
  const LotseUnmasked({required Widget child, super.key}) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderUnmasked();
}

/// Layout, paint and hit testing are those of the child; only the capture
/// looks for it.
class _RenderMask extends RenderProxyBox implements LotseConfidentialMarker {}

class _RenderUnmasked extends RenderProxyBox implements LotseUnmaskedMarker {}
