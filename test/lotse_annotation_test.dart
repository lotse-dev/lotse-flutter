import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_annotation.dart';
import 'package:lotse/src/lotse_capture.dart';

const _white = ui.Color(0xFFFFFFFF);

/// A white screenshot of [width] by [height] pixels.
Future<LotseScreenshot> _whiteScreenshot(int width, int height) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    ui.Paint()..color = _white,
  );
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  picture.dispose();
  return LotseScreenshot(
    png: data!.buffer.asUint8List(),
    width: width,
    height: height,
    pixelRatio: 2,
  );
}

/// The decoded size of [png] and a function that reads the colour at a
/// relative position.
Future<(int, int, ui.Color Function(double dx, double dy))> _decode(
  Uint8List png,
) async {
  final codec = await ui.instantiateImageCodec(png);
  final image = (await codec.getNextFrame()).image;
  final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final width = image.width;
  final height = image.height;
  image.dispose();
  codec.dispose();
  ui.Color colorAt(double dx, double dy) {
    final x = (width * dx).floor().clamp(0, width - 1);
    final y = (height * dy).floor().clamp(0, height - 1);
    final offset = (y * width + x) * 4;
    return ui.Color.fromARGB(
      data!.getUint8(offset + 3),
      data.getUint8(offset),
      data.getUint8(offset + 1),
      data.getUint8(offset + 2),
    );
  }

  return (width, height, colorAt);
}

void main() {
  setUp(() {
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) {};
    addTearDown(() => debugPrint = original);
  });

  group('Given an annotation session', () {
    test('when the user draws then the stroke grows and ends as one', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications++);

      expect(controller.isEmpty, isTrue);
      controller.startStroke(const ui.Offset(0.1, 0.1));
      controller.extendStroke(const ui.Offset(0.2, 0.2));
      // The open stroke is already visible.
      expect(controller.strokes.single.points, hasLength(2));
      controller.extendStroke(const ui.Offset(0.3, 0.2));
      controller.endStroke();

      expect(controller.strokes.single.points, const [
        ui.Offset(0.1, 0.1),
        ui.Offset(0.2, 0.2),
        ui.Offset(0.3, 0.2),
      ]);
      expect(controller.isEmpty, isFalse);
      expect(notifications, 4);
    });

    test('when the finger does not move then no point is added twice', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);

      controller.startStroke(const ui.Offset(0.5, 0.5));
      controller.extendStroke(const ui.Offset(0.5, 0.5));
      controller.endStroke();

      expect(controller.strokes.single.points, const [ui.Offset(0.5, 0.5)]);
    });

    test('when the finger leaves the image '
        'then the stroke runs along the edge', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);

      controller.startStroke(const ui.Offset(-0.2, 0.5));
      controller.extendStroke(const ui.Offset(1.4, 2));
      controller.extendStroke(const ui.Offset(double.nan, 0.5));
      controller.endStroke();

      expect(controller.strokes.single.points, const [
        ui.Offset(0, 0.5),
        ui.Offset(1, 1),
        ui.Offset(0, 0.5),
      ]);
    });

    test('when nothing was started then extending and ending do nothing', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.extendStroke(const ui.Offset(0.5, 0.5));
      controller.endStroke();

      expect(controller.strokes, isEmpty);
      expect(notifications, 0);
    });

    test('when undo is used then the last stroke goes, one at a time', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);
      for (final x in [0.1, 0.2, 0.3]) {
        controller
          ..startStroke(ui.Offset(x, 0))
          ..extendStroke(ui.Offset(x, 1))
          ..endStroke();
      }

      controller.undo();

      expect(controller.strokes.map((stroke) => stroke.points.first.dx), [
        0.1,
        0.2,
      ]);

      controller
        ..undo()
        ..undo();
      expect(controller.isEmpty, isTrue);

      // Nothing left: no change, no notification.
      var notifications = 0;
      controller.addListener(() => notifications++);
      controller.undo();
      expect(notifications, 0);
    });

    test('when undo is used while drawing '
        'then the open stroke goes and the finished ones stay', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);
      controller
        ..startStroke(const ui.Offset(0.1, 0))
        ..endStroke()
        ..startStroke(const ui.Offset(0.9, 0));

      controller.undo();
      controller.extendStroke(const ui.Offset(0.9, 1));

      expect(controller.strokes.single.points, const [ui.Offset(0.1, 0)]);
    });

    test('when clear is used then every stroke goes', () {
      final controller = LotseAnnotationController();
      addTearDown(controller.dispose);
      controller
        ..startStroke(const ui.Offset(0.1, 0))
        ..endStroke()
        ..startStroke(const ui.Offset(0.9, 0));
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.clear();

      expect(controller.strokes, isEmpty);
      expect(controller.isEmpty, isTrue);
      expect(notifications, 1);
      controller.clear();
      expect(notifications, 1);
    });

    test('when the session starts with strokes '
        'then they can be undone and the given list is left alone', () {
      final earlier = [
        LotseStroke(const [ui.Offset(0, 0), ui.Offset(1, 1)]),
      ];
      final controller = LotseAnnotationController(strokes: earlier);
      addTearDown(controller.dispose);

      expect(controller.strokes, hasLength(1));
      controller.undo();

      expect(controller.strokes, isEmpty);
      expect(earlier, hasLength(1));
    });

    test('when a stroke is created then its points cannot be changed', () {
      final points = [const ui.Offset(0, 0)];
      final stroke = LotseStroke(points);
      points.add(const ui.Offset(1, 1));

      expect(stroke.points, hasLength(1));
      expect(() => stroke.points.add(ui.Offset.zero), throwsUnsupportedError);
    });
  });

  group('Given a screenshot and strokes', () {
    test('when they are merged '
        'then the image keeps its dimensions, shows the pen where the stroke '
        'is and the original everywhere else', () async {
      final screenshot = await _whiteScreenshot(200, 400);
      final strokes = [
        LotseStroke(const [ui.Offset(0.1, 0.25), ui.Offset(0.9, 0.25)]),
      ];

      final result = await mergeLotseAnnotation(screenshot, strokes);

      final merged = (result as LotseCaptureSuccess).screenshot;
      expect(merged.png, isNot(equals(screenshot.png)));
      expect((merged.width, merged.height), (200, 400));
      expect(merged.pixelRatio, 2);
      final (width, height, colorAt) = await _decode(merged.png);
      expect((width, height), (200, 400));
      expect(colorAt(0.5, 0.25), lotseAnnotationColor);
      expect(colorAt(0.5, 0.75), _white);
      expect(colorAt(0.02, 0.25), _white);
    });

    test('when a stroke is a single point then it is a dot', () async {
      final screenshot = await _whiteScreenshot(400, 400);

      final result = await mergeLotseAnnotation(screenshot, [
        LotseStroke(const [ui.Offset(0.5, 0.5)]),
      ]);

      final merged = (result as LotseCaptureSuccess).screenshot;
      final (_, _, colorAt) = await _decode(merged.png);
      expect(colorAt(0.5, 0.5), lotseAnnotationColor);
      expect(colorAt(0.6, 0.5), _white);
    });

    test('when there are no strokes '
        'then the screenshot comes back untouched', () async {
      final screenshot = await _whiteScreenshot(20, 20);

      final result = await mergeLotseAnnotation(screenshot, const []);

      expect((result as LotseCaptureSuccess).screenshot, same(screenshot));
    });

    test('when the merged image is above the size limit '
        'then it is rendered at half the scale, strokes included', () async {
      final screenshot = await _whiteScreenshot(400, 800);
      final strokes = [
        LotseStroke(const [ui.Offset(0.1, 0.25), ui.Offset(0.9, 0.25)]),
      ];
      final full =
          (await mergeLotseAnnotation(screenshot, strokes)
                  as LotseCaptureSuccess)
              .screenshot;

      final result = await mergeLotseAnnotation(
        screenshot,
        strokes,
        maxBytes: full.png.lengthInBytes - 1,
      );

      final merged = (result as LotseCaptureSuccess).screenshot;
      expect((merged.width, merged.height), (200, 400));
      expect(merged.pixelRatio, 1);
      expect(merged.png.lengthInBytes, lessThan(full.png.lengthInBytes));
      final (width, height, colorAt) = await _decode(merged.png);
      expect((width, height), (200, 400));
      expect(colorAt(0.5, 0.25), lotseAnnotationColor);
    });

    test('when no scale fits the size limit then the merge fails', () async {
      final screenshot = await _whiteScreenshot(64, 64);

      final result = await mergeLotseAnnotation(screenshot, [
        LotseStroke(const [ui.Offset(0, 0), ui.Offset(1, 1)]),
      ], maxBytes: 8);

      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.tooLarge,
      );
    });

    test('when the bytes are not an image '
        'then the merge fails and nothing is thrown', () async {
      final broken = LotseScreenshot(
        png: Uint8List.fromList([1, 2, 3]),
        width: 10,
        height: 10,
        pixelRatio: 1,
      );

      final result = await mergeLotseAnnotation(broken, [
        LotseStroke(const [ui.Offset(0, 0), ui.Offset(1, 1)]),
      ]);

      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.renderFailed,
      );
    });
  });
}
