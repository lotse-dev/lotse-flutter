import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_identity.dart';
import 'package:lotse/src/lotse_my_feedback.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// A store whose secure part never answers, like a stuck Keystore.
class _UnreadableStore extends _MemoryStore {
  @override
  Future<LotseIdentity?> read() async => throw const LotseIdentityUnavailable();
}

/// A secure storage that never answers any call.
class _StuckSecureStorage implements FlutterSecureStorage {
  final calls = <Symbol>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    calls.add(invocation.memberName);
    return Completer<Never>().future;
  }
}

/// A server made of maps. Credentials are synthetic: `cred-<installId>`.
class _FakeServer {
  final registered = <String>[];
  final credentials = <String, String>{};

  /// The credential each register call carried, in order.
  final registerCredentials = <String?>[];
  final revoked = <String>{};
  final log = <String>[];
  bool offline = false;

  LotseIdentityServer get calls => LotseIdentityServer(
    register: (installId, credential) async {
      if (offline) throw _Offline();
      if (revoked.contains(installId)) throw _Refused();
      registerCredentials.add(credential);
      log.add('register $installId');
      if (!registered.contains(installId)) registered.add(installId);
    },
    claim: (installId) async {
      if (offline) throw _Offline();
      if (!registered.contains(installId)) throw _Unknown();
      if (credentials.containsKey(installId) || revoked.contains(installId)) {
        throw _Refused();
      }
      log.add('claim $installId');
      return credentials[installId] = 'cred-$installId';
    },
    revoke: (installId, credential) async {
      if (offline) throw _Offline();
      if (!registered.contains(installId)) throw _Unknown();
      if (credentials[installId] != credential) throw _Refused();
      log.add('revoke $installId');
      credentials.remove(installId);
      revoked.add(installId);
    },
    isCredentialRefused: (error) => error is _Refused,
    isDeviceUnknown: (error) => error is _Unknown,
  );
}

void main() {
  late _MemoryStore store;
  late _FakeServer server;
  late int counter;

  LotseIdentityManager manager() => LotseIdentityManager(
    store: store,
    server: server.calls,
    newInstallId: () => 'install-${++counter}',
  );

  setUp(() {
    store = _MemoryStore();
    server = _FakeServer();
    counter = 0;
  });

  group('first start', () {
    test(
      'makes an install id, registers it and claims the credential',
      () async {
        final identity = manager();
        await identity.load();
        expect(identity.current.installId, 'install-1');
        expect(identity.current.credential, isNull);

        await identity.connect();
        expect(identity.current.credential, 'cred-install-1');
        expect(store.identity?.credential, 'cred-install-1');
        expect(server.log, ['register install-1', 'claim install-1']);
      },
    );

    test('a later start keeps both and claims nothing', () async {
      final first = manager();
      await first.load();
      await first.connect();
      server.log.clear();

      final second = manager();
      await second.load();
      await second.connect();
      expect(second.current.installId, 'install-1');
      expect(second.current.credential, 'cred-install-1');
      expect(server.log, ['register install-1']);
      expect(second.generation.value, 0);
      // Without a credential before the first claim, with it afterwards: the
      // server refreshes a device that has one only with it.
      expect(server.registerCredentials, [null, 'cred-install-1']);
    });

    test('offline it throws, keeps the install id and claims later', () async {
      final identity = manager();
      await identity.load();
      server.offline = true;
      await expectLater(identity.connect(), throwsA(isA<_Offline>()));
      await expectLater(
        identity.runPrivate((installId, credential) async => 'private'),
        throwsA(isA<LotseCredentialUnavailable>()),
      );

      server.offline = false;
      expect(
        await identity.runPrivate((installId, credential) async => credential),
        'cred-install-1',
      );
      expect(identity.current.installId, 'install-1');
    });
  });

  group('migration of an install from before the credential', () {
    setUp(() {
      store.identity = const LotseIdentity(installId: 'legacy');
      server.registered.add('legacy');
    });

    test('claims the credential on first contact and keeps the install id, '
        'so its conversations stay reachable', () async {
      final identity = manager();
      await identity.load();
      await identity.connect();
      expect(identity.current.installId, 'legacy');
      expect(identity.current.credential, 'cred-legacy');
      expect(identity.generation.value, 0);
    });

    test('when someone else claimed first it goes on as a new install instead '
        'of failing for good', () async {
      server.credentials['legacy'] = 'cred-of-someone-else';
      final identity = manager();
      await identity.load();
      await identity.connect();
      expect(identity.current.installId, 'install-1');
      expect(identity.current.credential, 'cred-install-1');
      expect(store.identity?.installId, 'install-1');
    });

    test('a reinstall that restored the install id but lost the secure '
        'storage goes on as a new install', () async {
      server.credentials['legacy'] = 'cred-legacy';
      final identity = manager();
      await identity.load();
      expect(identity.current.credential, isNull);
      await identity.connect();
      expect(identity.current.installId, 'install-1');
    });
  });

  group('reset', () {
    late LotseIdentityManager identity;

    setUp(() async {
      identity = manager();
      await identity.load();
      await identity.connect();
      server.log.clear();
    });

    test('revokes the old credential, unregisters push, then starts a new '
        'install with its own credential', () async {
      var pushDeleted = 0;
      await identity.reset(
        unregisterPush: () async {
          pushDeleted++;
          server.log.add('push deleted');
        },
      );

      expect(pushDeleted, 1);
      expect(server.log, [
        'push deleted',
        'revoke install-1',
        'register install-2',
        'claim install-2',
      ]);
      expect(server.revoked, {'install-1'});
      expect(identity.current.installId, 'install-2');
      expect(identity.current.credential, 'cred-install-2');
      expect(store.identity?.installId, 'install-2');
      expect(store.identity?.credential, 'cred-install-2');
      expect(store.pending, isEmpty);
    });

    test(
      'moves the generation and the identity before anything is awaited',
      () {
        final before = identity.generation.value;
        unawaited(identity.reset());
        expect(identity.generation.value, before + 1);
        expect(identity.current.installId, 'install-2');
        expect(identity.current.credential, isNull);
      },
    );

    test('offline the old credential still leaves the device, and the '
        'revocation is made up for on the next start', () async {
      server.offline = true;
      await identity.reset(unregisterPush: () async => throw _Offline());

      expect(store.identity?.installId, 'install-2');
      expect(store.identity?.credential, isNull);
      expect(store.pending.single.installId, 'install-1');
      expect(server.revoked, isEmpty);

      server.offline = false;
      final nextStart = manager();
      await nextStart.load();
      await nextStart.connect();
      expect(server.revoked, {'install-1'});
      expect(store.pending, isEmpty);
      expect(nextStart.current.installId, 'install-2');
      expect(nextStart.current.credential, 'cred-install-2');
    });

    test('while a connect hangs on the network the reset still stores the '
        'new identity and the owed revocation at once', () async {
      final hanging = Completer<void>();
      final base = server.calls;
      final slow = LotseIdentityManager(
        store: store,
        server: LotseIdentityServer(
          register: (installId, credential) async {
            await hanging.future;
            await base.register(installId, credential);
          },
          claim: base.claim,
          revoke: base.revoke,
          isCredentialRefused: base.isCredentialRefused,
          isDeviceUnknown: base.isDeviceUnknown,
        ),
        newInstallId: () => 'install-${++counter}',
      );
      await slow.load();
      expect(slow.current.credential, 'cred-install-1');
      final connecting = slow.connect();
      await pumpEventQueue();

      final reset = slow.reset();
      await pumpEventQueue();
      // The app may be killed now: the next start must not find A.
      expect(store.identity?.installId, 'install-2');
      expect(store.identity?.credential, isNull);
      expect(store.pending.single.installId, 'install-1');

      hanging.complete();
      await connecting;
      await reset;
      expect(store.identity?.installId, 'install-2');
      expect(store.pending, isEmpty);
    });

    test('a revocation the server refuses or cannot place is not retried '
        'for ever', () async {
      store.pending = const [
        LotseIdentity(installId: 'install-1', credential: 'wrong'),
        LotseIdentity(installId: 'deleted-by-team', credential: 'cred'),
      ];
      await identity.connect();
      expect(store.pending, isEmpty);
    });

    test('an install that never got its credential is closed too, so its id '
        'cannot be claimed by someone else later', () async {
      store.identity = const LotseIdentity(installId: 'legacy');
      server.registered.add('legacy');
      final legacy = manager();
      await legacy.load();

      await legacy.reset();
      expect(server.revoked, contains('legacy'));
      expect(server.credentials.containsKey('legacy'), isFalse);
    });

    test('two resets in a row end with the newest identity stored', () async {
      final first = identity.reset();
      final second = identity.reset();
      await Future.wait([first, second]);
      expect(identity.current.installId, 'install-3');
      expect(store.identity?.installId, 'install-3');
      expect(store.identity?.credential, 'cred-install-3');
      expect(server.revoked, contains('install-1'));
    });

    test('never throws', () async {
      server.offline = true;
      await expectLater(identity.reset(), completes);
    });
  });

  group('calls that outlive their identity', () {
    late LotseIdentityManager identity;

    setUp(() async {
      identity = manager();
      await identity.load();
      await identity.connect();
    });

    test('a late answer for A is dropped after the reset', () async {
      final answer = Completer<String>();
      final call = identity.runPrivate((installId, credential) {
        expect(installId, 'install-1');
        return answer.future;
      });
      final dropped = expectLater(call, throwsA(isA<LotseIdentityReplaced>()));

      await identity.reset();
      answer.complete('private conversation of A');
      await dropped;
    });

    test('a stream opens with the install id and credential of the current '
        'identity, and ends with LotseIdentityReplaced on reset', () async {
      final asked = <(String, String)>[];
      final source = StreamController<int>();
      final events = <int>[];
      final errors = <Object>[];
      var done = false;
      identity
          .watchPrivate((installId, credential) {
            asked.add((installId, credential));
            return source.stream;
          })
          .listen(events.add, onError: errors.add, onDone: () => done = true);
      await pumpEventQueue();
      expect(asked, [('install-1', 'cred-install-1')]);
      source.add(1);
      await pumpEventQueue();
      expect(events, [1]);

      unawaited(identity.reset());
      await pumpEventQueue();
      source.add(2);
      await pumpEventQueue();

      expect(events, [1]);
      expect(errors.single, isA<LotseIdentityReplaced>());
      expect(done, isTrue);
      expect(source.hasListener, isFalse);
    });

    test('a stream cancelled while it opens is closed once it is open, not '
        'left running', () async {
      var listened = false;
      final source = StreamController<int>(onListen: () => listened = true);
      final subscription = identity
          .watchPrivate((installId, credential) => source.stream)
          .listen((_) {});
      await subscription.cancel();
      await pumpEventQueue();

      expect(listened, isTrue);
      expect(source.hasListener, isFalse);
    });

    test('a late error for A is dropped as well', () async {
      final answer = Completer<String>();
      final call = identity.run((installId, credential) => answer.future);
      final dropped = expectLater(call, throwsA(isA<LotseIdentityReplaced>()));

      unawaited(identity.reset());
      answer.completeError(StateError('quotes something of A'));
      await dropped;
    });

    test('after the reset calls carry the identity of B only', () async {
      await identity.reset();
      final seen = await identity.runPrivate(
        (installId, credential) async => (installId, credential),
      );
      expect(seen, ('install-2', 'cred-install-2'));
    });

    test('A to logout to B: the open conversation of A never shows its late '
        'answer, and its polling stops with the page', () async {
      // The thread of A, answered by the fake server only when told to.
      final answers = <Completer<generated.MyFeedbackThread>>[];
      final asked = <(String, String)>[];
      final conversations = ServerLotseConversations(
        installId: '',
        listMyFeedback: (_) async => [],
        getMyFeedback: (_, feedbackId) =>
            identity.runPrivate((installId, credential) {
              asked.add((installId, credential));
              final answer = Completer<generated.MyFeedbackThread>();
              answers.add(answer);
              return answer.future;
            }),
        replyToFeedback: (_, id, body) async => 1,
        markFeedbackRead: (_, id) async {},
      );
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        pollInterval: const Duration(days: 1),
      )..start();
      await pumpEventQueue();
      expect(asked.single, ('install-1', 'cred-install-1'));

      // Logout while the answer is on its way.
      await identity.reset();
      answers.single.complete(
        generated.MyFeedbackThread(
          feedback: generated.MyFeedback(
            id: 7,
            category: generated.FeedbackCategory.question,
            message: 'Private question of A',
            status: generated.FeedbackStatus.open,
            createdAt: DateTime.utc(2026),
            unreadCount: 1,
          ),
          messages: [],
        ),
      );
      await pumpEventQueue();

      expect(controller.thread, isNull);
      expect(controller.status, LotseLoadStatus.failed);
      controller.dispose();
    });
  });

  group('stuck secure storage', () {
    const origin = 'https://api.example.com/';
    const timeout = Duration(milliseconds: 20);

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    test('reading a stored identity ends with LotseIdentityUnavailable, not '
        'with an identity without credential', () async {
      SharedPreferences.setMockInitialValues({
        'lotse.installId': 'install-1',
        'lotse.serverOrigin': origin,
      });
      final platform = PlatformLotseIdentityStore(
        await SharedPreferences.getInstance(),
        serverOrigin: origin,
        secureStorage: _StuckSecureStorage(),
        timeout: timeout,
      );

      await expectLater(
        platform.read(),
        throwsA(isA<LotseIdentityUnavailable>()),
      );
    });

    test('a first start does not touch the secure storage to read', () async {
      final secure = _StuckSecureStorage();
      final platform = PlatformLotseIdentityStore(
        await SharedPreferences.getInstance(),
        serverOrigin: origin,
        secureStorage: secure,
        timeout: timeout,
      );

      expect(await platform.read(), isNull);
      expect(secure.calls, isEmpty);
    });

    test('writes and pending revocations give up instead of hanging', () async {
      final preferences = await SharedPreferences.getInstance();
      final platform = PlatformLotseIdentityStore(
        preferences,
        serverOrigin: origin,
        secureStorage: _StuckSecureStorage(),
        timeout: timeout,
      );

      await platform.write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );
      await platform.writePendingRevocations(const [
        LotseIdentity(installId: 'install-0', credential: 'cred-0'),
      ]);
      expect(await platform.pendingRevocations(), isEmpty);
      // The public part still lands where it always did.
      expect(preferences.getString('lotse.installId'), 'install-1');
    });

    test(
      'the manager starts no new install and asks the server nothing',
      () async {
        store = _UnreadableStore();
        final identity = manager();

        await identity.load();

        expect(store.identity, isNull);
        await expectLater(
          identity.connect(),
          throwsA(isA<LotseIdentityUnavailable>()),
        );
        expect(server.log, isEmpty);
        expect(server.registered, isEmpty);
      },
    );

    test(
      'calls fail as a future, so the error handling of the callers sees them',
      () async {
        store = _UnreadableStore();
        final identity = manager();
        await identity.load();

        final call = identity.run((installId, credential) async => installId);
        await expectLater(call, throwsA(isA<LotseIdentityUnavailable>()));
        await expectLater(
          identity.runPrivate((installId, credential) async => credential),
          throwsA(isA<LotseIdentityUnavailable>()),
        );
        expect(server.log, isEmpty);
      },
    );

    test('a reset in such a run starts a working identity', () async {
      store = _UnreadableStore();
      final identity = manager();
      await identity.load();

      await identity.reset();

      expect(identity.current.installId, 'install-1');
      expect(identity.current.credential, 'cred-install-1');
      expect(store.identity?.installId, 'install-1');
    });

    test('Keystore stuck at start: load and connect end within the limit, '
        'the stored install id survives for the next start', () async {
      SharedPreferences.setMockInitialValues({
        'lotse.installId': 'install-1',
        'lotse.serverOrigin': origin,
      });
      final preferences = await SharedPreferences.getInstance();
      store = _MemoryStore();
      final identity = LotseIdentityManager(
        store: PlatformLotseIdentityStore(
          preferences,
          serverOrigin: origin,
          secureStorage: _StuckSecureStorage(),
          timeout: timeout,
        ),
        server: server.calls,
        newInstallId: () => 'install-${++counter}',
      );

      await identity.load().timeout(const Duration(seconds: 1));
      await expectLater(
        identity.connect().timeout(const Duration(seconds: 1)),
        throwsA(isA<LotseIdentityUnavailable>()),
      );
      expect(server.log, isEmpty);
      expect(preferences.getString('lotse.installId'), 'install-1');
    });
  });

  group('PlatformLotseIdentityStore', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('keeps the install id in the preferences and the credential only in '
        'the secure storage', () async {
      final preferences = await SharedPreferences.getInstance();
      final platform = PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      );
      await platform.write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );

      expect(preferences.getString('lotse.installId'), 'install-1');
      for (final key in preferences.getKeys()) {
        expect(preferences.get(key).toString(), isNot(contains('cred-1')));
      }
      final read = await platform.read();
      expect(read?.installId, 'install-1');
      expect(read?.credential, 'cred-1');
    });

    test('ignores a credential that belongs to another install id', () async {
      final preferences = await SharedPreferences.getInstance();
      final platform = PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      );
      await platform.write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );
      await preferences.setString('lotse.installId', 'restored-from-backup');

      final read = await platform.read();
      expect(read?.installId, 'restored-from-backup');
      expect(read?.credential, isNull);
    });

    test('an identity without credential deletes the stored one', () async {
      final preferences = await SharedPreferences.getInstance();
      final platform = PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      );
      await platform.write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );
      await platform.write(const LotseIdentity(installId: 'install-2'));

      expect((await platform.read())?.credential, isNull);
      expect(
        await const FlutterSecureStorage().read(key: 'lotse.installCredential'),
        isNull,
      );
    });

    test('reads the install id an older SDK version stored', () async {
      SharedPreferences.setMockInitialValues({'lotse.installId': 'legacy'});
      final preferences = await SharedPreferences.getInstance();
      final read = await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      ).read();
      expect(read?.installId, 'legacy');
      expect(read?.credential, isNull);
    });

    test('pending revocations survive a restart', () async {
      final preferences = await SharedPreferences.getInstance();
      await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      ).writePendingRevocations(const [
        LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      ]);
      final pending = await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      ).pendingRevocations();
      expect(pending.single.installId, 'install-1');
      expect(pending.single.credential, 'cred-1');

      await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://api.example.com/',
      ).writePendingRevocations([]);
      expect(
        await PlatformLotseIdentityStore(
          preferences,
          serverOrigin: 'https://api.example.com/',
        ).pendingRevocations(),
        isEmpty,
      );
    });
  });

  group('PlatformLotseIdentityStore across servers', () {
    const one = 'https://one.example.com/';
    const two = 'https://two.example.com/';

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('hands no identity of one server to another', () async {
      final preferences = await SharedPreferences.getInstance();
      await PlatformLotseIdentityStore(preferences, serverOrigin: one).write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );

      final other = PlatformLotseIdentityStore(preferences, serverOrigin: two);
      expect(await other.read(), isNull);
      expect(await other.pendingRevocations(), isEmpty);
    });

    test('a base path of its own is another server', () async {
      final preferences = await SharedPreferences.getInstance();
      await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://one.example.com/',
      ).write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );

      final read = await PlatformLotseIdentityStore(
        preferences,
        serverOrigin: 'https://one.example.com/lotse/',
      ).read();
      expect(read, isNull);
    });

    test('keeps the old credential for its own server and revokes it when '
        'the app points back', () async {
      final preferences = await SharedPreferences.getInstance();
      await PlatformLotseIdentityStore(preferences, serverOrigin: one).write(
        const LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      );

      // The app is pointed at the other server and starts a new install.
      final other = PlatformLotseIdentityStore(preferences, serverOrigin: two);
      expect(await other.read(), isNull);
      await other.write(
        const LotseIdentity(installId: 'install-2', credential: 'cred-2'),
      );
      expect((await other.read())?.installId, 'install-2');
      expect(await other.pendingRevocations(), isEmpty);

      // Back at the first server the old credential is owed a revocation.
      final back = PlatformLotseIdentityStore(preferences, serverOrigin: one);
      final owed = await back.pendingRevocations();
      expect(owed.single.installId, 'install-1');
      expect(owed.single.credential, 'cred-1');
    });

    test('a revocation owed to one server is invisible to the other and '
        'survives its writes', () async {
      final preferences = await SharedPreferences.getInstance();
      final first = PlatformLotseIdentityStore(preferences, serverOrigin: one);
      await first.writePendingRevocations(const [
        LotseIdentity(installId: 'install-1', credential: 'cred-1'),
      ]);

      final other = PlatformLotseIdentityStore(preferences, serverOrigin: two);
      expect(await other.pendingRevocations(), isEmpty);
      await other.writePendingRevocations(const [
        LotseIdentity(installId: 'install-2', credential: 'cred-2'),
      ]);
      expect(await other.pendingRevocations(), hasLength(1));
      expect((await other.pendingRevocations()).single.installId, 'install-2');

      final owed = await first.pendingRevocations();
      expect(owed.single.installId, 'install-1');
    });

    test('the identity manager starts fresh after a server change', () async {
      final preferences = await SharedPreferences.getInstance();
      final server = _FakeServer();
      final first = LotseIdentityManager(
        store: PlatformLotseIdentityStore(preferences, serverOrigin: one),
        server: server.calls,
        newInstallId: _ids(['install-1']),
      );
      await first.load();
      await first.connect();
      expect(first.current.credential, 'cred-install-1');

      final otherServer = _FakeServer();
      final second = LotseIdentityManager(
        store: PlatformLotseIdentityStore(preferences, serverOrigin: two),
        server: otherServer.calls,
        newInstallId: _ids(['install-2']),
      );
      await second.load();
      await second.connect();

      expect(second.current.installId, 'install-2');
      expect(second.current.credential, 'cred-install-2');
      // Nothing of the first identity was named towards the other server.
      expect(otherServer.log.join(' '), isNot(contains('install-1')));
      expect(otherServer.revoked, isEmpty);
    });
  });
}

/// Hands out [ids] in order, then keeps repeating the last one.
String Function() _ids(List<String> ids) {
  var index = 0;
  return () => ids[index < ids.length - 1 ? index++ : ids.length - 1];
}
