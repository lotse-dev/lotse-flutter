import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_capture.dart';

LotseScreenshot _shot(int bytes, double ratio) => LotseScreenshot(
  png: Uint8List(bytes),
  width: 10,
  height: 10,
  pixelRatio: ratio,
);

void main() {
  setUp(() {
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) {};
    addTearDown(() => debugPrint = original);
  });

  group('Given capturePixelRatio', () {
    // (description, logical size, device pixel ratio, expected ratio)
    final cases = <(String, Size, double, double)>[
      (
        'a phone at 3x is limited by its height',
        const Size(412, 915),
        3,
        1279.5 / 915,
      ),
      (
        'landscape is limited by its width',
        const Size(915, 412),
        3,
        1279.5 / 915,
      ),
      ('a small view keeps the device ratio', const Size(200, 300), 2, 2),
      ('exactly 1280 px keeps the device ratio', const Size(320, 640), 2, 2),
      (
        'one pixel above the limit is scaled',
        const Size(320, 640.5),
        2,
        1279.5 / 640.5,
      ),
      (
        'a desktop window at 1x is scaled down',
        const Size(2560, 1440),
        1,
        1279.5 / 2560,
      ),
      (
        'a square is limited by either edge',
        const Size(1000, 1000),
        2.625,
        1.2795,
      ),
      ('an empty size yields 0', Size.zero, 3, 0),
      ('an infinite size yields 0', const Size(double.infinity, 100), 3, 0),
      ('a device ratio of 0 yields 0', const Size(412, 915), 0, 0),
      ('a NaN device ratio yields 0', const Size(412, 915), double.nan, 0),
    ];

    for (final (description, size, devicePixelRatio, expected) in cases) {
      test('when $description then the ratio is $expected', () {
        final ratio = capturePixelRatio(
          logicalSize: size,
          devicePixelRatio: devicePixelRatio,
        );

        expect(ratio, closeTo(expected, 1e-9));
        // What the engine makes of it: the image size is rounded up.
        if (ratio > 0) {
          expect((size.longestSide * ratio).ceil(), lessThanOrEqualTo(1280));
        }
      });
    }

    test('when the limit is custom then it replaces 1280', () {
      final ratio = capturePixelRatio(
        logicalSize: const Size(800, 600),
        devicePixelRatio: 3,
        maxEdge: 400,
      );

      expect((800 * ratio).ceil(), 400);
    });
  });

  group('Given captureWithinLimit', () {
    test('when the first image fits then it is rendered once', () async {
      final ratios = <double>[];

      final result = await captureWithinLimit(
        pixelRatio: 2,
        maxBytes: 100,
        render: (ratio) async {
          ratios.add(ratio);
          return _shot(100, ratio);
        },
      );

      expect(ratios, [2.0]);
      expect((result as LotseCaptureSuccess).screenshot.pixelRatio, 2.0);
    });

    test('when the image is too large then the ratio is halved', () async {
      final ratios = <double>[];

      final result = await captureWithinLimit(
        pixelRatio: 2,
        maxBytes: 100,
        render: (ratio) async {
          ratios.add(ratio);
          return _shot(ratio > 0.5 ? 101 : 100, ratio);
        },
      );

      expect(ratios, [2.0, 1.0, 0.5]);
      expect((result as LotseCaptureSuccess).screenshot.pixelRatio, 0.5);
    });

    test('when every attempt is too large then it gives up', () async {
      var renders = 0;

      final result = await captureWithinLimit(
        pixelRatio: 2,
        maxBytes: 100,
        render: (ratio) async {
          renders++;
          return _shot(101, ratio);
        },
      );

      expect(renders, maxCaptureAttempts);
      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.tooLarge,
      );
    });

    test('when rendering throws then the result is renderFailed', () async {
      final result = await captureWithinLimit(
        pixelRatio: 2,
        render: (_) async => throw StateError('platform view'),
      );

      expect(
        (result as LotseCaptureFailed).failure,
        LotseCaptureFailure.renderFailed,
      );
    });

    test(
      'when encoding yields nothing then the result is renderFailed',
      () async {
        final result = await captureWithinLimit(
          pixelRatio: 2,
          render: (_) async => null,
        );

        expect(
          (result as LotseCaptureFailed).failure,
          LotseCaptureFailure.renderFailed,
        );
      },
    );

    test(
      'when there is nothing to render then the result is noBoundary',
      () async {
        final result = await captureWithinLimit(
          pixelRatio: 0,
          render: (_) async => fail('must not render'),
        );

        expect(
          (result as LotseCaptureFailed).failure,
          LotseCaptureFailure.noBoundary,
        );
      },
    );
  });
}
