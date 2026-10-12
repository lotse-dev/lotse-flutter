import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events kept on the device until the server has them, see
// `docs/OFFLINE.md`. `Lotse.track` puts every event into a [LotseEventQueue];
// what cannot be sent survives the end of the app and goes out on a later
// start.

/// Events kept while they cannot be sent. The oldest go first.
const lotseEventQueueLimit = 1000;

/// Events older than this are dropped unsent; the server drops them as well.
const lotseEventMaxAge = Duration(days: 30);

/// Events in one call; the server takes at most 100.
const lotseEventsPerCall = 100;

/// UTF-8 bytes of names, session ids and props in one call, as the server
/// counts them. 100 events at their limits would be far more.
const lotseEventBytesPerCall = 512 * 1024;

/// Next attempt after a call failed, while events wait.
const lotseEventRetryInterval = Duration(seconds: 30);

/// Pause after the server said the event budget is used up.
const lotseEventQuotaPause = Duration(minutes: 15);

/// Characters in an event name, after trimming.
const lotseEventNameMaxLength = 100;

/// Keys in the props of one event.
const lotseEventMaxProps = 20;

/// Characters in one props key or value.
const lotseEventPropMaxLength = 200;

/// One event waiting to be sent.
@immutable
class LotseQueuedEvent {
  const LotseQueuedEvent({
    required this.clientId,
    required this.installId,
    required this.name,
    required this.ts,
    this.sessionId,
    this.props,
  });

  /// Names the event on every attempt, so the server stores it once.
  final String clientId;

  /// The install the event was tracked for. It is sent for no other.
  final String installId;

  final String name;
  final DateTime ts;
  final String? sessionId;
  final Map<String, String>? props;

  Map<String, Object?> toJson() => {
    'clientId': clientId,
    'installId': installId,
    'name': name,
    'ts': ts.toUtc().toIso8601String(),
    'sessionId': ?sessionId,
    'props': ?props,
  };

  /// The event in [json], or null when it is not one.
  static LotseQueuedEvent? fromJson(Object? json) {
    if (json is! Map) return null;
    final clientId = json['clientId'];
    final installId = json['installId'];
    final name = json['name'];
    final ts = json['ts'];
    final sessionId = json['sessionId'];
    final props = json['props'];
    if (clientId is! String ||
        installId is! String ||
        name is! String ||
        ts is! String ||
        (sessionId != null && sessionId is! String) ||
        (props != null && props is! Map)) {
      return null;
    }
    final time = DateTime.tryParse(ts);
    if (time == null) return null;
    final Map<String, String>? parsedProps;
    if (props is Map) {
      if (props.entries.any((e) => e.key is! String || e.value is! String)) {
        return null;
      }
      parsedProps = props.cast<String, String>();
    } else {
      parsedProps = null;
    }
    return LotseQueuedEvent(
      clientId: clientId,
      installId: installId,
      name: name,
      ts: time.toUtc(),
      sessionId: sessionId as String?,
      props: parsedProps,
    );
  }
}

/// Why the server would refuse an event with [name] and [props], or null
/// when it would take it. The same limits as on the server: one refused
/// event costs the whole call, so it never gets into the queue.
String? lotseEventProblem(String name, Map<String, String>? props) {
  final trimmed = name.trim();
  if (trimmed.isEmpty || trimmed.length > lotseEventNameMaxLength) {
    return 'the name needs 1 to $lotseEventNameMaxLength characters';
  }
  if (props == null) return null;
  if (props.length > lotseEventMaxProps) {
    return 'at most $lotseEventMaxProps props';
  }
  for (final entry in props.entries) {
    if (entry.key.isEmpty ||
        entry.key.length > lotseEventPropMaxLength ||
        entry.value.length > lotseEventPropMaxLength) {
      return 'props keys and values need 1 to $lotseEventPropMaxLength '
          'characters';
    }
  }
  return null;
}

/// UTF-8 bytes of [event] as the server counts them for a call.
int lotseEventBytes(LotseQueuedEvent event) {
  var bytes = utf8.encode(event.name).length;
  bytes += utf8.encode(event.sessionId ?? '').length;
  for (final entry
      in event.props?.entries ?? const <MapEntry<String, String>>[]) {
    bytes += utf8.encode(entry.key).length + utf8.encode(entry.value).length;
  }
  return bytes;
}

/// Where the queue lives between app starts.
abstract interface class LotseEventStore {
  Future<List<LotseQueuedEvent>> read();
  Future<void> write(List<LotseQueuedEvent> events);
}

/// Keeps the queue in the shared preferences: a file of the app on Android
/// and iOS, the local storage in the browser.
class PreferencesLotseEventStore implements LotseEventStore {
  PreferencesLotseEventStore(this._preferences);

  static const _key = 'lotse.eventQueue';

  final SharedPreferences? _preferences;

  @override
  Future<List<LotseQueuedEvent>> read() async {
    final stored = _preferences?.getString(_key);
    if (stored == null) return const [];
    final Object? json;
    try {
      json = jsonDecode(stored);
    } on FormatException {
      return const [];
    }
    if (json is! List) return const [];
    return [for (final item in json) ?LotseQueuedEvent.fromJson(item)];
  }

  @override
  Future<void> write(List<LotseQueuedEvent> events) async {
    final preferences = _preferences;
    if (preferences == null) return;
    if (events.isEmpty) {
      await preferences.remove(_key);
    } else {
      await preferences.setString(
        _key,
        jsonEncode([for (final event in events) event.toJson()]),
      );
    }
  }
}

/// Keeps the queue for the run of the app only. For tests, and for an SDK
/// without a store.
class MemoryLotseEventStore implements LotseEventStore {
  List<LotseQueuedEvent> events = const [];

  @override
  Future<List<LotseQueuedEvent>> read() async => events;

  @override
  Future<void> write(List<LotseQueuedEvent> events) async =>
      this.events = List.unmodifiable(events);
}

/// Sends [events] of [installId] to the server.
typedef LotseEventSender =
    Future<void> Function(String installId, List<LotseQueuedEvent> events);

bool _never(Object _) => false;

/// The events not yet on the server, in the order they were tracked.
///
/// [add] stores an event before anything is sent, [flush] sends what waits
/// for the current install in calls of up to [lotseEventsPerCall]. A call
/// that fails keeps its events for the next attempt after
/// [lotseEventRetryInterval]; one the server refuses as invalid is dropped,
/// because it would be refused again.
class LotseEventQueue {
  LotseEventQueue({
    required this._store,
    required this._send,
    required this._installId,
    this._isRefused = _never,
    this._isOverQuota = _never,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final LotseEventStore _store;
  final LotseEventSender _send;
  final String? Function() _installId;
  final bool Function(Object error) _isRefused;
  final bool Function(Object error) _isOverQuota;
  final DateTime Function() _now;

  var _events = <LotseQueuedEvent>[];
  late final Future<void> _loaded = _load();
  Future<void> _writes = Future.value();
  Future<void>? _pendingWrite;
  Future<void>? _sending;
  Timer? _retry;
  DateTime? _pausedUntil;

  /// Events waiting to be sent.
  @visibleForTesting
  List<LotseQueuedEvent> get pending => List.unmodifiable(_events);

  /// Whether an attempt is scheduled.
  @visibleForTesting
  bool get retryScheduled => _retry != null;

  /// Reads what earlier runs left. Everything else waits for it, so nothing
  /// overwrites the stored queue before it is read.
  Future<void> load() => _loaded;

  Future<void> _load() async {
    try {
      final stored = await _store.read();
      _events = _trimmed(stored);
    } catch (error) {
      debugPrint('Lotse: could not read the event queue: ${error.runtimeType}');
    }
  }

  /// Puts [event] at the end of the queue and stores the queue.
  Future<void> add(LotseQueuedEvent event) async {
    await _loaded;
    _events = _trimmed([..._events, event]);
    await _persist();
  }

  /// Sends what waits for the current install. Waits for a send already
  /// running first, then sends what arrived meanwhile. Never throws.
  Future<void> flush() async {
    await _loaded;
    for (var running = _sending; running != null; running = _sending) {
      await running;
    }
    final paused = _pausedUntil;
    if (paused != null && _now().isBefore(paused)) return;
    _pausedUntil = null;
    final sending = _sendAll();
    _sending = sending;
    try {
      await sending;
    } finally {
      _sending = null;
    }
  }

  /// Tries again after [lotseEventRetryInterval], unless an attempt is
  /// scheduled already.
  void retryLater() => _schedule(lotseEventRetryInterval);

  /// Drops every event, e.g. when the identity ends.
  Future<void> clear() async {
    await _loaded;
    _retry?.cancel();
    _retry = null;
    _pausedUntil = null;
    _events = [];
    await _persist();
  }

  void dispose() {
    _retry?.cancel();
    _retry = null;
  }

  Future<void> _sendAll() async {
    _retry?.cancel();
    _retry = null;
    while (true) {
      final String? installId;
      try {
        installId = _installId();
      } catch (_) {
        return;
      }
      // Without an identity in this run the events wait for the next start.
      if (installId == null) return;
      final kept = _trimmed([
        for (final event in _events)
          if (event.installId == installId) event,
      ]);
      if (kept.length != _events.length) {
        _events = kept;
        await _persist();
      }
      if (_events.isEmpty) return;

      final batch = _nextBatch();
      try {
        await _send(installId, batch);
      } catch (error) {
        if (_isRefused(error)) {
          debugPrint('Lotse: the server refused ${batch.length} events.');
        } else if (_isOverQuota(error)) {
          debugPrint('Lotse: the event budget is used up, pausing.');
          _pausedUntil = _now().add(lotseEventQuotaPause);
          _schedule(lotseEventQuotaPause);
          return;
        } else {
          debugPrint('Lotse: could not send events: ${error.runtimeType}');
          _schedule(lotseEventRetryInterval);
          return;
        }
      }
      final sent = {for (final event in batch) event.clientId};
      _events = [
        for (final event in _events)
          if (!sent.contains(event.clientId)) event,
      ];
      await _persist();
    }
  }

  /// The oldest events, as many as one call takes.
  List<LotseQueuedEvent> _nextBatch() {
    final batch = <LotseQueuedEvent>[];
    var bytes = 0;
    for (final event in _events) {
      final size = lotseEventBytes(event);
      if (batch.length == lotseEventsPerCall ||
          (batch.isNotEmpty && bytes + size > lotseEventBytesPerCall)) {
        break;
      }
      batch.add(event);
      bytes += size;
    }
    return batch;
  }

  /// [events] without those too old to send, and without the oldest beyond
  /// [lotseEventQueueLimit].
  List<LotseQueuedEvent> _trimmed(List<LotseQueuedEvent> events) {
    final oldest = _now().subtract(lotseEventMaxAge);
    final fresh = [
      for (final event in events)
        if (!event.ts.isBefore(oldest)) event,
    ];
    return fresh.length > lotseEventQueueLimit
        ? fresh.sublist(fresh.length - lotseEventQueueLimit)
        : fresh;
  }

  void _schedule(Duration delay) {
    _retry ??= Timer(delay, () {
      _retry = null;
      unawaited(flush());
    });
  }

  /// Stores the queue. Changes that come in while a write waits to start go
  /// into that write.
  Future<void> _persist() {
    if (_pendingWrite case final pending?) return pending;
    final write = _writes.then((_) async {
      _pendingWrite = null;
      try {
        await _store.write(List.unmodifiable(_events));
      } catch (error) {
        debugPrint(
          'Lotse: could not store the event queue: ${error.runtimeType}',
        );
      }
    });
    _pendingWrite = write;
    _writes = write;
    return write;
  }
}
