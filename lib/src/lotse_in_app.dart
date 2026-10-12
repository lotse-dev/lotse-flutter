import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

/// How an in-app message appears.
enum LotseInAppStyle {
  /// A card in the middle of the screen above the dimmed app, with a button
  /// and a close icon.
  card,

  /// A narrow strip at the top of the screen. Tapping it opens, the close
  /// icon dismisses it.
  banner,
}

/// A message the team wrote in the Lotse console for a segment of devices,
/// shown inside the app by `LotseInAppMessages`.
@immutable
class LotseInAppMessage {
  /// Creates a message.
  const LotseInAppMessage({
    required this.id,
    required this.title,
    required this.body,
    required this.style,
    this.buttonLabel,
    this.targetPath,
    this.slug,
  });

  /// Identifies the message.
  final int id;

  /// The headline.
  final String title;

  /// The text below the headline.
  final String body;

  /// Card or banner.
  final LotseInAppStyle style;

  /// Label of the card's button as the team wrote it. Null for the built-in
  /// "Open".
  final String? buttonLabel;

  /// The app route of the message's link, the same deep link a push opens,
  /// for example `/offer/42`. Null when the message has no link.
  final String? targetPath;

  /// Slug of the message's link, null without one.
  final String? slug;
}

/// Event names the SDK tracks for an in-app message, each with the prop
/// [lotseInAppMessageIdProp]. Must match `in_app_messages.dart` on the
/// server.
const lotseInAppViewEvent = 'in_app_view';
const lotseInAppTapEvent = 'in_app_tap';
const lotseInAppDismissEvent = 'in_app_dismiss';
const lotseInAppMessageIdProp = 'messageId';

/// Least time between two automatic fetches, on start and whenever the app
/// comes back to the front.
const lotseInAppFetchInterval = Duration(minutes: 1);

/// The message of the server as the SDK hands it to the app.
LotseInAppMessage lotseInAppMessageFrom(generated.SdkInAppMessage message) =>
    LotseInAppMessage(
      id: message.id,
      title: message.title,
      body: message.body,
      style: switch (message.style) {
        generated.InAppMessageStyle.card => LotseInAppStyle.card,
        generated.InAppMessageStyle.banner => LotseInAppStyle.banner,
      },
      buttonLabel: message.buttonLabel,
      targetPath: message.targetPath,
      slug: message.slug,
    );

/// Asks the server for the messages of this device.
typedef LotseInAppFetch = Future<List<LotseInAppMessage>> Function();

/// Tracks an in-app event with its props.
typedef LotseInAppTrack =
    Future<void> Function(String name, Map<String, String> props);

/// Which in-app message the app shows now, one at a time.
///
/// [check] fetches the messages of the device, at most once per
/// [minInterval] unless forced, and shows the newest one the user has not
/// tapped or closed. The next one waits for the next check, so closing a
/// card never brings up another right away. [shown], [tapped] and
/// [dismissed] track the events; a tapped or closed message does not come
/// again, one that was only seen does, on a later start.
class LotseInAppInbox {
  /// An inbox over [fetch] and [track]. [clock] is for tests.
  LotseInAppInbox({
    required this._fetch,
    required this._track,
    DateTime Function()? clock,
    this.minInterval = lotseInAppFetchInterval,
  }) : _clock = clock ?? DateTime.now;

  final LotseInAppFetch _fetch;
  final LotseInAppTrack _track;
  final DateTime Function() _clock;

  /// Least time between two checks that are not forced.
  final Duration minInterval;

  /// The message to show, null for none.
  ValueListenable<LotseInAppMessage?> get current => _current;
  final _current = ValueNotifier<LotseInAppMessage?>(null);

  /// Tapped or closed on this device. The server knows it from the events,
  /// but a check can come before they arrive.
  final _done = <int>{};

  /// Seen in this run of the app; the view is tracked once per run.
  final _viewed = <int>{};

  DateTime? _lastCheck;
  bool _checking = false;

  /// Counts [clear]: an answer to a check from before is dropped.
  int _generation = 0;

  /// Fetches the messages and shows the newest one, unless one is shown
  /// already. Without [force] it does nothing within [minInterval] of the
  /// last check. Never throws.
  Future<void> check({bool force = false}) async {
    if (_checking) return;
    final now = _clock();
    final last = _lastCheck;
    if (!force && last != null && now.difference(last) < minInterval) return;
    _lastCheck = now;
    _checking = true;
    final generation = _generation;
    try {
      final messages = await _fetch();
      if (generation != _generation || _current.value != null) return;
      _current.value = messages.where((m) => !_done.contains(m.id)).firstOrNull;
    } catch (error) {
      debugPrint(
        'Lotse: could not fetch in-app messages: ${error.runtimeType}',
      );
    } finally {
      if (generation == _generation) _checking = false;
    }
  }

  /// The app shows [message]. Tracks the view once per run of the app.
  void shown(LotseInAppMessage message) {
    if (!_viewed.add(message.id)) return;
    unawaited(_track(lotseInAppViewEvent, _props(message)));
  }

  /// The user tapped [message]: its button or the banner.
  void tapped(LotseInAppMessage message) =>
      _finish(message, lotseInAppTapEvent);

  /// The user closed [message] without tapping it.
  void dismissed(LotseInAppMessage message) =>
      _finish(message, lotseInAppDismissEvent);

  void _finish(LotseInAppMessage message, String event) {
    if (_current.value?.id != message.id) return;
    _done.add(message.id);
    _current.value = null;
    unawaited(_track(event, _props(message)));
  }

  /// Forgets everything, for a new identity: the messages of the previous
  /// user must not show for the next one.
  void clear() {
    _generation++;
    _checking = false;
    _lastCheck = null;
    _done.clear();
    _viewed.clear();
    _current.value = null;
  }

  Map<String, String> _props(LotseInAppMessage message) => {
    lotseInAppMessageIdProp: '${message.id}',
  };
}

/// The inbox of the initialised SDK, null before `Lotse.init`. Internal:
/// `LotseInAppMessages` shows what it holds.
final lotseInAppInbox = ValueNotifier<LotseInAppInbox?>(null);
