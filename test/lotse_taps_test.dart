import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_taps.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _t0 = DateTime.utc(2026, 9, 27, 12);

LotseTap _tap({
  String screen = 'home',
  int ms = 0,
  int x = 100,
  int y = 100,
  bool rage = false,
}) => LotseTap(
  screen: screen,
  ts: _t0.add(Duration(milliseconds: ms)),
  x: x,
  y: y,
  scrollY: null,
  viewportWidth: 400,
  viewportHeight: 800,
  rage: rage,
);

LotseTapStart _start({Offset position = const Offset(50, 60)}) => LotseTapStart(
  screen: 'home',
  ts: _t0,
  position: position,
  local: position - const Offset(0, 10),
  time: const Duration(seconds: 1),
  slop: 18,
  scrollY: 240,
  viewport: const Size(400, 780),
);

class _MemoryTapStore implements LotseTapStore {
  ({String installId, List<LotseTap> taps})? stored;

  @override
  Future<({String installId, List<LotseTap> taps})?> read() async => stored;

  @override
  Future<void> write(String installId, List<LotseTap> taps) async =>
      stored = (installId: installId, taps: taps);

  @override
  Future<void> clear() async => stored = null;
}

void main() {
  group('LotseTapRecognizer', () {
    test('down and a quick up in place is a tap in boundary coordinates', () {
      final recognizer = LotseTapRecognizer()..down(1, _start());
      recognizer.move(1, const Offset(60, 65));

      final tap = recognizer.up(1, const Duration(milliseconds: 1400));

      expect(tap, isNotNull);
      expect(tap!.screen, 'home');
      expect(tap.ts, _t0);
      expect((tap.x, tap.y), (50, 50));
      expect(tap.scrollY, 240);
      expect((tap.viewportWidth, tap.viewportHeight), (400, 780));
      expect(tap.rage, isFalse);
    });

    test('moving beyond the slop is a drag, not a tap', () {
      final recognizer = LotseTapRecognizer()..down(1, _start());
      recognizer.move(1, const Offset(50, 79));
      expect(recognizer.up(1, const Duration(milliseconds: 1100)), isNull);
    });

    test('holding longer than 500 ms is no tap', () {
      final recognizer = LotseTapRecognizer()..down(1, _start());
      expect(recognizer.up(1, const Duration(milliseconds: 1501)), isNull);
    });

    test('a cancelled pointer or an unknown one gives no tap', () {
      final recognizer = LotseTapRecognizer()..down(1, _start());
      recognizer.cancel(1);
      expect(recognizer.up(1, const Duration(seconds: 1)), isNull);
      expect(recognizer.up(2, const Duration(seconds: 1)), isNull);
    });

    test('two fingers are two taps', () {
      final recognizer = LotseTapRecognizer()
        ..down(1, _start())
        ..down(2, _start(position: const Offset(200, 300)));
      expect(recognizer.up(2, const Duration(seconds: 1))?.x, 200);
      expect(recognizer.up(1, const Duration(seconds: 1))?.x, 50);
    });
  });

  group('markRageTaps', () {
    test('three taps on one spot within a second are all rage', () {
      final result = markRageTaps([
        _tap(ms: 0),
        _tap(ms: 400, x: 110),
        _tap(ms: 900, y: 120),
      ]);
      expect(result.map((t) => t.rage), [true, true, true]);
    });

    test('two quick taps are not rage', () {
      final result = markRageTaps([_tap(ms: 0), _tap(ms: 100)]);
      expect(result.map((t) => t.rage), [false, false]);
    });

    test('three taps spread over more than a second are not rage', () {
      final result = markRageTaps([_tap(ms: 0), _tap(ms: 600), _tap(ms: 1001)]);
      expect(result.map((t) => t.rage), [false, false, false]);
    });

    test('a tap farther than 30 px from the first breaks the burst', () {
      final result = markRageTaps([
        _tap(ms: 0),
        _tap(ms: 100, x: 131),
        _tap(ms: 200),
      ]);
      expect(result.map((t) => t.rage), [false, false, false]);
    });

    test('taps on another screen in between do not break a burst', () {
      final result = markRageTaps([
        _tap(ms: 0),
        _tap(ms: 100, screen: 'cart', x: 300),
        _tap(ms: 200),
        _tap(ms: 300),
      ]);
      expect(result.map((t) => t.rage), [true, false, true, true]);
    });

    test('a later burst that begins at a later tap is found too', () {
      final result = markRageTaps([
        _tap(ms: 0, x: 0),
        _tap(ms: 100),
        _tap(ms: 200),
        _tap(ms: 300),
      ]);
      expect(result.map((t) => t.rage), [false, true, true, true]);
    });

    test('taps marked before stay marked', () {
      final result = markRageTaps([_tap(rage: true)]);
      expect(result.single.rage, isTrue);
    });
  });

  group('LotseTapBuffer', () {
    testWidgets('sends after 30 seconds, not per tap', (tester) async {
      final sent = <List<LotseTap>>[];
      final buffer = LotseTapBuffer((taps) async => sent.add(taps));
      addTearDown(buffer.dispose);

      buffer
        ..add(_tap())
        ..add(_tap(ms: 5000));
      await tester.pump(const Duration(seconds: 29));
      expect(sent, isEmpty);

      await tester.pump(const Duration(seconds: 1));
      expect(sent.single, hasLength(2));
      expect(buffer.pending, isEmpty);
    });

    testWidgets('sends at once from 100 taps', (tester) async {
      final sent = <List<LotseTap>>[];
      final buffer = LotseTapBuffer((taps) async => sent.add(taps));
      addTearDown(buffer.dispose);

      for (var i = 0; i < lotseTapFlushCount; i++) {
        buffer.add(_tap(ms: i * 2000));
      }
      await tester.pump();

      expect(sent.single, hasLength(lotseTapFlushCount));
    });

    testWidgets('marks rage bursts before sending', (tester) async {
      final sent = <List<LotseTap>>[];
      final buffer = LotseTapBuffer((taps) async => sent.add(taps));
      addTearDown(buffer.dispose);

      buffer
        ..add(_tap(ms: 0))
        ..add(_tap(ms: 200))
        ..add(_tap(ms: 400));
      await buffer.flush();

      expect(sent.single.map((t) => t.rage), [true, true, true]);
    });

    testWidgets('a failed batch comes back and is sent on the next run', (
      tester,
    ) async {
      final sent = <List<LotseTap>>[];
      var fail = true;
      final buffer = LotseTapBuffer((taps) async {
        if (fail) throw StateError('offline');
        sent.add(taps);
      });
      addTearDown(buffer.dispose);

      buffer.add(_tap());
      await buffer.flush();
      expect(buffer.pending, hasLength(1));

      fail = false;
      buffer.add(_tap(ms: 5000));
      await tester.pump(lotseTapFlushInterval);

      expect(sent.single.map((t) => t.ts), [
        _t0,
        _t0.add(const Duration(seconds: 5)),
      ]);
    });

    testWidgets('more than 200 taps go in several calls', (tester) async {
      final sent = <List<LotseTap>>[];
      final gate = Completer<void>();
      final buffer = LotseTapBuffer((taps) async {
        await gate.future;
        sent.add(taps);
      });
      addTearDown(buffer.dispose);

      // The first flush at 100 waits on the gate while more taps arrive.
      for (var i = 0; i < 350; i++) {
        buffer.add(_tap(ms: i * 2000));
      }
      gate.complete();
      await buffer.flush();

      expect(sent.map((batch) => batch.length), [100, 200, 50]);
    });

    testWidgets('while offline the buffer keeps the newest 1000', (
      tester,
    ) async {
      final buffer = LotseTapBuffer((_) async => throw StateError('offline'));
      addTearDown(buffer.dispose);

      for (var i = 0; i < lotseTapBufferLimit + 50; i++) {
        buffer.add(_tap(ms: i));
        await tester.pump();
      }
      await buffer.flush();

      expect(buffer.pending, hasLength(lotseTapBufferLimit));
      expect(
        buffer.pending.last.ts,
        _t0.add(const Duration(milliseconds: 1049)),
      );
      buffer.dispose();
    });

    testWidgets('clear drops what is buffered', (tester) async {
      final sent = <List<LotseTap>>[];
      final buffer = LotseTapBuffer((taps) async => sent.add(taps));

      buffer
        ..add(_tap())
        ..clear();
      await tester.pump(lotseTapFlushInterval);

      expect(sent, isEmpty);
      buffer.dispose();
    });
  });

  group('LotseTapBuffer with a store', () {
    late _MemoryTapStore store;
    late String installId;

    setUp(() {
      store = _MemoryTapStore();
      installId = 'install-1';
    });

    LotseTapBuffer buffer(LotseTapSender send) =>
        LotseTapBuffer(send, store: store, installId: () => installId);

    testWidgets('taps that could not be sent come back on the next start '
        'and go out there', (tester) async {
      final offline = buffer((_) async => throw StateError('offline'));
      offline
        ..add(_tap())
        ..add(_tap(ms: 5000));
      await offline.flush();
      offline.dispose();
      expect(store.stored?.taps, hasLength(2));

      final sent = <List<LotseTap>>[];
      final next = buffer((taps) async => sent.add(taps));
      addTearDown(next.dispose);
      await next.restore(now: _t0);
      expect(next.pending, hasLength(2));

      await tester.pump(lotseTapFlushInterval);
      expect(sent.single, hasLength(2));
      expect(store.stored, isNull, reason: 'sent taps are not kept');
    });

    test('persist stores the buffer before anything is sent', () async {
      final sent = <List<LotseTap>>[];
      final taps = buffer((taps) async => sent.add(taps))..add(_tap());

      await taps.persist();
      taps.dispose();

      expect(sent, isEmpty);
      expect(store.stored?.installId, 'install-1');
      expect(store.stored?.taps.single.ts, _t0);
    });

    test(
      'taps of another install or older than a day are not restored',
      () async {
        store.stored = (installId: 'install-0', taps: [_tap()]);
        final other = buffer((_) async {});
        await other.restore(now: _t0);
        expect(other.pending, isEmpty);
        other.dispose();

        store.stored = (installId: 'install-1', taps: [_tap(), _tap(ms: 2000)]);
        final late = buffer((_) async {});
        await late.restore(
          now: _t0.add(lotseTapMaxAge + const Duration(seconds: 1)),
        );
        expect(late.pending.map((t) => t.ts), [
          _t0.add(const Duration(seconds: 2)),
        ]);
        late.dispose();
      },
    );

    test('clear drops the stored taps as well', () async {
      store.stored = (installId: 'install-1', taps: [_tap()]);
      final taps = buffer((_) async {})..clear();
      await Future<void>.delayed(Duration.zero);

      expect(store.stored, isNull);
      taps.dispose();
    });
  });

  test('PreferencesLotseTapStore keeps taps with their install', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final tap = _tap(screen: 'cart', rage: true);

    await PreferencesLotseTapStore(preferences).write('install-1', [tap]);
    final read = await PreferencesLotseTapStore(preferences).read();

    expect(read?.installId, 'install-1');
    expect(read?.taps.single.toJson(), tap.toJson());
    await PreferencesLotseTapStore(preferences).clear();
    expect(await PreferencesLotseTapStore(preferences).read(), isNull);
  });
}
