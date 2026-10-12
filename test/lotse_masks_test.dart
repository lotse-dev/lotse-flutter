import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_capture.dart';
import 'package:lotse/src/lotse_masks.dart';
import 'package:lotse/src/lotse_scope.dart';

final _boundary = GlobalKey();

/// [child] at the top left of an 800 × 600 view, inside the boundary the
/// masks are collected for.
Widget _app(Widget child) => MaterialApp(
  home: Scaffold(
    body: RepaintBoundary(
      key: _boundary,
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  ),
);

List<LotseMask> _masks(WidgetTester tester, {bool maskAllText = false}) =>
    collectLotseMasks(
      _boundary.currentContext!.findRenderObject()!,
      maskAllText: maskAllText,
    );

const _field = SizedBox(width: 200, child: TextField());

/// A 200 × 150 Android view wired like `webview_flutter`: a surface
/// controller, texture-based unless the platform falls back to Hybrid
/// Composition on create. The platform side is faked: [texture] decides
/// whether `create` answers with a texture id or with the fallback.
Widget _androidView(WidgetTester tester, {required bool texture}) {
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform_views,
    (call) async => switch (call.method) {
      'create' => texture ? 7 : null,
      'resize' => {
        'width': (call.arguments as Map)['width'],
        'height': (call.arguments as Map)['height'],
      },
      _ => null,
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform_views,
      null,
    ),
  );
  return SizedBox(
    width: 200,
    height: 150,
    child: PlatformViewLink(
      viewType: 'web',
      surfaceFactory: (context, controller) => AndroidViewSurface(
        controller: controller as AndroidViewController,
        gestureRecognizers: const {},
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      ),
      onCreatePlatformView: (params) =>
          PlatformViewsService.initSurfaceAndroidView(
              id: params.id,
              viewType: 'web',
              layoutDirection: TextDirection.ltr,
            )
            ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
            ..create(),
    ),
  );
}

/// Every pixel of [image] as 0xRRGGBBAA, row by row.
Future<List<int>> _rgba(WidgetTester tester, ui.Image image) async {
  final data = await tester.runAsync(
    () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
  );
  return [for (var i = 0; i < data!.lengthInBytes; i += 4) data.getUint32(i)];
}

/// A white [size] image with [masks] painted at pixel ratio 1.
Future<List<int>> _painted(
  WidgetTester tester,
  Size size,
  List<LotseMask> masks,
) async {
  final recorder = ui.PictureRecorder();
  ui.Canvas(recorder).drawColor(const Color(0xFFFFFFFF), BlendMode.src);
  final picture = recorder.endRecording();
  final blank = picture.toImageSync(size.width.toInt(), size.height.toInt());
  picture.dispose();
  final image = (await tester.runAsync(
    () => paintLotseMasks(blank, masks, 1),
  ))!;
  final pixels = await _rgba(tester, image);
  image.dispose();
  return pixels;
}

const _grey = 0x9E9E9EFF;

/// Whether [p] is part of the symbol or the label: darker than the grey,
/// anti-aliased edges included.
bool _isSign(int p) => (p >> 24) < 0x9E;

void main() {
  testWidgets('a text input is masked, plain text is not', (tester) async {
    await tester.pumpWidget(
      _app(const Column(children: [_field, Text('Hello')])),
    );

    final masks = _masks(tester);

    expect(masks.map((m) => m.kind), [LotseMaskKind.textInput]);
    final field = tester.getRect(find.byType(EditableText));
    final boundary = tester.getRect(find.byKey(_boundary));
    expect(masks.single.rect, field.shift(-boundary.topLeft));
  });

  testWidgets('with maskAllText every text is masked too', (tester) async {
    await tester.pumpWidget(
      _app(const Column(children: [_field, Text('Hello')])),
    );

    final kinds = _masks(tester, maskAllText: true).map((m) => m.kind);

    expect(kinds, contains(LotseMaskKind.text));
    expect(kinds, contains(LotseMaskKind.textInput));
  });

  testWidgets('LotseUnmasked shows its inputs, LotseConfidential inside still '
      'hides', (tester) async {
    await tester.pumpWidget(
      _app(
        const LotseUnmasked(
          child: Column(
            children: [
              _field,
              LotseConfidential(child: Text('DE89 3704 0044 0532 0130 00')),
            ],
          ),
        ),
      ),
    );

    expect(_masks(tester).map((m) => m.kind), [LotseMaskKind.confidential]);
  });

  group('hidden from semantics, still on the screen', () {
    // A text input, a confidential region and a platform view, each a mask.
    Future<void> pump(WidgetTester tester, Widget Function(Widget) wrap) async {
      await tester.pumpWidget(
        _app(
          wrap(
            Column(
              children: [
                _field,
                const LotseConfidential(
                  child: Text('DE89 3704 0044 0532 0130 00'),
                ),
                _androidView(tester, texture: true),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
    }

    // The same inside a scroll view, for the sliver widgets.
    Future<void> pumpSliver(
      WidgetTester tester,
      Widget Function(Widget) wrap,
    ) => pump(
      tester,
      (child) => SizedBox(
        width: 400,
        height: 400,
        child: CustomScrollView(
          slivers: [wrap(SliverToBoxAdapter(child: child))],
        ),
      ),
    );

    const all = [
      LotseMaskKind.textInput,
      LotseMaskKind.confidential,
      LotseMaskKind.platformView,
    ];

    testWidgets('ExcludeSemantics', (tester) async {
      await pump(tester, (child) => ExcludeSemantics(child: child));

      expect(_masks(tester).map((m) => m.kind), all);
    });

    testWidgets('Semantics(excludeSemantics: true), as in the date pickers', (
      tester,
    ) async {
      await pump(
        tester,
        (child) =>
            Semantics(label: 'IBAN', excludeSemantics: true, child: child),
      );

      expect(_masks(tester).map((m) => m.kind), all);
    });

    testWidgets('IgnorePointer(ignoringSemantics: true)', (tester) async {
      await pump(
        tester,
        // ignore: deprecated_member_use
        (child) => IgnorePointer(ignoringSemantics: true, child: child),
      );

      expect(_masks(tester).map((m) => m.kind), all);
    });

    testWidgets('AbsorbPointer(ignoringSemantics: true)', (tester) async {
      await pump(
        tester,
        // ignore: deprecated_member_use
        (child) => AbsorbPointer(ignoringSemantics: true, child: child),
      );

      expect(_masks(tester).map((m) => m.kind), all);
    });

    testWidgets('SliverIgnorePointer(ignoringSemantics: true)', (tester) async {
      await pumpSliver(
        tester,
        (sliver) => SliverIgnorePointer(
          // ignore: deprecated_member_use
          ignoringSemantics: true,
          sliver: sliver,
        ),
      );

      expect(_masks(tester).map((m) => m.kind), all);
    });

    testWidgets('SliverSemantics(excludeSemantics: true)', (tester) async {
      await pumpSliver(
        tester,
        (sliver) => SliverSemantics(excludeSemantics: true, sliver: sliver),
      );

      expect(_masks(tester).map((m) => m.kind), all);
    });

    // The one multi-child exception: the decorator skips the hint while
    // the field has a label and no focus, but paints it with a label that
    // always floats.
    testWidgets('the hint under a floating label is under the mask of its '
        'input', (tester) async {
      await tester.pumpWidget(
        _app(
          const SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'IBAN',
                hintText: 'DE89 3704 0044 0532 0130 00',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
        ),
      );

      final boundary = tester.getRect(find.byKey(_boundary));
      final hint = tester
          .getRect(find.text('DE89 3704 0044 0532 0130 00'))
          .shift(-boundary.topLeft);
      final input = _masks(
        tester,
        maskAllText: true,
      ).singleWhere((m) => m.kind == LotseMaskKind.textInput);
      expect(input.rect.intersect(hint), hint);
    });
  });

  group('what is not painted is not searched', () {
    const secrets = Column(
      children: [
        _field,
        LotseConfidential(child: Text('DE89 3704 0044 0532 0130 00')),
      ],
    );

    Widget sliver(Widget Function(Widget) wrap) => SizedBox(
      width: 400,
      height: 400,
      child: CustomScrollView(
        slivers: [wrap(const SliverToBoxAdapter(child: secrets))],
      ),
    );

    testWidgets('Offstage', (tester) async {
      await tester.pumpWidget(_app(const Offstage(child: secrets)));

      expect(_masks(tester), isEmpty);
    });

    testWidgets('Opacity 0, with or without semantics', (tester) async {
      for (final always in [false, true]) {
        await tester.pumpWidget(
          _app(
            Opacity(opacity: 0, alwaysIncludeSemantics: always, child: secrets),
          ),
        );

        expect(_masks(tester), isEmpty, reason: 'semantics: $always');
      }
    });

    testWidgets('a fade at 0', (tester) async {
      await tester.pumpWidget(
        _app(
          const FadeTransition(
            opacity: AlwaysStoppedAnimation(0),
            child: secrets,
          ),
        ),
      );

      expect(_masks(tester), isEmpty);
    });

    testWidgets('SliverOffstage, SliverOpacity 0 and a sliver fade at 0', (
      tester,
    ) async {
      final wraps = <Widget Function(Widget)>[
        (s) => SliverOffstage(sliver: s),
        (s) => SliverOpacity(opacity: 0, sliver: s),
        (s) => SliverFadeTransition(
          opacity: const AlwaysStoppedAnimation(0),
          sliver: s,
        ),
      ];
      for (final (i, wrap) in wraps.indexed) {
        await tester.pumpWidget(_app(sliver(wrap)));

        expect(_masks(tester), isEmpty, reason: 'wrap $i');
      }
    });

    testWidgets('a hidden child of an IndexedStack', (tester) async {
      for (final index in [0, 1]) {
        await tester.pumpWidget(
          _app(
            IndexedStack(
              index: index,
              children: const [secrets, Text('Other tab')],
            ),
          ),
        );

        expect(_masks(tester), hasLength(index == 0 ? 2 : 0));
      }
    });

    testWidgets('an offstage subtree under Semantics(excludeSemantics: true)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          Semantics(
            excludeSemantics: true,
            child: const Offstage(child: secrets),
          ),
        ),
      );

      expect(_masks(tester), isEmpty);
    });
  });

  testWidgets('a confidential region is one mask, not one per child', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(const LotseConfidential(child: Column(children: [_field, _field]))),
    );

    expect(_masks(tester).map((m) => m.kind), [LotseMaskKind.confidential]);
  });

  testWidgets('a field half scrolled out of its list is cut to the list', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      _app(
        Column(
          children: [
            const SizedBox(height: 100, child: Text('App bar')),
            SizedBox(
              height: 200,
              width: 300,
              child: ListView(
                controller: controller,
                children: const [_field, SizedBox(height: 400)],
              ),
            ),
          ],
        ),
      ),
    );
    final list = tester.getRect(find.byType(ListView));
    controller.jumpTo(30);
    await tester.pump();

    final mask = _masks(tester).single;
    final boundary = tester.getRect(find.byKey(_boundary));

    expect(mask.rect.top, list.top - boundary.top);
    expect(mask.rect.bottom, greaterThan(mask.rect.top));
  });

  testWidgets('a page covered by another route is not searched', (
    tester,
  ) async {
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        builder: (context, child) =>
            RepaintBoundary(key: _boundary, child: child),
        home: const Scaffold(body: _field),
      ),
    );
    navigator.currentState!.push(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Second page')),
      ),
    );
    await tester.pumpAndSettle();

    expect(_masks(tester), isEmpty);
  });

  testWidgets('the capture blacks out a text input in the image and leaves '
      'the screen alone', (tester) async {
    late BuildContext inside;
    await tester.pumpWidget(
      LotseScope(
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                inside = context;
                return const Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: 300,
                    child: TextField(decoration: InputDecoration(filled: true)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'secret');
    await tester.pump();
    final field = tester.getRect(find.byType(EditableText));

    final result = await tester.runAsync(() async {
      final running = captureLotseScreenshot(inside);
      await tester.pump();
      return running;
    });
    final shot = (result! as LotseCaptureSuccess).screenshot;

    final pixels = await tester.runAsync(() async {
      final codec = await ui.instantiateImageCodec(shot.png);
      final image = (await codec.getNextFrame()).image;
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return data!;
    });
    int rgbaAt(Offset p) {
      final x = (p.dx * shot.pixelRatio).floor();
      final y = (p.dy * shot.pixelRatio).floor();
      return pixels!.getUint32((y * shot.width + x) * 4);
    }

    expect(rgbaAt(field.center), 0x000000FF);
    expect(rgbaAt(field.topLeft + const Offset(1, 1)), 0x000000FF);
    expect(find.text('secret'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  group('platform views', () {
    testWidgets('are grey by default, texture-based or not', (tester) async {
      for (final texture in [true, false]) {
        await tester.pumpWidget(_app(_androidView(tester, texture: texture)));
        await tester.pump();

        expect(_masks(tester).map((m) => m.kind), [
          LotseMaskKind.platformView,
        ], reason: 'texture: $texture');
        await tester.pumpWidget(const SizedBox());
      }
    });

    testWidgets('a texture-based Android view inside LotseUnmasked is in the '
        'image', (tester) async {
      await tester.pumpWidget(
        _app(LotseUnmasked(child: _androidView(tester, texture: true))),
      );
      await tester.pump();

      expect(
        isRecordablePlatformView(
          tester.renderObject(find.byType(AndroidViewSurface)),
        ),
        isTrue,
      );
      expect(_masks(tester), isEmpty);
    });

    testWidgets('after a fallback to Hybrid Composition it stays a mask, '
        'marked as not recordable', (tester) async {
      await tester.pumpWidget(
        _app(LotseUnmasked(child: _androidView(tester, texture: false))),
      );
      await tester.pump();

      final masks = _masks(tester);
      expect(masks.map((m) => m.kind), [LotseMaskKind.unrecordable]);
      expect(masks.single.rect, const Rect.fromLTWH(0, 0, 200, 150));
    });

    testWidgets('LotseConfidential still wins over a recordable view', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          LotseUnmasked(
            child: LotseConfidential(
              child: _androidView(tester, texture: true),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(_masks(tester).map((m) => m.kind), [LotseMaskKind.confidential]);
    });

    testWidgets('the mask is grey with a symbol, the unrecordable one also '
        'with a label under it', (tester) async {
      const size = Size(200, 200);
      const rect = Rect.fromLTWH(0, 0, 200, 200);
      // Symbol 32 px, gap 8, label 12: the block is centred, the label
      // runs from about 114 to 126, below the lone symbol (to 114).
      bool labelRow(List<int> pixels) => [
        for (var y = 116; y < 126; y++)
          for (var x = 0; x < 200; x++) pixels[y * 200 + x],
      ].any(_isSign);

      final masked = await _painted(tester, size, [
        (rect: rect, kind: LotseMaskKind.platformView),
      ]);
      final unrecordable = await _painted(tester, size, [
        (rect: rect, kind: LotseMaskKind.unrecordable),
      ]);

      for (final pixels in [masked, unrecordable]) {
        expect(pixels.first, _grey);
        expect(pixels.where(_isSign), isNotEmpty);
        expect(pixels, isNot(contains(0xFFFFFFFF)));
      }
      expect(labelRow(masked), isFalse);
      expect(labelRow(unrecordable), isTrue);
    });

    testWidgets('a small region is plain grey', (tester) async {
      final pixels = await _painted(tester, const Size(20, 20), [
        (
          rect: const Rect.fromLTWH(0, 0, 20, 20),
          kind: LotseMaskKind.unrecordable,
        ),
      ]);

      expect(pixels.toSet(), {_grey});
    });
  });

  group('under an image filter', () {
    // A 400 × 300 box with a confidential 100 × 20 region at (50, 100).
    Widget filtered(ui.ImageFilter filter, {bool enabled = true}) =>
        ImageFiltered(
          imageFilter: filter,
          enabled: enabled,
          child: const SizedBox(
            width: 400,
            height: 300,
            child: Padding(
              padding: EdgeInsets.only(left: 50, top: 100),
              child: Align(
                alignment: Alignment.topLeft,
                child: LotseConfidential(
                  child: SizedBox(width: 100, height: 20),
                ),
              ),
            ),
          ),
        );

    testWidgets('a region covers the whole filtered box, the filter may move '
        'its pixels anywhere in it (F8)', (tester) async {
      await tester.pumpWidget(
        _app(filtered(ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4))),
      );

      expect(_masks(tester).single.rect, const Rect.fromLTWH(0, 0, 400, 300));
    });

    testWidgets('a disabled filter changes nothing', (tester) async {
      await tester.pumpWidget(
        _app(
          filtered(ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4), enabled: false),
        ),
      );

      expect(_masks(tester).single.rect, const Rect.fromLTWH(50, 100, 100, 20));
    });

    testWidgets('the identity matrix changes nothing', (tester) async {
      await tester.pumpWidget(
        _app(filtered(ui.ImageFilter.matrix(Matrix4.identity().storage))),
      );

      expect(_masks(tester).single.rect, const Rect.fromLTWH(50, 100, 100, 20));
    });

    testWidgets('a region clipped away inside the filter is no mask', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: const SizedBox(
              width: 400,
              height: 300,
              child: ClipRect(
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  maxHeight: 1000,
                  child: Padding(
                    padding: EdgeInsets.only(top: 600),
                    child: LotseConfidential(
                      child: SizedBox(width: 100, height: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(_masks(tester), isEmpty);
    });
  });
}
