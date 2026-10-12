import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse.dart';
import 'package:lotse/src/lotse_event_queue.dart';
import 'package:lotse/src/lotse_identity.dart';

// Lotse.track over the event queue and the identity manager, without a
// server: what waits while the network is gone, what goes out once it is
// back, and that reset() leaves nothing of the old identity behind. All ids
// are synthetic.

class _Offline implements Exception {}

class _MemoryStore implements LotseIdentityStore {
  LotseIdentity? identity;
  List<LotseIdentity> pending = [];

  @override
  Future<LotseIdentity?> read() async => identity;

  @override
  Future<void> write(LotseIdentity identity) async => this.identity = identity;

  @override
  Future<List<LotseIdentity>> pendingRevocations() async => [...pending];

  @override
  Future<void> writePendingRevocations(List<LotseIdentity> identities) async =>
      pending = [...identities];
}

/// A server that registers, claims, revokes and takes events, unless it is
/// [offline]. Credentials are synthetic: `cred-<installId>`.
class _FakeServer {
  final registered = <String>[];
  final batches = <(String, String?, List<LotseQueuedEvent>)>[];
  bool offline = false;

  LotseIdentityServer get identity => LotseIdentityServer(
    register: (installId, credential) async {
      if (offline) throw _Offline();
      if (!registered.contains(installId)) registered.add(installId);
    },
    claim: (installId) async {
      if (offline) throw _Offline();
      return 'cred-$installId';
    },
    revoke: (installId, credential) async {
      if (offline) throw _Offline();
    },
    isCredentialRefused: (_) => false,
    isDeviceUnknown: (_) => false,
  );

  Future<void> track(
    String installId,
    String? credential,
    List<LotseQueuedEvent> events,
  ) async {
    if (offline) throw _Offline();
    if (!registered.contains(installId)) throw StateError('not registered');
    batches.add((installId, credential, events));
  }

  List<String> namesOf(String installId) => [
    for (final (id, _, events) in batches)
      if (id == installId) ...events.map((e) => e.name),
  ];
}

void main() {
  late _MemoryStore store;
  late _FakeServer server;
  late MemoryLotseEventStore events;
  late LotseIdentityManager identity;
  late Lotse lotse;
  var installIds = 0;

  Lotse newLotse() =>
      Lotse.forTesting(identity: identity, track: server.track, events: events);

  setUp(() async {
    store = _MemoryStore();
    server = _FakeServer();
    events = MemoryLotseEventStore();
    installIds = 0;
    identity = LotseIdentityManager(
      store: store,
      server: server.identity,
      newInstallId: () => 'install-${++installIds}',
    );
    lotse = newLotse();
    await identity.load();
  });

  test('online, an event goes out at once with the credential and leaves '
      'nothing behind', () async {
    await identity.connect();

    await lotse.track('purchase', props: {'sku': '42'});

    expect(server.batches, hasLength(1));
    final (installId, credential, sent) = server.batches.single;
    expect(installId, 'install-1');
    expect(credential, 'cred-install-1');
    expect(sent.single.name, 'purchase');
    expect(sent.single.props, {'sku': '42'});
    expect(sent.single.clientId, isNotEmpty);
    expect(events.events, isEmpty);
  });

  test('a start without network keeps its events, registers the install '
      'once the network is back and sends them in order', () async {
    server.offline = true;
    await expectLater(identity.connect(), throwsA(isA<_Offline>()));

    await lotse.track('session_start');
    await lotse.track('screen_view', props: {'screen': 'home'});
    expect(server.batches, isEmpty);
    expect(events.events.map((e) => e.name), ['session_start', 'screen_view']);
    expect(events.events.map((e) => e.installId).toSet(), {'install-1'});
    final ids = [for (final e in events.events) e.clientId];

    server.offline = false;
    await lotse.track('purchase');

    expect(server.registered, ['install-1']);
    expect(server.namesOf('install-1'), [
      'session_start',
      'screen_view',
      'purchase',
    ]);
    expect(
      server.batches.expand((b) => b.$3).take(2).map((e) => e.clientId),
      ids,
    );
    expect(events.events, isEmpty);
  });

  test('events of a closed app go out on the next start', () async {
    await identity.connect();
    server.offline = true;
    await lotse.track('before_close');
    expect(events.events, hasLength(1));

    // The app ends; the next start reads the same stores.
    server.offline = false;
    identity = LotseIdentityManager(
      store: store,
      server: server.identity,
      newInstallId: () => 'install-${++installIds}',
    );
    await identity.load();
    lotse = newLotse();
    await lotse.track('session_start');

    expect(server.namesOf('install-1'), ['before_close', 'session_start']);
    expect(events.events, isEmpty);
  });

  test('after reset nothing of the old identity is sent or kept', () async {
    await identity.connect();
    server.offline = true;
    await lotse.track('old_user_event');
    expect(events.events, hasLength(1));

    await lotse.reset();
    server.offline = false;
    await lotse.track('new_user_event');

    expect(server.namesOf('install-1'), isEmpty);
    expect(server.namesOf('install-2'), contains('new_user_event'));
    expect(
      server.batches.expand((b) => b.$3).map((e) => e.name),
      isNot(contains('old_user_event')),
    );
    expect(events.events, isEmpty);
  });

  test('an event the server would refuse is not tracked at all', () async {
    await identity.connect();

    await lotse.track('   ');
    await lotse.track('e', props: {'k': 'v' * 201});

    expect(server.batches, isEmpty);
    expect(events.events, isEmpty);
  });
}
