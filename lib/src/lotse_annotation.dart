import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import 'lotse_capture.dart';
import 'lotse_log.dart';

/// The one colour of the pen. Fixed instead of themed: it has to stand out on
/// any screenshot, not match the app.
const lotseAnnotationColor = ui.Color(0xFFFF3B30);

/// Width of the pen as a share of the shorter edge of the image, so a stroke
/// looks the same in the editor and in the merged image.
const lotseAnnotationStrokeWidth = 0.012;

/// One freehand stroke on a screenshot.
///
/// Points are relative to the image, 0 to 1 on both axes. That keeps a stroke
/// independent of the size the editor happens to show the image at.
@immutable
class LotseStroke {
  /// Creates a stroke through [points].
  LotseStroke(Iterable<ui.Offset> points) : points = List.unmodifiable(points);

  /// The points of the stroke in the order they were drawn.
  final List<ui.Offset> points;
}

/// The strokes of one annotation session: drawing, undo and clear. Plain
/// Dart, the editor only renders it.
class LotseAnnotationController extends ChangeNotifier {
  /// Creates a session that starts with [strokes].
  LotseAnnotationController({Iterable<LotseStroke> strokes = const []})
    : _strokes = [...strokes];

  final List<LotseStroke> _strokes;
  List<ui.Offset>? _current;

  /// Every stroke, the one being drawn last.
  List<LotseStroke> get strokes => [
    ..._strokes,
    if (_current case final current?) LotseStroke(current),
  ];

  /// `true` if there is nothing to undo or clear.
  bool get isEmpty => _strokes.isEmpty && _current == null;

  /// Begins a stroke at [point]. A stroke that was still open is finished.
  void startStroke(ui.Offset point) {
    endStroke();
    _current = [_clamp(point)];
    notifyListeners();
  }

  /// Continues the open stroke to [point]. Does nothing without one.
  void extendStroke(ui.Offset point) {
    final current = _current;
    if (current == null) return;
    final clamped = _clamp(point);
    if (clamped == current.last) return;
    current.add(clamped);
    notifyListeners();
  }

  /// Finishes the open stroke. A stroke of a single point stays: it is a dot.
  void endStroke() {
    final current = _current;
    if (current == null) return;
    _strokes.add(LotseStroke(current));
    _current = null;
    notifyListeners();
  }

  /// Removes the last stroke, which is the open one while the user draws.
  void undo() {
    if (isEmpty) return;
    if (_current != null) {
      _current = null;
    } else {
      _strokes.removeLast();
    }
    notifyListeners();
  }

  /// Removes every stroke.
  void clear() {
    if (isEmpty) return;
    _strokes.clear();
    _current = null;
    notifyListeners();
  }

  // A finger that leaves the image keeps drawing along its edge.
  static ui.Offset _clamp(ui.Offset point) => ui.Offset(
    point.dx.isFinite ? point.dx.clamp(0.0, 1.0) : 0,
    point.dy.isFinite ? point.dy.clamp(0.0, 1.0) : 0,
  );
}

/// Paints [strokes] onto [canvas], scaled to an image of [size]. The editor
/// and the merge share it, so what the user sees is what is sent.
void paintLotseStrokes(
  ui.Canvas canvas,
  ui.Size size,
  List<LotseStroke> strokes,
) {
  final width = math.max(1.0, size.shortestSide * lotseAnnotationStrokeWidth);
  final line = ui.Paint()
    ..color = lotseAnnotationColor
    ..style = ui.PaintingStyle.stroke
    ..strokeWidth = width
    ..strokeCap = ui.StrokeCap.round
    ..strokeJoin = ui.StrokeJoin.round
    ..isAntiAlias = true;
  final dot = ui.Paint()
    ..color = lotseAnnotationColor
    ..isAntiAlias = true;

  for (final stroke in strokes) {
    final points = [
      for (final point in stroke.points)
        ui.Offset(point.dx * size.width, point.dy * size.height),
    ];
    if (points.isEmpty) continue;
    if (points.length == 1) {
      canvas.drawCircle(points.single, width / 2, dot);
      continue;
    }
    final path = ui.Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(path, line);
  }
}

/// Burns [strokes] into [screenshot] and returns the new PNG.
///
/// The image keeps its dimensions, so the edge limit of the capture still
/// holds. Strokes can make the PNG larger; the size limit is kept the same way
/// the capture keeps it, by rendering at half the scale and trying again.
/// Without strokes the screenshot comes back untouched. Never throws.
Future<LotseCaptureResult> mergeLotseAnnotation(
  LotseScreenshot screenshot,
  List<LotseStroke> strokes, {
  int maxBytes = maxScreenshotBytes,
}) async {
  if (strokes.isEmpty) return LotseCaptureSuccess(screenshot);
  ui.Image? original;
  try {
    final codec = await ui.instantiateImageCodec(screenshot.png);
    try {
      original = (await codec.getNextFrame()).image;
    } finally {
      codec.dispose();
    }
    final source = original;
    return await captureWithinLimit(
      pixelRatio: screenshot.pixelRatio,
      maxBytes: maxBytes,
      render: (ratio) =>
          _renderMerged(source, strokes, ratio, ratio / screenshot.pixelRatio),
    );
  } catch (error) {
    lotseLog('could not annotate the screenshot', error);
    return const LotseCaptureFailed(LotseCaptureFailure.renderFailed);
  } finally {
    original?.dispose();
  }
}

Future<LotseScreenshot?> _renderMerged(
  ui.Image original,
  List<LotseStroke> strokes,
  double pixelRatio,
  double scale,
) async {
  final width = math.max(1, (original.width * scale).round());
  final height = math.max(1, (original.height * scale).round());
  final size = ui.Size(width.toDouble(), height.toDouble());

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  canvas.drawImageRect(
    original,
    ui.Rect.fromLTWH(
      0,
      0,
      original.width.toDouble(),
      original.height.toDouble(),
    ),
    ui.Offset.zero & size,
    ui.Paint()..filterQuality = ui.FilterQuality.medium,
  );
  paintLotseStrokes(canvas, size, strokes);
  final picture = recorder.endRecording();
  try {
    final image = await picture.toImage(width, height);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) return null;
      return LotseScreenshot(
        png: data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        width: width,
        height: height,
        pixelRatio: pixelRatio,
      );
    } finally {
      image.dispose();
    }
  } finally {
    picture.dispose();
  }
}
