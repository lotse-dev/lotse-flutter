import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'lotse_capture.dart';
import 'lotse_identity_boundary.dart';
import 'lotse_masks.dart';
import 'lotse_replay_buffer.dart';
import 'lotse_replay_diff.dart';
import 'lotse_screens.dart';

// The replay recorder, see `docs/REPLAY.md`, "Aufnahme im SDK". It keeps the
// last seconds of the screen in memory; nothing leaves the device unless the
// user attaches it to a feedback message (step R3).

/// How the replay of the last seconds before a feedback message is kept.
@immutable
class LotseReplayOptions {
  /// Keeps the last [seconds], 15 to 120. [attachByDefault] decides whether
  /// the switch in the feedback sheet starts on; the user sees it before
  /// sending either way.
  const LotseReplayOptions({this.seconds = 60, this.attachByDefault = true});

  final int seconds;
  final bool attachByDefault;

  /// [seconds] within 15 and 120.
  int get windowSeconds => seconds.clamp(15, 120);
}

/// Set by `Lotse.init(replay: ...)`; null keeps the recorder off.
LotseReplayOptions? lotseReplayOptions;

/// Shortest time between two captures, on devices and in the browser, where
/// the comparison runs on the main thread.
const lotseReplayInterval = Duration(milliseconds: 500);
const lotseReplayWebInterval = Duration(milliseconds: 1000);

/// A keyframe at least this often, so the buffer can drop old parts.
const lotseReplayKeyframeEvery = Duration(seconds: 10);

/// Records the boundary behind [boundaryKey] into a [LotseReplayBuffer]:
/// only after Flutter drew a frame, at most every [interval], only while
/// the app is in front and nothing paused it. Frames are masked in the
/// image (`collectLotseMasks`) before they are compared or encoded.
class LotseReplayRecorder {
  LotseReplayRecorder({
    required this.boundaryKey,
    required LotseReplayOptions options,
    bool Function()? maskAllText,
    Duration? interval,
    int Function()? clock,
    DateTime Function()? wallClock,
    Future<LotseReplayDiff> Function(LotseReplayDiffJob job)? compare,
  }) : options = options,
       buffer = LotseReplayBuffer(windowMs: options.windowSeconds * 1000),
       interval =
           interval ?? (kIsWeb ? lotseReplayWebInterval : lotseReplayInterval),
       _maskAllText = maskAllText ?? (() => false),
       _clock = clock ?? _stopwatchClock(),
       _wallClock = wallClock ?? (() => DateTime.now().toUtc()),
       // An isolate on devices; `compute` runs it on the main thread in the
       // browser, which has no isolates.
       _compare = compare ?? ((job) => compute(runLotseReplayDiff, job)) {
    _lifecycle = AppLifecycleListener(onHide: _hidden, onShow: _shown);
    lotseCurrentScreen.addListener(_screenChanged);
    lotseIdentityEpoch.addListener(_identityEnded);
    _screenChanged();
    _watchFrames();
  }

  final GlobalKey boundaryKey;
  final LotseReplayOptions options;
  final LotseReplayBuffer buffer;
  final Duration interval;
  final bool Function() _maskAllText;
  final int Function() _clock;
  final DateTime Function() _wallClock;
  final Future<LotseReplayDiff> Function(LotseReplayDiffJob job) _compare;
  late final AppLifecycleListener _lifecycle;

  Uint8List? _previous;
  int? _previousWidth;
  int? _previousHeight;
  int _lastCaptureMs = -1 << 40;
  int _lastKeyframeMs = -1 << 40;
  var _dirty = true;
  var _busy = false;
  Completer<void>? _running;
  var _hiddenApp = false;
  var _holds = 0;
  var _disposed = false;
  var _ratio = 1.0;
  Timer? _timer;

  /// Counts ended identities; a capture that began under an earlier one is
  /// dropped when it finishes.
  var _generation = 0;

  /// Milliseconds since the recorder started.
  int get nowMs => _clock();

  bool get recording => !_hiddenApp && _holds == 0 && !_disposed;

  /// Completes once no capture is running. [hold] starts no new one, but a
  /// capture already begun still reads pixels and encodes PNGs; the feedback
  /// screenshot waits for it. Under Impeller with OpenGLES the two at once
  /// make the screen flicker.
  Future<void> get idle => _running?.future ?? Future<void>.value();

  /// Stops recording until [release], e.g. while the feedback sheet is open:
  /// it lies inside the boundary and would record the message being typed.
  void hold() {
    if (_holds++ == 0) _mark(LotseReplayMarkKind.pause);
  }

  void release() {
    if (_holds == 0) return;
    if (--_holds == 0) _resumed();
  }

  /// A tap at [local], logical pixels of the boundary.
  void tap(Offset local) {
    if (!recording) return;
    buffer.addMark(
      LotseReplayMark(
        tMs: nowMs,
        kind: LotseReplayMarkKind.tap,
        x: (local.dx * _ratio).round(),
        y: (local.dy * _ratio).round(),
      ),
    );
  }

  /// The buffer as upload chunks, newest last, each with the wall clock of
  /// the moment it was cut.
  List<LotseReplayChunk> chunks() {
    final endedAt = _wallClock();
    return [for (final chunk in buffer.chunks(nowMs)) chunk.endingAt(endedAt)];
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _lifecycle.dispose();
    lotseCurrentScreen.removeListener(_screenChanged);
    lotseIdentityEpoch.removeListener(_identityEnded);
    buffer.clear();
    _previous = null;
  }

  /// `Lotse.reset()` ended the identity: what the previous user did must
  /// not end up attached to the next user's feedback.
  void _identityEnded() {
    _generation++;
    buffer.clear();
    _previous = null;
    _dirty = true;
  }

  void _hidden() {
    if (_hiddenApp) return;
    _hiddenApp = true;
    _mark(LotseReplayMarkKind.pause);
  }

  void _shown() {
    if (!_hiddenApp) return;
    _hiddenApp = false;
    if (_holds == 0) _resumed();
  }

  void _resumed() {
    _mark(LotseReplayMarkKind.resume);
    // What was on screen may have changed in the meantime.
    _previous = null;
    _dirty = true;
    SchedulerBinding.instance.scheduleFrame();
  }

  void _mark(LotseReplayMarkKind kind) =>
      buffer.addMark(LotseReplayMark(tMs: nowMs, kind: kind));

  void _screenChanged() {
    final screen = lotseCurrentScreen.value;
    if (screen == null || !recording) return;
    buffer.addMark(
      LotseReplayMark(
        tMs: nowMs,
        kind: LotseReplayMarkKind.screen,
        screen: screen,
      ),
    );
  }

  // A post-frame callback schedules no frame: a still screen costs nothing.
  void _watchFrames() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_disposed) return;
      _dirty = true;
      _maybeCapture();
      _watchFrames();
    });
  }

  /// Captures now if the last capture is [interval] ago, else once it is.
  void _maybeCapture() {
    if (!_dirty || _busy || !recording) return;
    final wait = _lastCaptureMs + interval.inMilliseconds - nowMs;
    if (wait <= 0) {
      _timer?.cancel();
      _timer = null;
      unawaited(_capture());
    } else {
      _timer ??= Timer(Duration(milliseconds: wait), () {
        _timer = null;
        // A frame on its way paints again; its callback captures then.
        if (SchedulerBinding.instance.hasScheduledFrame) return;
        _maybeCapture();
      });
    }
  }

  Future<void> _capture() async {
    final boundary = boundaryKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary || !boundary.hasSize) return;
    _busy = true;
    final running = _running = Completer<void>();
    _dirty = false;
    final at = nowMs;
    final generation = _generation;
    _lastCaptureMs = at;
    try {
      // Logical pixels: the image is about a twelfth of the physical one.
      final ratio = capturePixelRatio(
        logicalSize: boundary.size,
        devicePixelRatio: 1,
      );
      if (ratio <= 0) return;
      _ratio = ratio;
      // Masks and image of the same frame, both taken before any await.
      final masks = collectLotseMasks(boundary, maskAllText: _maskAllText());
      final image = paintLotseMasksSync(
        boundary.toImageSync(pixelRatio: ratio),
        masks,
        ratio,
      );
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        if (data == null || _disposed) return;
        final rgba = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        final forceKeyframe =
            at - _lastKeyframeMs >= lotseReplayKeyframeEvery.inMilliseconds;
        final diff = forceKeyframe
            ? (
                keyframe: true,
                rects: [(x: 0, y: 0, w: image.width, h: image.height)],
              )
            : await _compare(
                LotseReplayDiffJob(
                  _previous,
                  rgba,
                  image.width,
                  image.height,
                  _previousWidth,
                  _previousHeight,
                ),
              );
        if (_disposed) return;
        final frames = <LotseReplayFrame>[];
        for (final rect in diff.rects) {
          final png = diff.keyframe
              ? await _encode(image)
              : await _encodeRegion(rgba, image.width, rect);
          if (png == null || _disposed) return;
          frames.add(
            LotseReplayFrame(
              tMs: at,
              rect: rect,
              png: png,
              keyframe: diff.keyframe,
              width: image.width,
              height: image.height,
            ),
          );
        }
        if (generation != _generation) return;
        frames.forEach(buffer.add);
        if (diff.keyframe) _lastKeyframeMs = at;
        buffer.trim(at);
        _previous = rgba;
        _previousWidth = image.width;
        _previousHeight = image.height;
      } finally {
        image.dispose();
      }
    } catch (error) {
      debugPrint('Lotse: replay frame skipped: ${error.runtimeType}');
    } finally {
      _busy = false;
      _running = null;
      running.complete();
      // Frames drawn during the capture are taken on the next turn.
      if (_dirty) _maybeCapture();
    }
  }

  static Future<Uint8List?> _encode(ui.Image image) async {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  /// PNG of [rect] of [rgba]. The engine encodes, not Dart.
  static Future<Uint8List?> _encodeRegion(
    Uint8List rgba,
    int width,
    LotseReplayRect rect,
  ) async {
    final pixels = cropLotseFrame(rgba, width, rect);
    final completer = Completer<ui.Image>();
    ui.decodeImageFromPixels(
      pixels,
      rect.w,
      rect.h,
      ui.PixelFormat.rgba8888,
      completer.complete,
    );
    final image = await completer.future;
    try {
      return await _encode(image);
    } finally {
      image.dispose();
    }
  }
}

/// The frames [runLotseReplayDiff] compares, sent to an isolate.
class LotseReplayDiffJob {
  const LotseReplayDiffJob(
    this.previous,
    this.next,
    this.width,
    this.height,
    this.previousWidth,
    this.previousHeight,
  );

  final Uint8List? previous;
  final Uint8List next;
  final int width;
  final int height;
  final int? previousWidth;
  final int? previousHeight;
}

LotseReplayDiff runLotseReplayDiff(LotseReplayDiffJob job) => diffLotseFrames(
  job.previous,
  job.next,
  width: job.width,
  height: job.height,
  previousWidth: job.previousWidth,
  previousHeight: job.previousHeight,
);

int Function() _stopwatchClock() {
  final watch = Stopwatch()..start();
  return () => watch.elapsedMilliseconds;
}
