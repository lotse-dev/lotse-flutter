import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'lotse_masks.dart';
import 'lotse_retake.dart';
import 'lotse_log.dart';

/// Longest edge of a screenshot in pixels. The server checks the same limit.
const maxScreenshotEdge = 1280;

/// Largest encoded screenshot in bytes. The server checks the same limit.
const maxScreenshotBytes = 1024 * 1024;

/// How often a capture is rendered at most: once at the computed pixel ratio,
/// then at a half and a quarter of it.
const maxCaptureAttempts = 3;

/// Why a screenshot could not be taken.
enum LotseCaptureFailure {
  /// There is no `LotseScope` above the caller, or it is not laid out yet.
  noBoundary,

  /// The boundary could not be rasterized or encoded. Platform views such as
  /// maps and web views cause this.
  renderFailed,

  /// The image stayed above the size limit after every retry.
  tooLarge,

  /// Anything else.
  unknown,
}

/// A captured screenshot, encoded as PNG.
class LotseScreenshot {
  /// Creates a screenshot.
  const LotseScreenshot({
    required this.png,
    required this.width,
    required this.height,
    required this.pixelRatio,
  });

  /// The PNG file.
  final Uint8List png;

  /// Width in pixels.
  final int width;

  /// Height in pixels.
  final int height;

  /// The pixel ratio the image was rendered at.
  final double pixelRatio;
}

/// The outcome of a capture: [LotseCaptureSuccess] or [LotseCaptureFailed].
sealed class LotseCaptureResult {
  const LotseCaptureResult();
}

/// The capture produced a screenshot within the limits.
class LotseCaptureSuccess extends LotseCaptureResult {
  /// Creates a successful result.
  const LotseCaptureSuccess(this.screenshot);

  /// The screenshot.
  final LotseScreenshot screenshot;
}

/// The capture failed for the reason in [failure].
class LotseCaptureFailed extends LotseCaptureResult {
  /// Creates a failed result.
  const LotseCaptureFailed(this.failure);

  /// Why it failed.
  final LotseCaptureFailure failure;
}

/// The pixel ratio to render [logicalSize] at so that the longest edge of the
/// image is at most [maxEdge] pixels, never above [devicePixelRatio].
///
/// Rasterizing rounds the image size up, so the edge limit aims half a pixel
/// below [maxEdge]: floating point noise must not produce 1281 pixels, which
/// the server would reject. Returns 0 for an empty size or a ratio that is not
/// positive.
double capturePixelRatio({
  required Size logicalSize,
  required double devicePixelRatio,
  int maxEdge = maxScreenshotEdge,
}) {
  final longest = math.max(logicalSize.width, logicalSize.height);
  if (!longest.isFinite || longest <= 0) return 0;
  if (!devicePixelRatio.isFinite || devicePixelRatio <= 0) return 0;
  if ((longest * devicePixelRatio).ceil() <= maxEdge) return devicePixelRatio;
  return math.min(devicePixelRatio, (maxEdge - 0.5) / longest);
}

/// Renders through [render] at [pixelRatio] and halves the ratio while the
/// result is larger than [maxBytes], for at most [maxAttempts] attempts.
///
/// [render] returns `null` or throws if the image cannot be produced, which
/// ends the loop with [LotseCaptureFailure.renderFailed]. Takes the rendering
/// as a function so the size policy can be tested without a render tree.
Future<LotseCaptureResult> captureWithinLimit({
  required double pixelRatio,
  required Future<LotseScreenshot?> Function(double pixelRatio) render,
  int maxBytes = maxScreenshotBytes,
  int maxAttempts = maxCaptureAttempts,
}) async {
  if (pixelRatio <= 0) {
    return const LotseCaptureFailed(LotseCaptureFailure.noBoundary);
  }
  var ratio = pixelRatio;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final LotseScreenshot? screenshot;
    try {
      screenshot = await render(ratio);
    } catch (error) {
      lotseLog('could not render the screenshot', error);
      return const LotseCaptureFailed(LotseCaptureFailure.renderFailed);
    }
    if (screenshot == null) {
      debugPrint('Lotse: could not encode the screenshot.');
      return const LotseCaptureFailed(LotseCaptureFailure.renderFailed);
    }
    if (screenshot.png.lengthInBytes <= maxBytes) {
      return LotseCaptureSuccess(screenshot);
    }
    ratio /= 2;
  }
  debugPrint('Lotse: the screenshot stayed above $maxBytes bytes.');
  return const LotseCaptureFailed(LotseCaptureFailure.tooLarge);
}

/// Takes screenshots of the boundary behind [boundaryKey], with the regions
/// of `collectLotseMasks` blacked out in the image. The screen does not
/// change. Owned by the `LotseScope` state.
class LotseCaptureController {
  /// Creates a controller for the boundary behind [boundaryKey].
  LotseCaptureController({
    required this.boundaryKey,
    this.maxBytes = maxScreenshotBytes,
    bool Function()? maskAllText,
  }) : _maskAllText = maskAllText ?? (() => false);

  /// The key of the `RepaintBoundary` that is captured.
  final GlobalKey boundaryKey;

  /// The size limit of the encoded image.
  final int maxBytes;

  final bool Function() _maskAllText;

  /// The open "Retake" of a feedback sheet, shown as a floating bar by the
  /// scope.
  final LotseRetakeController retake = LotseRetakeController();

  Future<LotseCaptureResult>? _running;
  bool _disposed = false;

  /// Captures the boundary. Never throws; a second call during a capture
  /// gets the result of the running one.
  Future<LotseCaptureResult> capture() =>
      _running ??= _capture().whenComplete(() => _running = null);

  /// Releases the retake controller. A capture that is still running ends
  /// quietly.
  void dispose() {
    _disposed = true;
    retake.dispose();
  }

  Future<LotseCaptureResult> _capture() async {
    try {
      if (_disposed) {
        return const LotseCaptureFailed(LotseCaptureFailure.noBoundary);
      }
      // Layout and paint must be done for the tree and the image to agree.
      await WidgetsBinding.instance.endOfFrame;

      final context = boundaryKey.currentContext;
      final boundary = context?.findRenderObject();
      if (context == null ||
          !context.mounted ||
          boundary is! RenderRepaintBoundary ||
          !boundary.hasSize) {
        return const LotseCaptureFailed(LotseCaptureFailure.noBoundary);
      }
      final pixelRatio = capturePixelRatio(
        logicalSize: boundary.size,
        devicePixelRatio: View.of(context).devicePixelRatio,
      );
      return await captureWithinLimit(
        pixelRatio: pixelRatio,
        maxBytes: maxBytes,
        render: (ratio) => _render(boundary, ratio),
      );
    } catch (error) {
      lotseLog('could not capture the screen', error);
      return const LotseCaptureFailed(LotseCaptureFailure.unknown);
    }
  }

  Future<LotseScreenshot?> _render(
    RenderRepaintBoundary boundary,
    double pixelRatio,
  ) async {
    // Masks and image from the same frame: nothing can draw between the
    // walk and the snapshot, which both run before the next await.
    final masks = collectLotseMasks(boundary, maskAllText: _maskAllText());
    final image = await paintLotseMasks(
      await boundary.toImage(pixelRatio: pixelRatio),
      masks,
      pixelRatio,
    );
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return null;
      return LotseScreenshot(
        png: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        width: image.width,
        height: image.height,
        pixelRatio: pixelRatio,
      );
    } finally {
      image.dispose();
    }
  }
}
