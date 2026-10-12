import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

// Heatmap backgrounds, see `docs/REPLAY.md`, "Hintergrundbilder". The server
// names in its answer to the taps which screens it has no picture of yet;
// `LotseScope` takes one once such a screen has been still for a second.

/// Which builds take heatmap backgrounds.
enum LotseBackgrounds {
  /// Debug and profile builds only. The developer opens each screen once on
  /// their own device, and no background shows the screen of an end user.
  developmentBuilds,

  /// Release builds too. Backgrounds may then come from end users' devices;
  /// `LotseConfidential` regions are blacked out as in feedback screenshots.
  allBuilds,
}

/// Whether a build takes backgrounds under [setting].
bool lotseBackgroundsEnabled(
  LotseBackgrounds setting, {
  required bool isReleaseBuild,
}) => switch (setting) {
  LotseBackgrounds.developmentBuilds => !isReleaseBuild,
  LotseBackgrounds.allBuilds => true,
};

/// Width class of a boundary [width] logical pixels wide, as on the server:
/// narrow below 360, regular up to 599, wide from 600.
enum LotseWidthClass { narrow, regular, wide }

LotseWidthClass lotseWidthClassOf(double width) {
  if (width < 360) return LotseWidthClass.narrow;
  if (width < 600) return LotseWidthClass.regular;
  return LotseWidthClass.wide;
}

/// A background the server asked for.
typedef LotseBackgroundSlot = ({String screen, LotseWidthClass widthClass});

/// A background ready to send.
class LotseBackgroundShot {
  const LotseBackgroundShot({
    required this.screen,
    required this.scrollY,
    required this.width,
    required this.height,
    required this.image,
  });

  final String screen;

  /// Offset of the vertical scroll view in the middle of the screen, 0
  /// outside of one.
  final int scrollY;

  /// Logical size of the boundary.
  final int width;
  final int height;
  final Uint8List image;
}

/// Sends a background to the server.
typedef LotseBackgroundUploader =
    Future<void> Function(LotseBackgroundShot shot);

/// Where `LotseScope` sends backgrounds. Set by `Lotse.init` when heatmaps
/// are on and this build takes backgrounds; null otherwise.
LotseBackgroundUploader? lotseBackgroundUploader;

/// The backgrounds the server asked for and nobody has taken yet.
final lotseWantedBackgrounds = ValueNotifier<Set<LotseBackgroundSlot>>({});

/// Adds [slots] to [lotseWantedBackgrounds].
void wantLotseBackgrounds(Iterable<LotseBackgroundSlot> slots) {
  final next = {...lotseWantedBackgrounds.value, ...slots};
  if (next.length == lotseWantedBackgrounds.value.length) return;
  lotseWantedBackgrounds.value = next;
}

/// How often the watcher looks whether a wanted screen is still.
const lotseBackgroundTick = Duration(milliseconds: 500);

/// Ticks without a frame before a screen counts as still: one second.
const lotseBackgroundQuietTicks = 2;

/// The slot of [wanted] that fits [screen] at [width], or null.
LotseBackgroundSlot? lotseDueBackground({
  required Set<LotseBackgroundSlot> wanted,
  required String? screen,
  required double? width,
}) {
  if (screen == null || width == null || width <= 0) return null;
  final slot = (screen: screen, widthClass: lotseWidthClassOf(width));
  return wanted.contains(slot) ? slot : null;
}

/// What the scope knows about the screen right now.
typedef LotseBackgroundView = ({String? screen, Size? size, int scrollY});

/// Takes a background once a wanted screen has been still for a second: no
/// frame was drawn for [lotseBackgroundQuietTicks] ticks in a row. Runs a
/// timer only while [wanted] is not empty. One per `LotseScope`.
class LotseBackgroundWatcher {
  LotseBackgroundWatcher({
    required this.view,
    required this.capture,
    ValueNotifier<Set<LotseBackgroundSlot>>? wanted,
    LotseBackgroundUploader? Function()? uploader,
  }) : _wanted = wanted ?? lotseWantedBackgrounds,
       _uploader = uploader ?? (() => lotseBackgroundUploader) {
    _wanted.addListener(_update);
    _update();
  }

  /// The screen, the size of the boundary and its scroll offset now.
  final LotseBackgroundView Function() view;

  /// A PNG of the boundary, or null when it could not be taken.
  final Future<Uint8List?> Function() capture;

  final ValueNotifier<Set<LotseBackgroundSlot>> _wanted;
  final LotseBackgroundUploader? Function() _uploader;
  Timer? _timer;
  var _framed = false;
  var _quiet = 0;
  var _busy = false;
  var _disposed = false;

  void _update() {
    if (_disposed) return;
    if (_wanted.value.isEmpty) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    if (_timer != null) return;
    _quiet = 0;
    _framed = false;
    _watchFrames();
    _timer = Timer.periodic(lotseBackgroundTick, (_) => _tick());
  }

  // A post-frame callback does not schedule frames, so this costs nothing
  // while the app is still.
  void _watchFrames() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_disposed || _timer == null) return;
      _framed = true;
      _watchFrames();
    });
  }

  void _tick() {
    if (_framed) {
      _framed = false;
      _quiet = 0;
      return;
    }
    _quiet++;
    if (_quiet < lotseBackgroundQuietTicks || _busy) return;
    final now = view();
    final slot = lotseDueBackground(
      wanted: _wanted.value,
      screen: now.screen,
      width: now.size?.width,
    );
    if (slot != null) unawaited(_take(slot, now));
  }

  Future<void> _take(
    LotseBackgroundSlot slot,
    LotseBackgroundView before,
  ) async {
    final upload = _uploader();
    if (upload == null) return;
    _busy = true;
    // Asked once: a failed attempt comes back with the next answer to taps.
    _wanted.value = {..._wanted.value}..remove(slot);
    try {
      final image = await capture();
      // The user may have moved on while the image was taken.
      if (image == null || view().screen != slot.screen) return;
      final size = before.size!;
      await upload(
        LotseBackgroundShot(
          screen: slot.screen,
          scrollY: before.scrollY,
          width: size.width.round(),
          height: size.height.round(),
          image: image,
        ),
      );
    } catch (error) {
      debugPrint(
        'Lotse: could not send a heatmap background: '
        '${error.runtimeType}',
      );
    } finally {
      _busy = false;
    }
  }

  void dispose() {
    _disposed = true;
    _wanted.removeListener(_update);
    _timer?.cancel();
    _timer = null;
  }
}
