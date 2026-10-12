import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const _installIdKey = 'lotse.installId';
const _originKey = 'lotse.serverOrigin';
const _credentialKey = 'lotse.installCredential';
const _pendingRevocationsKey = 'lotse.pendingRevocations';

/// How long one call into the secure storage may take. A healthy Keystore
/// answers in milliseconds; a stuck one never answers, and without a limit
/// [Lotse.init] would never return and the host app never show its first
/// frame.
const secureStorageTimeout = Duration(seconds: 5);

/// At most this many revocations wait for the network. More than that is no
/// logout pattern; the oldest ones are dropped, their credentials are already
/// gone from the device.
const maxPendingRevocations = 20;

/// Who this install is towards the server.
///
/// The [installId] is public: it names the install in the console and in the
/// event stream. The [credential] is the secret next to it; only with it the
/// server opens the conversations and the push target of the install.
@immutable
class LotseIdentity {
  /// Creates an identity.
  const LotseIdentity({required this.installId, this.credential});

  /// Names the install. Not a secret.
  final String installId;

  /// The secret install credential, `null` until the server handed it out.
  final String? credential;
}

/// Thrown into a call whose identity was ended by [LotseIdentityManager.reset]
/// while it ran. The answer belongs to the previous user and is dropped.
class LotseIdentityReplaced implements Exception {
  /// Creates the exception.
  const LotseIdentityReplaced();

  @override
  String toString() => 'LotseIdentityReplaced';
}

/// Thrown when the secure storage did not answer while the identity was read.
///
/// Not the same as "no credential stored": that would make the SDK claim
/// again, get refused, and start a new install on every start with a stuck
/// Keystore. Instead the run goes on without an identity and the next app
/// start tries again.
class LotseIdentityUnavailable implements Exception {
  /// Creates the exception.
  const LotseIdentityUnavailable();

  @override
  String toString() => 'LotseIdentityUnavailable';
}

/// Thrown into a private call while there is no credential to make it with.
class LotseCredentialUnavailable implements Exception {
  /// Creates the exception.
  const LotseCredentialUnavailable();

  @override
  String toString() => 'LotseCredentialUnavailable';
}

/// Where the identity lives on the device. A failing store must not throw,
/// with one exception in [read].
abstract interface class LotseIdentityStore {
  /// The stored identity, `null` on first start or when nothing can be read.
  ///
  /// Throws [LotseIdentityUnavailable] when an identity is stored but its
  /// credential could not be read in time.
  Future<LotseIdentity?> read();

  /// Stores [identity], replacing what was there.
  Future<void> write(LotseIdentity identity);

  /// Identities whose revocation has not reached the server yet.
  Future<List<LotseIdentity>> pendingRevocations();

  /// Replaces the list of [pendingRevocations].
  Future<void> writePendingRevocations(List<LotseIdentity> identities);
}

/// [LotseIdentityStore] of the platform: the public install id in the shared
/// preferences, where it always was, and everything secret in the secure
/// storage (Android Keystore, iOS Keychain).
///
/// The credential is stored together with the install id it belongs to. A
/// restored backup can bring the install id back without the Keystore entry,
/// or the other way round; a credential for another install id is ignored.
///
/// Every stored identity also carries the [serverOrigin] it was made for. An
/// app that points the SDK at another server gets a fresh install there: the
/// old credential is never handed to a host that did not issue it. It stays
/// on the device as a pending revocation of its own origin, so pointing back
/// at the old server closes the old install properly.
class PlatformLotseIdentityStore implements LotseIdentityStore {
  /// Creates the store. [preferences] is `null` when they cannot be opened.
  ///
  /// [serverOrigin] names the server this run talks to, see
  /// `lotseServerOrigin`. It is only compared, never sent anywhere.
  PlatformLotseIdentityStore(
    this._preferences, {
    required this.serverOrigin,
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
    this._timeout = secureStorageTimeout,
  }) : _secure = secureStorage;

  final SharedPreferences? _preferences;
  final FlutterSecureStorage _secure;
  final Duration _timeout;

  /// The server the identities of this run belong to.
  final String serverOrigin;

  @override
  Future<LotseIdentity?> read() async {
    try {
      final installId = _preferences?.getString(_installIdKey);
      if (installId == null) return null;
      final storedOrigin = _preferences?.getString(_originKey);
      if (storedOrigin != null && storedOrigin != serverOrigin) {
        await _partWithForeignIdentity(installId, storedOrigin);
        return null;
      }
      return LotseIdentity(
        installId: installId,
        credential: await _readCredential(installId),
      );
    } on LotseIdentityUnavailable {
      rethrow;
    } catch (error) {
      debugPrint('Lotse: could not read the identity: ${error.runtimeType}');
      return null;
    }
  }

  /// Lets go of the identity of another server: its credential moves to the
  /// pending revocations of that server, and nothing of it is handed to the
  /// current one. The caller then starts a new install here.
  Future<void> _partWithForeignIdentity(
    String installId,
    String storedOrigin,
  ) async {
    debugPrint('Lotse: the server changed, starting a new install.');
    try {
      final credential = await _readCredential(installId).catchError(
        (Object _) => null,
        test: (e) => e is LotseIdentityUnavailable,
      );
      if (credential != null) {
        final pending = await _pendingRevocationsOf(storedOrigin);
        await _writePendingRevocationsOf(storedOrigin, [
          ...pending,
          LotseIdentity(installId: installId, credential: credential),
        ]);
      }
      await _secure.delete(key: _credentialKey).timeout(_timeout);
      await _preferences?.remove(_installIdKey);
      await _preferences?.remove(_originKey);
    } catch (error) {
      debugPrint(
        'Lotse: could not part with the old install: ${error.runtimeType}',
      );
    }
  }

  /// The credential of [installId], `null` when none is stored or it is
  /// unreadable. Throws [LotseIdentityUnavailable] when the storage does not
  /// answer in time: then nobody knows whether there is one.
  Future<String?> _readCredential(String installId) async {
    try {
      final raw = await _secure.read(key: _credentialKey).timeout(_timeout);
      if (raw == null) return null;
      final stored = _identityFromJson(jsonDecode(raw));
      return stored?.installId == installId ? stored?.credential : null;
    } on TimeoutException {
      debugPrint('Lotse: the secure storage did not answer.');
      throw const LotseIdentityUnavailable();
    } catch (error) {
      // Never the value: it is the secret.
      debugPrint('Lotse: could not read the credential: ${error.runtimeType}');
      return null;
    }
  }

  @override
  Future<void> write(LotseIdentity identity) async {
    try {
      await _preferences?.setString(_installIdKey, identity.installId);
      await _preferences?.setString(_originKey, serverOrigin);
      if (identity.credential == null) {
        await _secure.delete(key: _credentialKey).timeout(_timeout);
      } else {
        await _secure
            .write(
              key: _credentialKey,
              value: jsonEncode(_identityToJson(identity)),
            )
            .timeout(_timeout);
      }
    } catch (error) {
      debugPrint('Lotse: could not store the identity: ${error.runtimeType}');
    }
  }

  @override
  Future<List<LotseIdentity>> pendingRevocations() =>
      _pendingRevocationsOf(serverOrigin);

  @override
  Future<void> writePendingRevocations(List<LotseIdentity> identities) =>
      _writePendingRevocationsOf(serverOrigin, identities);

  /// The revocations owed to [origin]. Entries of other servers stay in the
  /// store untouched and are never returned here.
  Future<List<LotseIdentity>> _pendingRevocationsOf(String origin) async {
    try {
      return [
        for (final entry in await _storedRevocations())
          if (entry.origin == origin) entry.identity,
      ];
    } catch (error) {
      debugPrint(
        'Lotse: could not read pending revocations: ${error.runtimeType}',
      );
      return const [];
    }
  }

  Future<void> _writePendingRevocationsOf(
    String origin,
    List<LotseIdentity> identities,
  ) async {
    try {
      // What other servers are owed survives, capped like the own list so a
      // host that is switched back and forth cannot fill the storage.
      final foreign = [
        for (final entry in await _storedRevocations())
          if (entry.origin != origin) entry,
      ];
      final kept = [
        ...foreign.length > maxPendingRevocations
            ? foreign.sublist(foreign.length - maxPendingRevocations)
            : foreign,
        for (final identity in identities) (origin: origin, identity: identity),
      ];
      if (kept.isEmpty) {
        await _secure.delete(key: _pendingRevocationsKey).timeout(_timeout);
      } else {
        await _secure
            .write(
              key: _pendingRevocationsKey,
              value: jsonEncode([
                for (final entry in kept)
                  {..._identityToJson(entry.identity), 'origin': entry.origin},
              ]),
            )
            .timeout(_timeout);
      }
    } catch (error) {
      debugPrint(
        'Lotse: could not store pending revocations: ${error.runtimeType}',
      );
    }
  }

  /// All stored revocations with the server they belong to. An entry an older
  /// SDK version wrote has no origin; it counts as the current server, the
  /// only one that version could have talked to.
  Future<List<({String origin, LotseIdentity identity})>>
  _storedRevocations() async {
    final raw = await _secure
        .read(key: _pendingRevocationsKey)
        .timeout(_timeout);
    if (raw == null) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return [
      for (final entry in decoded)
        if (_identityFromJson(entry) case final identity?)
          (
            origin: entry is Map && entry['origin'] is String
                ? entry['origin'] as String
                : serverOrigin,
            identity: identity,
          ),
    ];
  }
}

Map<String, String?> _identityToJson(LotseIdentity identity) => {
  'installId': identity.installId,
  'credential': identity.credential,
};

LotseIdentity? _identityFromJson(Object? json) {
  if (json is! Map) return null;
  final installId = json['installId'];
  final credential = json['credential'];
  if (installId is! String || credential is! String) return null;
  return LotseIdentity(installId: installId, credential: credential);
}

/// The three calls the identity needs from the server. They come in as
/// functions, so the life cycle can be tested without a server.
class LotseIdentityServer {
  /// Creates the calls.
  const LotseIdentityServer({
    required this.register,
    required this.claim,
    required this.revoke,
    required this.isCredentialRefused,
    required this.isDeviceUnknown,
  });

  /// Registers or refreshes the device [installId]. [credential] is the one
  /// the install holds, null before the first claim: the server refreshes a
  /// device that has a credential only with it.
  final Future<void> Function(String installId, String? credential) register;

  /// Asks for the credential of [installId]. The server hands it out once.
  final Future<String> Function(String installId) claim;

  /// Revokes [credential] of [installId] and unregisters its push tokens.
  final Future<void> Function(String installId, String credential) revoke;

  /// Whether [error] is the server refusing the credential or the claim.
  final bool Function(Object error) isCredentialRefused;

  /// Whether [error] is the server not knowing the device (any more).
  final bool Function(Object error) isDeviceUnknown;
}

/// The identity of this install and its life cycle.
///
/// Every call to the server goes through [run] or [runPrivate], which bind it
/// to the identity it started with: when [reset] ends that identity while the
/// call is on its way, the answer is dropped instead of reaching the next
/// user. [generation] tells the pages to close.
class LotseIdentityManager {
  /// Creates the manager. [newInstallId] is replaced in tests.
  LotseIdentityManager({
    required this._store,
    required this._server,
    String Function()? newInstallId,
  }) : _newInstallId = newInstallId ?? const Uuid().v4;

  final LotseIdentityStore _store;
  final LotseIdentityServer _server;
  final String Function() _newInstallId;
  final _generation = ValueNotifier<int>(0);

  LotseIdentity? _current;
  bool _unavailable = false;
  Future<void> _queue = Future.value();
  Future<void> _storeQueue = Future.value();
  Future<String?>? _claiming;

  /// Counts the identities of this app start. It moves the moment [reset] is
  /// called, before anything is awaited.
  ValueListenable<int> get generation => _generation;

  /// The current identity. Throws before [load], and
  /// [LotseIdentityUnavailable] for a run whose stored identity could not be
  /// read.
  LotseIdentity get current =>
      _current ??
      (_unavailable
          ? throw const LotseIdentityUnavailable()
          : throw StateError('The identity is not loaded.'));

  /// Reads the stored identity or makes a new one. Does not talk to the
  /// server.
  ///
  /// When the secure storage does not answer, this run has no identity:
  /// nothing is written and no new install is started, so a stuck Keystore
  /// costs this run its Lotse calls, not the install its identity. The next
  /// app start reads again.
  Future<void> load() async {
    final LotseIdentity? stored;
    try {
      stored = await _store.read();
    } on LotseIdentityUnavailable {
      _unavailable = true;
      debugPrint('Lotse: no identity for this run, trying on the next start.');
      return;
    }
    if (stored != null) {
      _current = stored;
      return;
    }
    final identity = LotseIdentity(installId: _newInstallId());
    _current = identity;
    await _store.write(identity);
  }

  /// Registers the device and makes sure it has a credential. Also retries
  /// revocations that did not reach the server earlier.
  ///
  /// When the server refuses the install (its credential is held by someone
  /// else, was revoked, or got lost with the secure storage), the SDK goes on
  /// as a new install. Throws when the server cannot be reached.
  Future<void> connect() => _serialized(() async {
    if (_current == null && _unavailable) {
      throw const LotseIdentityUnavailable();
    }
    await _retryPendingRevocations();
    await _connectCurrent();
  });

  Future<void> _connectCurrent() async {
    try {
      await _registerAndClaim(current);
    } catch (error) {
      if (!_server.isCredentialRefused(error)) rethrow;
      debugPrint('Lotse: the install was refused, starting a new one.');
      await _startNewIdentity();
      await _registerAndClaim(current);
    }
  }

  Future<void> _registerAndClaim(LotseIdentity identity) async {
    await _server.register(identity.installId, identity.credential);
    if (identity.credential != null) return;
    final credential = await _server.claim(identity.installId);
    if (!identical(_current, identity)) return;
    final claimed = LotseIdentity(
      installId: identity.installId,
      credential: credential,
    );
    _current = claimed;
    await _withStore(() async {
      if (identical(_current, claimed)) await _store.write(claimed);
    });
  }

  /// Runs [call] for the current identity. For calls that work without the
  /// credential on an install that has none yet.
  Future<T> run<T>(
    Future<T> Function(String installId, String? credential) call,
  ) => _bound(() {
    final identity = current;
    return call(identity.installId, identity.credential);
  });

  /// Runs [call] for the current identity with its credential. Without one it
  /// tries to get it first and throws [LotseCredentialUnavailable] if that
  /// fails, before anything private is asked for.
  Future<T> runPrivate<T>(
    Future<T> Function(String installId, String credential) call,
  ) => _bound(() async {
    final started = _generation.value;
    var identity = current;
    if (identity.credential == null) {
      await _claimOnce();
      if (started != _generation.value) throw const LotseIdentityReplaced();
      identity = current;
    }
    final credential = identity.credential;
    if (credential == null) throw const LotseCredentialUnavailable();
    return call(identity.installId, credential);
  });

  /// Opens the stream [open] returns for the current identity with its
  /// credential, like [runPrivate] does for a call. The stream ends with
  /// [LotseIdentityReplaced] the moment [reset] ends that identity, so
  /// nothing of the old identity arrives after it. Getting the credential
  /// and opening happen when the stream is listened to; their errors arrive
  /// on the stream. A stream opened after its listener left is cancelled
  /// right away.
  Stream<T> watchPrivate<T>(
    Stream<T> Function(String installId, String credential) open,
  ) {
    late final StreamController<T> out;
    late final VoidCallback onReset;
    StreamSubscription<T>? source;
    var ended = false;
    final started = _generation.value;

    void end([Object? error]) {
      if (ended) return;
      ended = true;
      _generation.removeListener(onReset);
      unawaited(source?.cancel());
      source = null;
      if (error != null) out.addError(error);
      unawaited(out.close());
    }

    onReset = () {
      if (_generation.value != started) end(const LotseIdentityReplaced());
    };

    out = StreamController<T>(
      onListen: () async {
        _generation.addListener(onReset);
        final Stream<T> stream;
        try {
          stream = await runPrivate(
            (installId, credential) async => open(installId, credential),
          );
        } catch (error) {
          end(error);
          return;
        }
        // Cancelled or reset while the credential was on its way. The stream
        // may be open already; listening and cancelling closes it.
        if (ended) {
          unawaited(stream.listen(null).cancel());
          return;
        }
        source = stream.listen(
          out.add,
          onError: (Object error) => end(error),
          onDone: end,
          cancelOnError: true,
        );
      },
      onCancel: () {
        ended = true;
        _generation.removeListener(onReset);
        final cancel = source?.cancel();
        source = null;
        return cancel;
      },
    );
    return out.stream;
  }

  Future<String?> _claimOnce() => _claiming ??= () async {
    try {
      await connect();
    } catch (error) {
      debugPrint('Lotse: could not get the credential: ${error.runtimeType}');
    } finally {
      _claiming = null;
    }
    return _current?.credential;
  }();

  /// Drops the answer, or the error, of a call that outlived its identity.
  Future<T> _bound<T>(Future<T> Function() call) async {
    final started = _generation.value;
    try {
      final result = await call();
      if (started != _generation.value) throw const LotseIdentityReplaced();
      return result;
    } catch (_) {
      if (started != _generation.value) throw const LotseIdentityReplaced();
      rethrow;
    }
  }

  /// Ends the current identity and starts a new one, for a logout or an
  /// account switch in the host app. Never throws.
  ///
  /// In this order: [generation] moves at once, so answers still on their way
  /// are dropped and the pages close. The new identity and the revocation
  /// that is still owed are stored, so a crash or a missing network cannot
  /// bring the old identity back. [unregisterPush] deletes the push token of
  /// the device. The server revokes the old credential and deletes its push
  /// tokens; if it cannot be reached this is tried again on the next start
  /// and the next reset. At last the new install is registered.
  Future<void> reset({Future<void> Function()? unregisterPush}) {
    // Synchronous on purpose: whoever awaits anything after calling reset()
    // already is behind the barrier.
    _generation.value++;
    final previous = _current;
    final next = LotseIdentity(installId: _newInstallId());
    _current = next;
    _unavailable = false;

    // First what needs no network, and not behind [_queue]: a connect that
    // hangs on a dead connection must not keep the old identity on the disk,
    // where the next app start would find it.
    final persisted = _withStore(() async {
      try {
        if (previous?.credential != null) await _addOwed(previous!);
        // Only the newest reset writes itself; an older one must not bring
        // its install id back.
        if (identical(_current, next)) await _store.write(next);
      } catch (error) {
        debugPrint('Lotse: could not store the reset: ${error.runtimeType}');
      }
    });

    return _serialized(() async {
      try {
        await persisted;

        if (previous != null && previous.credential == null) {
          // An install that never got its credential would stay claimable by
          // whoever knows its id. Claim it now, only to revoke it.
          try {
            await _owe(
              LotseIdentity(
                installId: previous.installId,
                credential: await _server.claim(previous.installId),
              ),
            );
          } catch (error) {
            debugPrint(
              'Lotse: could not close the old install: ${error.runtimeType}',
            );
          }
        }

        if (unregisterPush != null) {
          try {
            await unregisterPush();
          } catch (error) {
            debugPrint(
              'Lotse: could not delete the push token: ${error.runtimeType}',
            );
          }
        }
        await _retryPendingRevocations();
        if (identical(_current, next)) await _connectCurrent();
      } catch (error) {
        debugPrint('Lotse: the reset is incomplete: ${error.runtimeType}');
      }
    });
  }

  /// Notes that the revocation of [identity] is owed to the server.
  Future<void> _owe(LotseIdentity identity) =>
      _withStore(() => _addOwed(identity));

  /// Only inside [_withStore].
  Future<void> _addOwed(LotseIdentity identity) async {
    final pending = [...await _store.pendingRevocations(), identity];
    await _store.writePendingRevocations(
      pending.length > maxPendingRevocations
          ? pending.sublist(pending.length - maxPendingRevocations)
          : pending,
    );
  }

  Future<void> _startNewIdentity() async {
    _generation.value++;
    final identity = LotseIdentity(installId: _newInstallId());
    _current = identity;
    await _withStore(() async {
      if (identical(_current, identity)) await _store.write(identity);
    });
  }

  Future<void> _retryPendingRevocations() async {
    final pending = await _store.pendingRevocations();
    if (pending.isEmpty) return;
    final open = <LotseIdentity>[];
    for (final identity in pending) {
      try {
        await _server.revoke(identity.installId, identity.credential!);
      } catch (error) {
        // Refused means it is revoked already or never was valid, unknown
        // means the team deleted the device: either way there is nothing
        // left to revoke.
        final done =
            _server.isCredentialRefused(error) ||
            _server.isDeviceUnknown(error);
        if (!done) open.add(identity);
      }
    }
    // Revocations a reset added in between stay. Read and write in one store
    // step, or a reset could add its own between the two and lose it.
    await _withStore(() async {
      final now = await _store.pendingRevocations();
      final handled = {for (final identity in pending) identity.installId};
      await _store.writePendingRevocations([
        ...open,
        for (final identity in now)
          if (!handled.contains(identity.installId)) identity,
      ]);
    });
  }

  /// One change of the store at a time. Separate from [_queue], which waits
  /// for the network.
  Future<T> _withStore<T>(Future<T> Function() step) {
    final result = _storeQueue.then((_) => step());
    _storeQueue = result.then<void>((_) {}, onError: (Object _) {});
    return result;
  }

  /// One life cycle step at a time; a failed one does not block the next.
  Future<void> _serialized(Future<void> Function() step) {
    final result = _queue.then((_) => step());
    _queue = result.catchError((Object _) {});
    return result;
  }
}
