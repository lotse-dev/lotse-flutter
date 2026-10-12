import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Taps for heatmaps, see `docs/REPLAY.md`, "Taps im SDK". `LotseScope` feeds
// pointers into [LotseTapRecognizer]; recognised taps go to [lotseTapSink],
// which `Lotse.init(heatmaps: true)` points at a [LotseTapBuffer].

/// A layer above the screens, like an in-app card: taps on it belong to no
/// screen, so they stay out of the heatmap of the screen below. The replay
/// still shows them.
class LotseOffScreen extends SingleChildRenderObjectWidget {
  const LotseOffScreen({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderLotseOffScreen();
}

/// The render object of [LotseOffScreen]; `LotseScope` looks for it on the
/// hit path of a tap.
class RenderLotseOffScreen extends RenderProxyBox {}

/// Longest press that still counts as a tap.
const lotseTapMaxDuration = Duration(milliseconds: 500);

/// Rage burst: at least this many taps ...
const lotseRageMinTaps = 3;

/// ... within this time ...
const lotseRageWindow = Duration(seconds: 1);

/// ... each at most this many logical pixels from the first.
const lotseRageRadius = 30.0;

/// The buffer sends once it holds this many taps.
const lotseTapFlushCount = 100;

/// The buffer sends at least this often while it holds taps.
const lotseTapFlushInterval = Duration(seconds: 30);

/// Taps in one call; the server takes at most 200.
const lotseTapsPerCall = 200;

/// Taps kept while the server cannot be reached. The oldest go first.
const lotseTapBufferLimit = 1000;

/// Stored taps older than this are not sent on a later start; the server
/// drops them as well.
const lotseTapMaxAge = Duration(hours: 24);

/// One tap, in logical pixels inside the `LotseScope` boundary. Heatmaps
/// only get taps on a named screen; the replay also those on dialogs.
@immutable
class LotseTap {
  const LotseTap({
    required this.screen,
    required this.ts,
    required this.x,
    required this.y,
    required this.scrollY,
    required this.viewportWidth,
    required this.viewportHeight,
    this.rage = false,
  });

  /// Null while no named page is on top, e.g. under a dialog.
  final String? screen;
  final DateTime ts;
  final int x;
  final int y;

  /// Offset of the innermost vertical scroll view under the tap on pointer
  /// down; null outside of one.
  final int? scrollY;
  final int viewportWidth;
  final int viewportHeight;

  /// Part of a rage burst, see [markRageTaps].
  final bool rage;

  Map<String, Object?> toJson() => {
    'screen': screen,
    'ts': ts.toUtc().toIso8601String(),
    'x': x,
    'y': y,
    'scrollY': scrollY,
    'w': viewportWidth,
    'h': viewportHeight,
    'rage': rage,
  };

  /// The tap in [json], or null when it is not one.
  static LotseTap? fromJson(Object? json) {
    if (json is! Map) return null;
    final ts = json['ts'];
    final time = ts is String ? DateTime.tryParse(ts) : null;
    final screen = json['screen'];
    final x = json['x'];
    final y = json['y'];
    final scrollY = json['scrollY'];
    final width = json['w'];
    final height = json['h'];
    final rage = json['rage'];
    if (time == null ||
        (screen != null && screen is! String) ||
        x is! int ||
        y is! int ||
        (scrollY != null && scrollY is! int) ||
        width is! int ||
        height is! int ||
        rage is! bool) {
      return null;
    }
    return LotseTap(
      screen: screen as String?,
      ts: time.toUtc(),
      x: x,
      y: y,
      scrollY: scrollY as int?,
      viewportWidth: width,
      viewportHeight: height,
      rage: rage,
    );
  }

  LotseTap asRage() => LotseTap(
    screen: screen,
    ts: ts,
    x: x,
    y: y,
    scrollY: scrollY,
    viewportWidth: viewportWidth,
    viewportHeight: viewportHeight,
    rage: true,
  );
}

/// What a pointer down knew about its tap: everything but the outcome.
class LotseTapStart {
  const LotseTapStart({
    required this.screen,
    required this.ts,
    required this.position,
    required this.local,
    required this.time,
    required this.slop,
    required this.scrollY,
    required this.viewport,
  });

  final String? screen;

  /// Wall clock of the down, the time the tap is reported with.
  final DateTime ts;

  /// Global position, to measure movement against.
  final Offset position;

  /// Position inside the boundary.
  final Offset local;

  /// Event time of the down, to measure the duration against.
  final Duration time;

  /// How far the pointer may move and still tap, see `computeHitSlop`.
  final double slop;
  final int? scrollY;
  final Size viewport;
}

/// Turns downs, moves and ups into taps: up within [lotseTapMaxDuration] of
/// the down, without moving further than its slop in between. Dragging and
/// scrolling are no taps. Pure, one instance per `LotseScope`.
class LotseTapRecognizer {
  final _open = <int, LotseTapStart>{};

  /// A pointer [pointer] went down.
  void down(int pointer, LotseTapStart start) => _open[pointer] = start;

  /// The pointer moved to the global [position].
  void move(int pointer, Offset position) {
    final start = _open[pointer];
    if (start == null) return;
    if ((position - start.position).distance > start.slop) {
      _open.remove(pointer);
    }
  }

  /// The pointer went up at event time [time]. Returns the tap, if it was one.
  LotseTap? up(int pointer, Duration time) {
    final start = _open.remove(pointer);
    if (start == null) return null;
    if (time - start.time > lotseTapMaxDuration) return null;
    return LotseTap(
      screen: start.screen,
      ts: start.ts,
      x: start.local.dx.round(),
      y: start.local.dy.round(),
      scrollY: start.scrollY,
      viewportWidth: start.viewport.width.round(),
      viewportHeight: start.viewport.height.round(),
    );
  }

  /// The pointer was cancelled, e.g. a scroll view took it over.
  void cancel(int pointer) => _open.remove(pointer);
}

/// [taps] with every tap of a rage burst marked: at least [lotseRageMinTaps]
/// taps in a row on one screen within [lotseRageWindow], each at most
/// [lotseRageRadius] from the first. [taps] must be sorted by time. Taps
/// marked before stay marked.
List<LotseTap> markRageTaps(List<LotseTap> taps) {
  final rage = List<bool>.generate(taps.length, (i) => taps[i].rage);
  final byScreen = <String?, List<int>>{};
  for (var i = 0; i < taps.length; i++) {
    (byScreen[taps[i].screen] ??= []).add(i);
  }
  for (final indices in byScreen.values) {
    for (var a = 0; a < indices.length; a++) {
      final first = taps[indices[a]];
      var end = a;
      while (end + 1 < indices.length) {
        final next = taps[indices[end + 1]];
        if (next.ts.difference(first.ts) > lotseRageWindow) break;
        final dx = (next.x - first.x).toDouble();
        final dy = (next.y - first.y).toDouble();
        if (math.sqrt(dx * dx + dy * dy) > lotseRageRadius) break;
        end++;
      }
      if (end - a + 1 < lotseRageMinTaps) continue;
      for (var k = a; k <= end; k++) {
        rage[indices[k]] = true;
      }
    }
  }
  return [
    for (var i = 0; i < taps.length; i++)
      rage[i] && !taps[i].rage ? taps[i].asRage() : taps[i],
  ];
}

/// Sends a batch of taps. Throws when the server did not take it.
typedef LotseTapSender = Future<void> Function(List<LotseTap> taps);

/// Collects taps and sends them in batches: every [lotseTapFlushInterval],
/// from [lotseTapFlushCount] taps, and when [flush] is called (the app goes
/// to the background). Never one call per tap. Rage taps are marked right
/// before sending, so a burst is seen whole while it sits in the buffer.
///
/// A failed batch goes back into the buffer, at most [lotseTapBufferLimit]
/// taps; older ones are dropped. Failures are logged, never thrown.
///
/// With a [_store], what is not sent survives the end of the app: the buffer
/// is stored when the app is hidden ([persist]) and after every send, and
/// [restore] takes it back on the next start, for the same install only.
class LotseTapBuffer {
  LotseTapBuffer(this._send, {this._store, this._installId});

  final LotseTapSender _send;
  final LotseTapStore? _store;
  final String? Function()? _installId;
  var _taps = <LotseTap>[];
  Timer? _timer;
  Future<void>? _sending;

  /// Taps waiting to be sent.
  @visibleForTesting
  List<LotseTap> get pending => List.unmodifiable(_taps);

  void add(LotseTap tap) {
    _taps.add(tap);
    if (_taps.length > lotseTapBufferLimit) {
      _taps = _taps.sublist(_taps.length - lotseTapBufferLimit);
    }
    if (_taps.length >= lotseTapFlushCount) {
      unawaited(flush());
    } else {
      _schedule();
    }
  }

  void _schedule() {
    _timer ??= Timer(lotseTapFlushInterval, () {
      _timer = null;
      unawaited(flush());
    });
  }

  /// Takes back what an earlier run stored for the current install and was
  /// not older than [lotseTapMaxAge]. Call it before the first tap arrives.
  Future<void> restore({DateTime? now}) async {
    final store = _store;
    final installId = _currentInstallId();
    if (store == null || installId == null) return;
    try {
      final stored = await store.read();
      if (stored == null || stored.installId != installId) return;
      final oldest = (now ?? DateTime.now()).subtract(lotseTapMaxAge);
      final back = [
        for (final tap in stored.taps)
          if (!tap.ts.isBefore(oldest)) tap,
        ..._taps,
      ];
      _taps = back.length > lotseTapBufferLimit
          ? back.sublist(back.length - lotseTapBufferLimit)
          : back;
      if (_taps.isNotEmpty) _schedule();
    } catch (error) {
      debugPrint('Lotse: could not read the stored taps: ${error.runtimeType}');
    }
  }

  /// Stores what the buffer holds for the current install, or removes the
  /// stored taps when it holds none.
  Future<void> persist() async {
    final store = _store;
    final installId = _currentInstallId();
    if (store == null || installId == null) return;
    try {
      if (_taps.isEmpty) {
        await store.clear();
      } else {
        await store.write(installId, List.unmodifiable(_taps));
      }
    } catch (error) {
      debugPrint('Lotse: could not store the taps: ${error.runtimeType}');
    }
  }

  String? _currentInstallId() {
    try {
      return _installId?.call();
    } catch (_) {
      return null;
    }
  }

  /// Sends what the buffer holds. Waits for a send already running first.
  Future<void> flush() async {
    for (var running = _sending; running != null; running = _sending) {
      await running;
    }
    _timer?.cancel();
    _timer = null;
    if (_taps.isEmpty) return;
    final sending = _sendAll();
    _sending = sending;
    try {
      await sending;
    } finally {
      _sending = null;
    }
    // What was sent must not come back on the next start.
    await persist();
  }

  Future<void> _sendAll() async {
    final taps = markRageTaps(_taps);
    _taps = [];
    for (var start = 0; start < taps.length; start += lotseTapsPerCall) {
      final batch = taps.sublist(
        start,
        math.min(start + lotseTapsPerCall, taps.length),
      );
      try {
        await _send(batch);
      } catch (error) {
        debugPrint('Lotse: could not send taps: ${error.runtimeType}');
        // What arrived since goes after what could not be sent.
        final back = [...taps.sublist(start), ..._taps];
        _taps = back.length > lotseTapBufferLimit
            ? back.sublist(back.length - lotseTapBufferLimit)
            : back;
        _schedule();
        return;
      }
    }
  }

  /// Drops what the buffer holds and what it stored, e.g. when the identity
  /// ends.
  void clear() {
    _timer?.cancel();
    _timer = null;
    _taps = [];
    if (_store case final store?) {
      unawaited(
        store.clear().catchError((Object error) {
          debugPrint('Lotse: could not drop the taps: ${error.runtimeType}');
        }),
      );
    }
  }

  /// Stops the timer. What is stored stays for the next start.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _taps = [];
  }
}

/// Where taps wait between app starts, with the install they belong to.
abstract interface class LotseTapStore {
  Future<({String installId, List<LotseTap> taps})?> read();
  Future<void> write(String installId, List<LotseTap> taps);
  Future<void> clear();
}

/// Keeps the taps in the shared preferences, like the event queue.
class PreferencesLotseTapStore implements LotseTapStore {
  PreferencesLotseTapStore(this._preferences);

  static const _key = 'lotse.tapQueue';

  final SharedPreferences? _preferences;

  @override
  Future<({String installId, List<LotseTap> taps})?> read() async {
    final stored = _preferences?.getString(_key);
    if (stored == null) return null;
    final Object? json;
    try {
      json = jsonDecode(stored);
    } on FormatException {
      return null;
    }
    if (json is! Map) return null;
    final installId = json['installId'];
    final taps = json['taps'];
    if (installId is! String || taps is! List) return null;
    return (
      installId: installId,
      taps: [for (final tap in taps) ?LotseTap.fromJson(tap)],
    );
  }

  @override
  Future<void> write(String installId, List<LotseTap> taps) async {
    await _preferences?.setString(
      _key,
      jsonEncode({
        'installId': installId,
        'taps': [for (final tap in taps) tap.toJson()],
      }),
    );
  }

  @override
  Future<void> clear() async => _preferences?.remove(_key);
}

/// Receives the taps `LotseScope` recognises. Null while heatmaps are off,
/// then the scope does not even look at pointers.
typedef LotseTapSink = void Function(LotseTap tap);

/// Where `LotseScope` reports taps. `Lotse.init(heatmaps: true)` sets it.
LotseTapSink? lotseTapSink;
