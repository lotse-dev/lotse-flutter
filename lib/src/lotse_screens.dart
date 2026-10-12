import 'package:flutter/widgets.dart';

/// Name of the event a screen view writes.
const screenViewEventName = 'screen_view';

/// Characters of a screen name that are reported; the server takes at most
/// 200 per prop value.
const maxScreenNameLength = 200;

/// Reports a screen view named [screen].
typedef LotseScreenTracker = void Function(String screen);

/// The name a route is reported under: its [RouteSettings.name], which
/// go_router fills with the route's `name` or, without one, its path
/// pattern such as `/products/:id`. Null for routes without a name.
String? defaultLotseScreenName(Route<dynamic> route) {
  final name = route.settings.name?.trim();
  return name == null || name.isEmpty ? null : name;
}

/// Writes a `screen_view` event with prop `screen` whenever a page becomes
/// visible: pushed, put in place of another one, or uncovered by a pop.
/// Dialogs, bottom sheets and other popup routes are not screens and are
/// skipped, and so are routes without a name.
///
/// Hand one instance to each navigator, for example
/// `GoRouter(observers: [LotseScreenObserver()])`. Since go_router 17 a
/// `ShellRoute` reports its pages to these root observers too, so do not add
/// a second instance to its `observers`: every view would count twice. With
/// go_router 16 or older, or `notifyRootObserver: false`, the shell's own
/// navigator needs its own instance. Views after
/// `Lotse.init` was called are reported once it has finished; views before
/// that call are dropped.
class LotseScreenObserver extends NavigatorObserver {
  /// [screenName] decides what a route is called; return null to skip it.
  LotseScreenObserver({String? Function(Route<dynamic> route)? screenName})
    : this.withTracker(
        // Looked up per view: the observer usually exists before init.
        (screen) => lotseScreenTracker(screen),
        screenName: screenName,
      );

  /// An observer that hands screen names to [track] instead of the SDK, and
  /// the screen on top to [current] instead of [lotseCurrentScreen].
  @visibleForTesting
  LotseScreenObserver.withTracker(
    this._track, {
    String? Function(Route<dynamic> route)? screenName,
    ValueNotifier<String?>? current,
  }) : _screenName = screenName ?? defaultLotseScreenName,
       _current = current ?? lotseCurrentScreen;

  final LotseScreenTracker _track;
  final String? Function(Route<dynamic> route) _screenName;
  final ValueNotifier<String?> _current;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _top(route);
    _visible(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute == null) return;
    if (newRoute.isCurrent) _top(newRoute);
    _visible(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _top(previousRoute);
    // Closing a dialog uncovers no new screen.
    if (route is PageRoute && previousRoute != null) _visible(previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null && previousRoute.isCurrent) _top(previousRoute);
  }

  /// [route] lies on top now. A dialog or bottom sheet on top is no screen:
  /// taps on it must not land on the page below.
  void _top(Route<dynamic> route) =>
      _current.value = route is PageRoute ? _nameOf(route) : null;

  void _visible(Route<dynamic> route) {
    if (route is! PageRoute) return;
    final name = _nameOf(route);
    if (name != null) _track(name);
  }

  String? _nameOf(Route<dynamic> route) {
    final name = _screenName(route);
    if (name == null || name.isEmpty) return null;
    return name.length > maxScreenNameLength
        ? name.substring(0, maxScreenNameLength)
        : name;
  }
}

/// The named page on top of the navigator [LotseScreenObserver] watches last,
/// or null while a dialog, a bottom sheet or a page without a name is on top.
/// Heatmap taps are counted for this screen and dropped while it is null.
final lotseCurrentScreen = ValueNotifier<String?>(null);

/// Where [LotseScreenObserver] reports to by default. `Lotse.init` sets it to
/// the SDK's own tracking; until then views are dropped.
LotseScreenTracker lotseScreenTracker = (_) {};
