import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_backgrounds.dart';

const _home = (screen: 'home', widthClass: LotseWidthClass.regular);

void main() {
  test('backgrounds come from development builds unless all are allowed', () {
    expect(
      lotseBackgroundsEnabled(
        LotseBackgrounds.developmentBuilds,
        isReleaseBuild: false,
      ),
      isTrue,
    );
    expect(
      lotseBackgroundsEnabled(
        LotseBackgrounds.developmentBuilds,
        isReleaseBuild: true,
      ),
      isFalse,
    );
    expect(
      lotseBackgroundsEnabled(LotseBackgrounds.allBuilds, isReleaseBuild: true),
      isTrue,
    );
  });

  test('width classes split at 360 and 600 like on the server', () {
    expect(lotseWidthClassOf(359.9), LotseWidthClass.narrow);
    expect(lotseWidthClassOf(360), LotseWidthClass.regular);
    expect(lotseWidthClassOf(599.9), LotseWidthClass.regular);
    expect(lotseWidthClassOf(600), LotseWidthClass.wide);
  });

  test('a background is due only for a wanted screen in its width class', () {
    expect(
      lotseDueBackground(wanted: {_home}, screen: 'home', width: 400),
      _home,
    );
    expect(
      lotseDueBackground(wanted: {_home}, screen: 'home', width: 700),
      isNull,
    );
    expect(
      lotseDueBackground(wanted: {_home}, screen: 'cart', width: 400),
      isNull,
    );
    expect(
      lotseDueBackground(wanted: {_home}, screen: null, width: 400),
      isNull,
    );
  });

  group('LotseBackgroundWatcher', () {
    late ValueNotifier<Set<LotseBackgroundSlot>> wanted;
    late String? screen;
    late List<LotseBackgroundShot> sent;
    late int captures;
    late LotseBackgroundUploader? uploader;
    late void Function()? duringCapture;

    LotseBackgroundWatcher watcher() {
      final w = LotseBackgroundWatcher(
        wanted: wanted,
        uploader: () => uploader,
        view: () => (screen: screen, size: const Size(400, 780), scrollY: 240),
        capture: () async {
          captures++;
          duringCapture?.call();
          return Uint8List.fromList([1, 2, 3]);
        },
      );
      addTearDown(w.dispose);
      return w;
    }

    setUp(() {
      wanted = ValueNotifier({});
      screen = 'home';
      sent = [];
      captures = 0;
      uploader = (shot) async => sent.add(shot);
      duringCapture = null;
    });

    testWidgets('when a wanted screen is still for a second then it is '
        'taken once and no longer wanted', (tester) async {
      await tester.pumpWidget(const SizedBox());
      watcher();
      wanted.value = {_home};

      await tester.pump(const Duration(milliseconds: 1200));

      final shot = sent.single;
      expect(shot.screen, 'home');
      expect(shot.scrollY, 240);
      expect((shot.width, shot.height), (400, 780));
      expect(shot.image, [1, 2, 3]);
      expect(wanted.value, isEmpty);

      await tester.pump(const Duration(seconds: 5));
      expect(captures, 1);
    });

    testWidgets('while frames keep coming nothing is taken', (tester) async {
      await tester.pumpWidget(const SizedBox());
      watcher();
      wanted.value = {_home};

      // An animation: a pump only draws when a frame was asked for.
      for (var i = 0; i < 10; i++) {
        tester.binding.scheduleFrame();
        await tester.pump(const Duration(milliseconds: 400));
      }

      expect(captures, 0);
      expect(wanted.value, {_home});
      wanted.value = {};
    });

    testWidgets('another screen is not taken and stays wanted', (tester) async {
      await tester.pumpWidget(const SizedBox());
      screen = 'cart';
      watcher();
      wanted.value = {_home};

      await tester.pump(const Duration(seconds: 2));

      expect(captures, 0);
      expect(wanted.value, {_home});
      wanted.value = {};
    });

    testWidgets('when the user leaves the screen during the capture then '
        'nothing is sent', (tester) async {
      await tester.pumpWidget(const SizedBox());
      duringCapture = () => screen = 'cart';
      watcher();
      wanted.value = {_home};

      await tester.pump(const Duration(milliseconds: 1200));

      expect(captures, 1);
      expect(sent, isEmpty);
    });

    testWidgets('without an uploader nothing is taken', (tester) async {
      await tester.pumpWidget(const SizedBox());
      uploader = null;
      watcher();
      wanted.value = {_home};

      await tester.pump(const Duration(seconds: 2));

      expect(captures, 0);
      wanted.value = {};
    });

    testWidgets('a failed upload is logged and the slot is not retried until '
        'the server asks again', (tester) async {
      await tester.pumpWidget(const SizedBox());
      uploader = (_) async => throw StateError('offline');
      watcher();
      wanted.value = {_home};

      await tester.pump(const Duration(seconds: 3));

      expect(captures, 1);
      expect(wanted.value, isEmpty);
    });
  });
}
