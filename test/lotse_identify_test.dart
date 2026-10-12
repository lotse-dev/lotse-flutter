import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse.dart';
import 'package:lotse/src/lotse_identity.dart';

// Lotse.identify over the identity manager, without a server: the call it
// makes, what it does after reset(), and that no failure reaches the app.
// All ids are synthetic.

class _Refused implements Exception {}

class _Unknown implements Exception {}

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

/// A server made of maps. Credentials are synthetic: `cred-<installId>`.
class _FakeServer {
  final registered = <String>[];
  final credentials = <String, String>{};
  final revoked = <String>{};
  bool offline = false;
  bool refuseClaims = false;

  LotseIdentityServer get calls => LotseIdentityServer(
    register: (installId, credential) async {
      if (offline) throw _Offline();
      if (revoked.contains(installId)) throw _Refused();
      if (!registered.contains(installId)) registered.add(installId);
    },
    claim: (installId) async {
      if (offline) throw _Offline();
      if (refuseClaims) throw _Refused();
      if (!registered.contains(installId)) throw _Unknown();
      if (credentials.containsKey(installId) || revoked.contains(installId)) {
        throw _Refused();
      }
      return credentials[installId] = 'cred-$installId';
    },
    revoke: (installId, credential) async {
      if (offline) throw _Offline();
      if (!registered.contains(installId)) throw _Unknown();
      if (credentials[installId] != credential) throw _Refused();
      credentials.remove(installId);
      revoked.add(installId);
    },
    isCredentialRefused: (error) => error is _Refused,
    isDeviceUnknown: (error) => error is _Unknown,
  );
}

/// One recorded identify call.
typedef _Identify = ({
  String installId,
  String credential,
  String userId,
  Map<String, String>? traits,
  String? userHash,
});

void main() {
  late _MemoryStore store;
  late _FakeServer server;
  late LotseIdentityManager identity;
  late List<_Identify> calls;
  late Object? Function(_Identify call) outcome;
  late Lotse lotse;
  var installIds = 0;

  setUp(() async {
    store = _MemoryStore();
    server = _FakeServer();
    installIds = 0;
    identity = LotseIdentityManager(
      store: store,
      server: server.calls,
      newInstallId: () => 'install-${++installIds}',
    );
    calls = [];
    outcome = (_) => null;
    lotse = Lotse.forTesting(
      identity: identity,
      identify: (installId, credential, userId, traits, userHash) async {
        final call = (
          installId: installId,
          credential: credential,
          userId: userId,
          traits: traits,
          userHash: userHash,
        );
        calls.add(call);
        final error = outcome(call);
        if (error != null) throw error;
      },
    );
    await identity.load();
    await identity.connect();
  });

  test('identify sends the install id and credential of the current identity '
      'with the user id and traits', () async {
    await lotse.identify('user-1', traits: {'plan': 'pro'});

    expect(calls, hasLength(1));
    expect(calls.single.installId, 'install-1');
    expect(calls.single.credential, 'cred-install-1');
    expect(calls.single.userId, 'user-1');
    expect(calls.single.traits, {'plan': 'pro'});

    await lotse.identify('user-1');
    expect(calls.last.traits, isNull);
  });

  test('identify forwards the user hash of the backend as it is, and none '
      'without one', () async {
    // A synthetic hash; the SDK never computes or checks it.
    const hash =
        '2b6dbefac48e5741a14664b9210ebc33b3cf848a3f2be67e432f9144f517b117';
    await lotse.identify('user-42', userHash: hash);
    expect(calls.single.userId, 'user-42');
    expect(calls.single.userHash, hash);

    await lotse.identify('user-42', traits: {'plan': 'pro'});
    expect(calls.last.userHash, isNull);
  });

  test('a refused user hash is logged without the hash or the id, not '
      'thrown', () async {
    const hash =
        'ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    outcome = (_) => _Refused();
    final logged = <String?>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) => logged.add(message);
    addTearDown(() => debugPrint = previous);

    await expectLater(
      lotse.identify('user-secret-id', userHash: hash),
      completes,
    );

    expect(calls.single.userHash, hash);
    expect(logged, isNotEmpty);
    for (final line in logged) {
      expect(line, isNot(contains(hash)));
      expect(line, isNot(contains('user-secret-id')));
    }
  });

  test('after reset the next identify goes out under the new identity and '
      'the old user is not sent again by itself', () async {
    await lotse.identify('user-1');
    await lotse.reset();

    expect(calls, hasLength(1), reason: 'reset does not re-identify');
    expect(lotse.installId, 'install-2');

    await lotse.identify('user-2');
    expect(calls, hasLength(2));
    expect(calls.last.installId, 'install-2');
    expect(calls.last.credential, 'cred-install-2');
    expect(calls.last.userId, 'user-2');
  });

  test('a failing server call is logged, not thrown', () async {
    outcome = (_) => _Offline();
    await expectLater(lotse.identify('user-1'), completes);
    expect(calls, hasLength(1));

    outcome = (_) => _Refused();
    await expectLater(lotse.identify('user-1'), completes);
    expect(calls, hasLength(2));
  });

  test('a reset while the call is on its way drops its outcome without '
      'throwing', () async {
    final gate = Completer<void>();
    lotse = Lotse.forTesting(
      identity: identity,
      identify: (installId, credential, userId, traits, userHash) async {
        calls.add((
          installId: installId,
          credential: credential,
          userId: userId,
          traits: traits,
          userHash: userHash,
        ));
        await gate.future;
      },
    );

    final pending = lotse.identify('user-1');
    await Future<void>.delayed(Duration.zero);
    expect(calls, hasLength(1));
    final reset = lotse.reset();
    gate.complete();
    await expectLater(pending, completes);
    await reset;
    expect(lotse.installId, 'install-2');
  });

  test('without a credential and with the claim refused nothing is sent and '
      'nothing is thrown', () async {
    store = _MemoryStore()..identity = LotseIdentity(installId: 'legacy');
    server = _FakeServer()
      ..registered.add('legacy')
      ..refuseClaims = true;
    identity = LotseIdentityManager(
      store: store,
      server: server.calls,
      newInstallId: () => 'install-${++installIds}',
    );
    lotse = Lotse.forTesting(
      identity: identity,
      identify: (installId, credential, userId, traits, userHash) async =>
          calls.add((
            installId: installId,
            credential: credential,
            userId: userId,
            traits: traits,
            userHash: userHash,
          )),
    );
    await identity.load();
    // No connect: the credential is missing when identify runs.

    await expectLater(lotse.identify('user-1'), completes);
    expect(calls, isEmpty);
  });
}
