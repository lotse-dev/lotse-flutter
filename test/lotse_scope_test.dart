import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_capture.dart';
import 'package:lotse/src/lotse_scope.dart';

const _white = Color(0xFFFFFFFF);
const _red = Color(0xFFFF0000);
const _black = Color(0xFF000000);

/// Runs [capture] the way the engine would: the capture waits for the end of
/// a frame, which a widget test only gets from a pump, and rasterizing needs
/// real async.
Future<LotseCaptureResult> _run(
  WidgetTester tester,
  Future<LotseCaptureResult> Function() capture,
) async {
  final result = await tester.runAsync(() async {
    final running = capture();
    await tester.pump();
    return running;
  });
  return result!;
}

/// Decodes [screenshot] and returns a function that reads the colour at a
/// logical position of the captured view.
Future<Color Function(double x, double y)> _pixels(
  WidgetTester tester,
  LotseScreenshot screenshot,
) async {
  final rgba = await tester.runAsync(() async {
    final codec = await ui.instantiateImageCodec(screenshot.png);
    final image = (await codec.getNextFrame()).image;
    expect(image.width, screenshot.width);
    expect(image.height, screenshot.height);
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return data!;
  });
  return (x, y) {
    final column = (x * screenshot.pixelRatio).floor();
    final row = (y * screenshot.pixelRatio).floor();
    final offset = (row * screenshot.width + column) * 4;
    return Color.fromARGB(
      rgba!.getUint8(offset + 3),
      rgba.getUint8(offset),
      rgba.getUint8(offset + 1),
      rgba.getUint8(offset + 2),
    );
  };
}

/// A white screen with a red 100 x 100 square at (50, 50), confidential or
/// not, and a second red square at (300, 50) that is never confidential.
Widget _screen({required bool confidential, void Function(BuildContext)? on}) {
  const secret = SizedBox(
    width: 100,
    height: 100,
    child: ColoredBox(color: _red),
  );
  return Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: _white,
      child: Stack(
        children: [
          Positioned(
            left: 50,
            top: 50,
            child: confidential
                ? const LotseConfidential(child: secret)
                : secret,
          ),
          const Positioned(left: 300, top: 50, child: secret),
          Builder(
            builder: (context) {
              on?.call(context);
              return const SizedBox();
            },
          ),
        ],
      ),
    ),
  );
}

/// Noise does not compress, so the PNG shrinks reliably with the pixel count.
class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(7);
    final paint = Paint();
    for (var y = 0.0; y < size.height; y += 4) {
      for (var x = 0.0; x < size.width; x += 4) {
        paint.color = Color(0xFF000000 | random.nextInt(0xFFFFFF));
        canvas.drawRect(Rect.fromLTWH(x, y, 4, 4), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_NoisePainter oldDelegate) => false;
}

void main() {
  group('Given a LotseScope around the app', () {
    testWidgets('when a screen is captured '
        'then the image is at most 1280 px and shows the screen', (
      tester,
    ) async {
      late BuildContext inside;
      await tester.pumpWidget(
        LotseScope(child: _screen(confidential: false, on: (c) => inside = c)),
      );

      final result = await _run(tester, () => captureLotseScreenshot(inside));

      final screenshot = (result as LotseCaptureSuccess).screenshot;
      // The test view is 800 x 600 logical pixels at a device ratio of 3.
      expect(screenshot.width, 1280);
      expect(screenshot.height, 960);
      expect(screenshot.png.lengthInBytes, lessThanOrEqualTo(1024 * 1024));
      final colorAt = await _pixels(tester, screenshot);
      expect(colorAt(100, 100), _red);
      expect(colorAt(350, 100), _red);
      expect(colorAt(10, 10), _white);
    });

    testWidgets('when a confidential region is captured '
        'then it is uniformly opaque black and the rest is untouched', (
      tester,
    ) async {
      late BuildContext inside;
      await tester.pumpWidget(
        LotseScope(child: _screen(confidential: true, on: (c) => inside = c)),
      );

      final result = await _run(tester, () => captureLotseScreenshot(inside));

      final screenshot = (result as LotseCaptureSuccess).screenshot;
      final colorAt = await _pixels(tester, screenshot);
      // A grid over the inside of the square, clear of the scaled edges.
      for (var y = 52.0; y < 149; y += 8) {
        for (var x = 52.0; x < 149; x += 8) {
          expect(colorAt(x, y), _black, reason: 'at ($x, $y)');
        }
      }
      expect(colorAt(350, 100), _red);
      expect(colorAt(200, 100), _white);
      expect(colorAt(100, 200), _white);
    });

    testWidgets('when a confidential region is captured '
        'then the screen keeps showing its child', (tester) async {
      late BuildContext inside;
      await tester.pumpWidget(
        LotseScope(child: _screen(confidential: true, on: (c) => inside = c)),
      );
      final controller = lotseCaptureControllerOf(inside)!;

      final result = await _run(tester, controller.capture);
      await tester.pump();

      expect(result, isA<LotseCaptureSuccess>());
      // The mask lives in the image only: what the boundary paints, and so
      // what the screen shows, is still the red square.
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byType(RepaintBoundary).first,
      );
      final image = await tester.runAsync(() => boundary.toImage());
      final data = await tester.runAsync(
        () => image!.toByteData(format: ui.ImageByteFormat.rawRgba),
      );
      final offset = (100 * image!.width + 100) * 4;
      expect(data!.getUint32(offset), 0xFF0000FF);
      image.dispose();
    });

    testWidgets('when two captures overlap then they share one result', (
      tester,
    ) async {
      late BuildContext inside;
      await tester.pumpWidget(
        LotseScope(child: _screen(confidential: true, on: (c) => inside = c)),
      );
      final controller = lotseCaptureControllerOf(inside)!;

      // Both are awaited inside runAsync: a future from the real zone never
      // completes for the fake-async zone of the test body.
      final results = await tester.runAsync(() async {
        final first = controller.capture();
        final second = controller.capture();
        await tester.pump();
        return [await first, await second];
      });

      expect(results![0], isA<LotseCaptureSuccess>());
      expect(results[1], same(results[0]));
    });

    testWidgets('when the scope is removed during a capture '
        'then the result is noBoundary and nothing is thrown', (tester) async {
      late BuildContext inside;
      await tester.pumpWidget(
        LotseScope(child: _screen(confidential: true, on: (c) => inside = c)),
      );
      final controller = lotseCaptureControllerOf(inside)!;

      final result = await tester.runAsync(() async {
        final running = controller.capture();
        await tester.pumpWidget(const SizedBox());
        return running;
      });

      expect(
        (result! as LotseCaptureFailed).failure,
        LotseCaptureFailure.noBoundary,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('Given no LotseScope', () {
    testWidgets('when a capture is requested then the result is noBoundary', (
      tester,
    ) async {
      late BuildContext inside;
      await tester.pumpWidget(
        _screen(confidential: true, on: (c) => inside = c),
      );

      final result = await captureLotseScreenshot(inside);

      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.noBoundary,
      );
    });

    testWidgets('when LotseConfidential is built then it shows its child', (
      tester,
    ) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: LotseConfidential(child: Text('DE89 3704 0044 0532 0130 00')),
        ),
      );

      expect(find.text('DE89 3704 0044 0532 0130 00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Given a controller with a small size limit', () {
    Future<LotseCaptureController> pumpNoise(
      WidgetTester tester, {
      required int maxBytes,
    }) async {
      final key = GlobalKey();
      final controller = LotseCaptureController(
        boundaryKey: key,
        maxBytes: maxBytes,
      );
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: CustomPaint(painter: _NoisePainter(), size: Size.infinite),
        ),
      );
      return controller;
    }

    Future<LotseScreenshot> fullSize(WidgetTester tester) async {
      final controller = await pumpNoise(tester, maxBytes: 1 << 30);
      final result = await _run(tester, controller.capture);
      return (result as LotseCaptureSuccess).screenshot;
    }

    testWidgets('when the first image is one byte too large '
        'then it is captured again at half the ratio', (tester) async {
      final full = await fullSize(tester);
      final controller = await pumpNoise(
        tester,
        maxBytes: full.png.lengthInBytes - 1,
      );

      final result = await _run(tester, controller.capture);

      final screenshot = (result as LotseCaptureSuccess).screenshot;
      expect(screenshot.pixelRatio, full.pixelRatio / 2);
      expect(screenshot.width, full.width / 2);
      expect(screenshot.height, full.height / 2);
      expect(
        screenshot.png.lengthInBytes,
        lessThan(full.png.lengthInBytes - 1),
      );
    });

    testWidgets('when no attempt fits then the result is tooLarge', (
      tester,
    ) async {
      final controller = await pumpNoise(tester, maxBytes: 16);

      // testWidgets checks debugPrint at the end of the body, before any
      // tear-down runs, so it is restored here.
      final logs = <String?>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message);

      final LotseCaptureResult result;
      try {
        result = await _run(tester, controller.capture);
      } finally {
        debugPrint = original;
      }

      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.tooLarge,
      );
      expect(logs.single, contains('stayed above 16 bytes'));
    });
  });
}
