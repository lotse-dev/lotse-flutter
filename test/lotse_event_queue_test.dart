import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_event_queue.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _now = DateTime.utc(2026, 10, 3, 12);

var _ids = 0;

LotseQueuedEvent _event(
  String name, {
  String installId = 'install-1',
  DateTime? ts,
  Map<String, String>? props,
}) => LotseQueuedEvent(
  clientId: 'c${_ids++}',
  installId: installId,
  name: name,
  ts: ts ?? _now,
  sessionId: 's1',
  props: props,
);

class _Refused implements Exception {}

class _OverQuota implements Exception {}

/// A server that records what it got and fails while [failWith] is set.
class _Server {
  final calls = <(String, List<LotseQueuedEvent>)>[];
  Object? failWith;

  /// Completes a call only when the test says so, if set.
  Completer<void>? gate;

  Future<void> send(String installId, List<LotseQueuedEvent> events) async {
    calls.add((installId, events));
    if (gate case final gate?) await gate.future;
    if (failWith case final error?) throw error;
  }

  List<String> get names => [
    for (final (_, events) in calls) ...events.map((e) => e.name),
  ];
}

void main() {
  late MemoryLotseEventStore store;
  late _Server server;
  late String? installId;

  setUp(() {
    store = MemoryLotseEventStore();
    server = _Server();
    installId = 'install-1';
  });

  LotseEventQueue queue({DateTime Function()? now}) => LotseEventQueue(
    store: store,
    send: server.send,
    installId: () => installId,
    isRefused: (error) => error is _Refused,
    isOverQuota: (error) => error is _OverQuota,
    now: now ?? () => _now,
  );

  test('an added event is stored before it is sent, and gone from the store '
      'once the server has it', () async {
    final events = queue();
    await events.add(_event('session_start'));
    expect(store.events.map((e) => e.name), ['session_start']);
    expect(server.calls, isEmpty);

    await events.flush();

    expect(server.names, ['session_start']);
    expect(server.calls.single.$1, 'install-1');
    expect(store.events, isEmpty);
    expect(events.pending, isEmpty);
  });

  test('what could not be sent survives into the next run and goes out '
      'there with the same client ids', () async {
    server.failWith = Exception('offline');
    final first = queue();
    await first.add(_event('session_start'));
    await first.add(_event('screen_view'));
    await first.flush();
    first.dispose();
    final ids = [for (final e in store.events) e.clientId];
    expect(ids, hasLength(2));

    // The app was closed; a later start reads the store.
    server.failWith = null;
    final second = queue();
    await second.load();
    expect(second.pending.map((e) => e.clientId), ids);
    await second.flush();

    expect(server.calls.last.$2.map((e) => e.clientId), ids);
    expect(store.events, isEmpty);
  });

  testWidgets('a failed call keeps its events and tries again after 30 s', (
    tester,
  ) async {
    server.failWith = Exception('offline');
    final events = queue();
    await events.add(_event('a'));
    await events.flush();
    expect(server.calls, hasLength(1));
    expect(events.pending, hasLength(1));
    expect(events.retryScheduled, isTrue);

    server.failWith = null;
    await tester.pump(lotseEventRetryInterval - const Duration(seconds: 1));
    expect(server.calls, hasLength(1));
    await tester.pump(const Duration(seconds: 1));

    expect(server.calls, hasLength(2));
    expect(events.pending, isEmpty);
    expect(events.retryScheduled, isFalse);
  });

  test('events go out oldest first in calls of at most 100', () async {
    final events = queue();
    for (var i = 0; i < 250; i++) {
      await events.add(_event('e$i'));
    }
    await events.flush();

    expect(server.calls.map((c) => c.$2.length), [100, 100, 50]);
    expect(server.names, [for (var i = 0; i < 250; i++) 'e$i']);
  });

  test('a call stays under the byte limit of the server', () async {
    final events = queue();
    // About 12,000 bytes each ('€' is three bytes): 44 of them pass 512 KB.
    final big = {
      for (var i = 0; i < lotseEventMaxProps; i++)
        'k$i': '€' * lotseEventPropMaxLength,
    };
    for (var i = 0; i < 50; i++) {
      await events.add(_event('big', props: big));
    }
    await events.flush();

    for (final (_, batch) in server.calls) {
      expect(
        batch.fold(0, (sum, e) => sum + lotseEventBytes(e)),
        lessThanOrEqualTo(lotseEventBytesPerCall),
      );
    }
    expect(server.calls.length, 2);
    expect(server.names, hasLength(50));
  });

  test('events tracked while a call is on its way go out in the same '
      'flush', () async {
    final events = queue();
    server.gate = Completer();
    await events.add(_event('first'));
    final flushing = events.flush();
    await pumpEventQueue();
    await events.add(_event('second'));
    final second = events.flush();
    server.gate!.complete();
    server.gate = null;
    await flushing;
    await second;

    expect(server.calls.map((c) => c.$2.map((e) => e.name).toList()), [
      ['first'],
      ['second'],
    ]);
    expect(events.pending, isEmpty);
  });

  test('a batch the server refuses as invalid is dropped and the rest is '
      'sent', () async {
    final events = queue();
    for (var i = 0; i < 150; i++) {
      await events.add(_event('e$i'));
    }
    server.failWith = _Refused();
    final send = server.send;
    var call = 0;
    final refusing = LotseEventQueue(
      store: store,
      send: (id, batch) {
        // Only the first call is refused.
        if (call++ > 0) server.failWith = null;
        return send(id, batch);
      },
      installId: () => installId,
      isRefused: (error) => error is _Refused,
      now: () => _now,
    );
    events.dispose();
    await refusing.load();
    await refusing.flush();

    expect(server.calls.map((c) => c.$2.length), [100, 50]);
    expect(refusing.pending, isEmpty);
    expect(store.events, isEmpty);
  });

  testWidgets('a used-up budget pauses sending for 15 minutes', (tester) async {
    var now = _now;
    server.failWith = _OverQuota();
    final events = queue(now: () => now);
    await events.add(_event('a'));
    await events.flush();
    expect(server.calls, hasLength(1));

    server.failWith = null;
    now = _now.add(const Duration(minutes: 14));
    await events.add(_event('b'));
    await events.flush();
    await tester.pump(const Duration(minutes: 14));
    expect(server.calls, hasLength(1), reason: 'paused');

    now = _now.add(lotseEventQuotaPause);
    await tester.pump(const Duration(minutes: 1));
    expect(server.calls, hasLength(2));
    expect(server.calls.last.$2.map((e) => e.name), ['a', 'b']);
  });

  test('beyond 1000 events the oldest are dropped', () async {
    final events = queue();
    server.failWith = Exception('offline');
    for (var i = 0; i < lotseEventQueueLimit + 5; i++) {
      await events.add(_event('e$i'));
    }
    events.dispose();

    expect(events.pending, hasLength(lotseEventQueueLimit));
    expect(events.pending.first.name, 'e5');
    expect(store.events, hasLength(lotseEventQueueLimit));
  });

  test('events older than 30 days are dropped when loading and before '
      'sending', () async {
    store.events = [
      _event('too_old', ts: _now.subtract(const Duration(days: 31))),
      _event('three_weeks', ts: _now.subtract(const Duration(days: 21))),
    ];
    var now = _now;
    final events = queue(now: () => now);
    await events.load();
    expect(events.pending.map((e) => e.name), ['three_weeks']);

    now = _now.add(const Duration(days: 10));
    await events.flush();

    expect(server.calls, isEmpty);
    expect(events.pending, isEmpty);
    expect(store.events, isEmpty);
  });

  test('events of another install are never sent and are dropped', () async {
    final events = queue();
    await events.add(_event('old_user', installId: 'install-0'));
    await events.add(_event('this_user'));
    await events.flush();

    expect(server.calls.single.$1, 'install-1');
    expect(server.names, ['this_user']);
    expect(store.events, isEmpty);
  });

  test('without an identity in this run nothing is sent and nothing is '
      'dropped', () async {
    store.events = [_event('from_last_run')];
    installId = null;
    final events = queue();
    await events.flush();

    expect(server.calls, isEmpty);
    expect(events.pending, hasLength(1));
    expect(store.events, hasLength(1));
  });

  test(
    'an event added before the store was read does not overwrite it',
    () async {
      store.events = [_event('from_last_run')];
      final events = queue();
      // No load() first: add waits for it.
      await events.add(_event('new'));

      expect(store.events.map((e) => e.name), ['from_last_run', 'new']);
    },
  );

  test('clear empties the queue and the store and stops the retry', () async {
    server.failWith = Exception('offline');
    final events = queue();
    await events.add(_event('a'));
    await events.flush();
    expect(events.retryScheduled, isTrue);

    await events.clear();

    expect(events.pending, isEmpty);
    expect(store.events, isEmpty);
    expect(events.retryScheduled, isFalse);
  });

  group('lotseEventProblem', () {
    test('accepts events at every limit', () {
      expect(
        lotseEventProblem(' ${'n' * lotseEventNameMaxLength} ', {
          for (var i = 0; i < lotseEventMaxProps; i++)
            '$i'.padLeft(lotseEventPropMaxLength, 'k'):
                'v' * lotseEventPropMaxLength,
        }),
        isNull,
      );
      expect(lotseEventProblem('purchase', null), isNull);
    });

    test('names what the server would refuse', () {
      final tooLong = 'x' * (lotseEventPropMaxLength + 1);
      for (final (name, props) in [
        ('  ', null),
        ('n' * (lotseEventNameMaxLength + 1), null),
        ('e', {for (var i = 0; i <= lotseEventMaxProps; i++) 'k$i': 'v'}),
        ('e', {'': 'v'}),
        ('e', {tooLong: 'v'}),
        ('e', {'k': tooLong}),
      ]) {
        expect(lotseEventProblem(name, props), isNotNull, reason: name);
      }
    });
  });

  group('PreferencesLotseEventStore', () {
    test('keeps events across instances, and an empty queue removes the '
        'key', () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await SharedPreferences.getInstance();
      final event = _event('purchase', props: {'sku': '42'});

      await PreferencesLotseEventStore(preferences).write([event]);
      final read = await PreferencesLotseEventStore(preferences).read();

      expect(read.single.toJson(), event.toJson());
      expect(read.single.ts, _now);

      await PreferencesLotseEventStore(preferences).write(const []);
      expect(preferences.getKeys(), isEmpty);
    });

    test(
      'a damaged entry is skipped, a damaged queue reads as empty',
      () async {
        SharedPreferences.setMockInitialValues({
          'lotse.eventQueue':
              '[{"clientId":"c","installId":"i","name":"ok",'
              '"ts":"2026-10-03T12:00:00.000Z"},{"name":7},"x"]',
        });
        final preferences = await SharedPreferences.getInstance();
        expect(
          (await PreferencesLotseEventStore(
            preferences,
          ).read()).map((e) => e.name),
          ['ok'],
        );

        await preferences.setString('lotse.eventQueue', '{not json');
        expect(await PreferencesLotseEventStore(preferences).read(), isEmpty);
      },
    );
  });
}
