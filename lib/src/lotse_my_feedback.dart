import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

import 'lotse_feedback.dart';
import 'lotse_log.dart';

/// How often an open conversation asks the server for new replies while the
/// live stream is not there.
const lotseThreadPollInterval = Duration(seconds: 5);

/// How long an open conversation waits before it opens the live stream
/// again after it failed or ended: one entry per failure in a row, the last
/// one repeats. A stream that delivered starts over at the first entry.
const lotseLiveRetryDelays = [
  Duration(seconds: 2),
  Duration(seconds: 5),
  Duration(seconds: 15),
  Duration(seconds: 30),
  Duration(minutes: 1),
];

/// Where the team stands with a feedback message.
enum LotseMyFeedbackStatus {
  /// Nobody has picked it up yet.
  open,

  /// The team is working on it.
  inProgress,

  /// The team is done with it.
  done,

  /// The team will not act on it.
  dismissed,
}

/// A feedback message of this device in the list of "My feedback".
@immutable
class LotseMyFeedback {
  /// Creates a list entry.
  const LotseMyFeedback({
    required this.id,
    required this.category,
    required this.message,
    required this.status,
    required this.createdAt,
    required this.unreadCount,
    this.lastMessageAt,
  });

  /// Identifies the message on the server.
  final int id;

  /// What the message is about.
  final LotseFeedbackCategory category;

  /// The text the user sent. It opens the conversation.
  final String message;

  /// Where the team stands with it.
  final LotseMyFeedbackStatus status;

  /// When the user sent it.
  final DateTime createdAt;

  /// When the last reply arrived, `null` without one.
  final DateTime? lastMessageAt;

  /// Team replies the user has not read yet.
  final int unreadCount;
}

/// One reply in a conversation.
@immutable
class LotseFeedbackReply {
  /// Creates a reply.
  const LotseFeedbackReply({
    required this.id,
    required this.fromTeam,
    required this.body,
    required this.createdAt,
  });

  /// Identifies the reply on the server.
  final int id;

  /// `true` for a reply of the team, `false` for one of the user.
  final bool fromTeam;

  /// The text.
  final String body;

  /// When it was written.
  final DateTime createdAt;
}

/// A feedback message with its conversation, oldest reply first.
@immutable
class LotseFeedbackThread {
  /// Creates a thread.
  const LotseFeedbackThread({required this.feedback, required this.replies});

  /// The message that opened the conversation.
  final LotseMyFeedback feedback;

  /// The replies of both sides, oldest first.
  final List<LotseFeedbackReply> replies;
}

/// How an attempt to send a reply ended.
enum LotseReplyResult {
  /// The server stored the reply.
  sent,

  /// A quota is used up. Trying again right away will not help.
  limitReached,

  /// Anything else: no network, a server error, a rejected input.
  failed,
}

/// The conversations of this device. No method throws; a failed read is
/// `null`.
abstract interface class LotseConversations {
  /// The feedback messages of this device, the conversation that moved last
  /// first.
  Future<List<LotseMyFeedback>?> list();

  /// One feedback message with its conversation.
  Future<LotseFeedbackThread?> thread(int feedbackId);

  /// Appends a reply of the user.
  Future<LotseReplyResult> reply(int feedbackId, String body);

  /// Marks the team's replies as read. `false` if the call failed.
  Future<bool> markRead(int feedbackId);

  /// Live updates of one conversation: an event each time it changed, the
  /// first one as soon as the stream is open. Errors arrive on the stream;
  /// it may end at any time, and then the caller polls and opens it again.
  Stream<void> changes(int feedbackId);
}

/// [source] with a cancel that waits for the first event, an error or the
/// end, whichever comes first.
///
/// The Serverpod client opens a streaming method when it is called and
/// learns how to close it only once the server confirmed it. A subscription
/// cancelled in between leaves the stream open on the server until it ends.
/// The conversation stream always starts with an event right after the
/// confirmation, so waiting for it closes the stream properly.
Stream<T> lotseCancelAfterFirst<T>(Stream<T> source) {
  late final StreamController<T> out;
  StreamSubscription<T>? subscription;
  var delivered = false;
  var leaving = false;

  void leave() {
    final open = subscription;
    subscription = null;
    if (open != null) unawaited(open.cancel());
  }

  out = StreamController<T>(
    onListen: () {
      subscription = source.listen(
        (event) {
          delivered = true;
          if (leaving) {
            leave();
            return;
          }
          out.add(event);
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!leaving) out.addError(error, stackTrace);
        },
        onDone: () {
          subscription = null;
          if (!leaving) unawaited(out.close());
        },
      );
    },
    // The close goes out without being waited for: a listener that cancels
    // on an error gets the error only once its cancel is done.
    onCancel: () {
      leaving = true;
      if (delivered) leave();
    },
  );
  return out.stream;
}

/// A [LotseConversations.changes] stream that cannot be opened, for an SDK
/// without live updates.
class LotseLiveUnavailable implements Exception {
  /// Creates the error.
  const LotseLiveUnavailable();

  @override
  String toString() => 'LotseLiveUnavailable';
}

/// [LotseConversations] on the generated client. The calls come in as
/// functions, so the mapping can be tested without a server.
///
/// Failures are logged with their kind only, never with a message text.
class ServerLotseConversations implements LotseConversations {
  /// Creates the conversations of the device [installId]. Without
  /// [watchMyFeedback] there are no live updates and an open conversation
  /// polls.
  ServerLotseConversations({
    required this.installId,
    required Future<List<generated.MyFeedback>> Function(String installId)
    listMyFeedback,
    required Future<generated.MyFeedbackThread> Function(
      String installId,
      int feedbackId,
    )
    getMyFeedback,
    required Future<int> Function(String installId, int feedbackId, String body)
    replyToFeedback,
    required Future<void> Function(String installId, int feedbackId)
    markFeedbackRead,
    Stream<generated.FeedbackConversationChange> Function(
      String installId,
      int feedbackId,
    )?
    watchMyFeedback,
  }) : _list = listMyFeedback,
       _get = getMyFeedback,
       _reply = replyToFeedback,
       _markRead = markFeedbackRead,
       _watch = watchMyFeedback;

  /// Identifies this install.
  final String installId;

  final Future<List<generated.MyFeedback>> Function(String) _list;
  final Future<generated.MyFeedbackThread> Function(String, int) _get;
  final Future<int> Function(String, int, String) _reply;
  final Future<void> Function(String, int) _markRead;
  final Stream<generated.FeedbackConversationChange> Function(String, int)?
  _watch;

  @override
  Stream<void> changes(int feedbackId) {
    final watch = _watch;
    if (watch == null) return Stream.error(const LotseLiveUnavailable());
    try {
      // Only the event counts. A change of another conversation cannot come
      // from the server; it is dropped all the same.
      return watch(
        installId,
        feedbackId,
      ).where((change) => change.feedbackId == feedbackId).map<void>((_) {});
    } catch (error) {
      return Stream.error(error);
    }
  }

  @override
  Future<List<LotseMyFeedback>?> list() async {
    try {
      return [
        for (final feedback in await _list(installId))
          lotseMyFeedbackFrom(feedback),
      ];
    } catch (error) {
      debugPrint('Lotse: could not load the feedback: ${error.runtimeType}');
      return null;
    }
  }

  @override
  Future<LotseFeedbackThread?> thread(int feedbackId) async {
    try {
      final thread = await _get(installId, feedbackId);
      return LotseFeedbackThread(
        feedback: lotseMyFeedbackFrom(thread.feedback),
        replies: [
          for (final message in thread.messages)
            LotseFeedbackReply(
              id: message.id,
              fromTeam: message.author == generated.FeedbackMessageAuthor.team,
              body: message.body,
              createdAt: message.createdAt,
            ),
        ],
      );
    } catch (error) {
      debugPrint(
        'Lotse: could not load the conversation: ${error.runtimeType}',
      );
      return null;
    }
  }

  @override
  Future<LotseReplyResult> reply(int feedbackId, String body) async {
    try {
      await _reply(installId, feedbackId, body);
      return LotseReplyResult.sent;
    } on generated.LotseQuotaExceededException {
      debugPrint('Lotse: the reply quota is used up.');
      return LotseReplyResult.limitReached;
    } catch (error) {
      debugPrint('Lotse: could not send the reply: ${error.runtimeType}');
      return LotseReplyResult.failed;
    }
  }

  @override
  Future<bool> markRead(int feedbackId) async {
    try {
      await _markRead(installId, feedbackId);
      return true;
    } catch (error) {
      debugPrint(
        'Lotse: could not mark the conversation read: ${error.runtimeType}',
      );
      return false;
    }
  }
}

/// Maps the generated list entry to the SDK's own type. The generated types
/// never leave the SDK.
LotseMyFeedback lotseMyFeedbackFrom(generated.MyFeedback feedback) =>
    LotseMyFeedback(
      id: feedback.id,
      category: switch (feedback.category) {
        generated.FeedbackCategory.bug => LotseFeedbackCategory.bug,
        generated.FeedbackCategory.idea => LotseFeedbackCategory.idea,
        generated.FeedbackCategory.praise => LotseFeedbackCategory.praise,
        generated.FeedbackCategory.other => LotseFeedbackCategory.other,
        generated.FeedbackCategory.question => LotseFeedbackCategory.question,
      },
      message: feedback.message,
      status: switch (feedback.status) {
        generated.FeedbackStatus.open => LotseMyFeedbackStatus.open,
        generated.FeedbackStatus.inProgress => LotseMyFeedbackStatus.inProgress,
        generated.FeedbackStatus.done => LotseMyFeedbackStatus.done,
        generated.FeedbackStatus.dismissed => LotseMyFeedbackStatus.dismissed,
      },
      createdAt: feedback.createdAt,
      lastMessageAt: feedback.lastMessageAt,
      unreadCount: feedback.unreadCount,
    );

/// How many team replies this device has not read yet, for a badge.
///
/// The number only changes through [refresh]: the SDK calls it at start, when
/// a push announces a reply and after a conversation was read. A failed
/// refresh keeps the last number.
class LotseUnreadFeedback {
  /// Creates the counter on [_conversations].
  LotseUnreadFeedback(this._conversations);

  final LotseConversations _conversations;
  final _count = ValueNotifier<int>(0);
  int _generation = 0;

  /// The number of unread team replies over all conversations.
  ValueListenable<int> get count => _count;

  /// Forgets the number and any refresh still on its way, for the moment the
  /// identity of the install ends.
  void clear() {
    _generation++;
    _count.value = 0;
  }

  /// Asks the server. Never throws.
  Future<void> refresh() async {
    final generation = ++_generation;
    final list = await _conversations.list();
    // A refresh that was overtaken by a later one must not win with its
    // older answer.
    if (list == null || generation != _generation) return;
    _count.value = list.fold(0, (sum, feedback) => sum + feedback.unreadCount);
  }
}

/// Loading state of [LotseMyFeedbackListController] and
/// [LotseFeedbackThreadController].
enum LotseLoadStatus {
  /// The first answer is on its way.
  loading,

  /// There is something to show.
  loaded,

  /// The first load failed; there is nothing to show.
  failed,
}

/// The state of the list "My feedback". Plain Dart, the page only renders it.
class LotseMyFeedbackListController extends ChangeNotifier {
  /// Creates the state of the list on [_conversations].
  LotseMyFeedbackListController(this._conversations);

  final LotseConversations _conversations;
  bool _disposed = false;

  /// Whether there is something to show.
  LotseLoadStatus get status => _status;
  LotseLoadStatus _status = LotseLoadStatus.loading;

  /// The feedback messages of this device.
  List<LotseMyFeedback> get items => _items;
  List<LotseMyFeedback> _items = const [];

  /// Loads the list, also again after the user returns from a conversation.
  /// A failed reload keeps the list that is there.
  Future<void> load() async {
    final list = await _conversations.list();
    if (_disposed) return;
    if (list != null) {
      _items = List.unmodifiable(list);
      _status = LotseLoadStatus.loaded;
    } else if (_status != LotseLoadStatus.loaded) {
      _status = LotseLoadStatus.failed;
    }
    notifyListeners();
  }

  /// Shows the spinner and loads again after a failed first load.
  Future<void> retry() {
    _status = LotseLoadStatus.loading;
    notifyListeners();
    return load();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

/// The state of one open conversation: the thread, live updates, reading
/// and replying. Plain Dart, the page only renders it.
///
/// [start] loads the thread and opens the live stream of the conversation
/// (a Serverpod streaming method over WebSocket): every event on it loads
/// the thread again. Until the stream delivers, and whenever it fails or
/// ends, the controller polls every [pollInterval] and opens the stream again
/// after [liveRetryDelays]. All of it stops at [dispose], so the server is
/// only asked while the conversation is on screen. The page calls [pause]
/// while the app is not in front: a timer keeps running in a backgrounded
/// app, and a reply nobody saw must not be marked read.
class LotseFeedbackThreadController extends ChangeNotifier {
  /// Creates the state of the conversation [feedbackId]. [onRead] runs after
  /// the server has marked the team's replies read.
  LotseFeedbackThreadController(
    this._conversations,
    this.feedbackId, {
    this.pollInterval = lotseThreadPollInterval,
    this.liveRetryDelays = lotseLiveRetryDelays,
    this.onRead,
  }) : assert(liveRetryDelays.isNotEmpty, 'At least one retry delay.');

  final LotseConversations _conversations;

  /// The conversation this controller shows.
  final int feedbackId;

  /// How often the server is asked for new replies without the live stream.
  final Duration pollInterval;

  /// How long to wait before the live stream is opened again, see
  /// [lotseLiveRetryDelays].
  final List<Duration> liveRetryDelays;

  /// Called after unread team replies were marked read.
  final VoidCallback? onRead;

  Timer? _timer;
  Timer? _retry;
  StreamSubscription<void>? _live;
  bool _isLive = false;
  int _liveFailures = 0;
  bool _running = false;
  bool _loading = false;
  bool _loadAgain = false;
  bool _paused = false;
  bool _disposed = false;

  /// Whether there is something to show.
  LotseLoadStatus get status => _status;
  LotseLoadStatus _status = LotseLoadStatus.loading;

  /// The conversation, `null` until the first load succeeded.
  LotseFeedbackThread? get thread => _thread;
  LotseFeedbackThread? _thread;

  /// `true` while new replies arrive over the live stream, `false` while the
  /// controller polls.
  bool get isLive => _isLive;

  /// `true` while a reply is on its way.
  bool get isSending => _sending;
  bool _sending = false;

  /// How the last reply failed, `null` if it did not. The text stays in the
  /// field, so the user can try again.
  LotseReplyResult? get replyFailure => _replyFailure;
  LotseReplyResult? _replyFailure;

  /// `true` if [body] can go out now.
  bool canReply(String body) {
    final trimmed = body.trim();
    return !_sending &&
        _thread != null &&
        trimmed.isNotEmpty &&
        trimmed.length <= maxFeedbackMessageLength;
  }

  /// Loads the thread, opens the live stream and polls until it delivers.
  /// Calling it twice does nothing.
  void start() {
    if (_disposed || _running) return;
    _running = true;
    _poll();
    _openLive();
    unawaited(refresh());
  }

  /// Stops live updates, polling and marking read until [resume], for the
  /// time the app is not in front.
  void pause() {
    if (_disposed || !_running) return;
    _paused = true;
    _stop();
  }

  /// Loads the thread again and goes on with live updates after a [pause].
  void resume() {
    if (!_paused) return;
    _paused = false;
    start();
  }

  void _stop() {
    _running = false;
    _isLive = false;
    _timer?.cancel();
    _timer = null;
    _retry?.cancel();
    _retry = null;
    final live = _live;
    _live = null;
    if (live != null) unawaited(_cancelQuietly(live));
  }

  static Future<void> _cancelQuietly(StreamSubscription<void> live) async {
    try {
      await live.cancel();
    } catch (error) {
      lotseLog('could not close the live conversation', error);
    }
  }

  void _poll() {
    _timer ??= Timer.periodic(pollInterval, (_) => unawaited(refresh()));
  }

  void _openLive() {
    if (!_running) return;
    try {
      _live = _conversations
          .changes(feedbackId)
          .listen(
            (_) => _onChange(),
            onError: (Object error) => _onLiveEnded(error),
            onDone: _onLiveEnded,
            cancelOnError: true,
          );
    } catch (error) {
      _onLiveEnded(error);
    }
  }

  void _onChange() {
    if (!_running) return;
    if (!_isLive) {
      // The stream is there: no more polling, and the next failure waits
      // the shortest time again.
      _isLive = true;
      _liveFailures = 0;
      _timer?.cancel();
      _timer = null;
    }
    unawaited(refresh());
  }

  void _onLiveEnded([Object? error]) {
    _live = null;
    _isLive = false;
    if (!_running) return;
    if (error != null) lotseLog('the live conversation stopped', error);
    _poll();
    final delay =
        liveRetryDelays[_liveFailures.clamp(0, liveRetryDelays.length - 1)];
    _liveFailures++;
    _retry?.cancel();
    _retry = Timer(delay, () {
      _retry = null;
      _openLive();
    });
  }

  /// Shows the spinner and loads again after a failed first load.
  Future<void> retry() {
    _status = LotseLoadStatus.loading;
    notifyListeners();
    return refresh();
  }

  /// Asks the server for the thread and marks new team replies read. A failed
  /// poll keeps the thread that is there.
  ///
  /// Only one load runs at a time. A call that finds one running makes it run
  /// once more when it is done, so a reply sent in between still shows up.
  Future<void> refresh() async {
    if (_disposed) return;
    if (_loading) {
      _loadAgain = true;
      return;
    }
    _loading = true;
    try {
      do {
        _loadAgain = false;
        await _loadOnce();
      } while (_loadAgain && !_disposed);
    } finally {
      _loading = false;
    }
  }

  Future<void> _loadOnce() async {
    final thread = await _conversations.thread(feedbackId);
    if (_disposed) return;
    if (thread != null) {
      _thread = thread;
      _status = LotseLoadStatus.loaded;
    } else if (_status != LotseLoadStatus.loaded) {
      _status = LotseLoadStatus.failed;
    }
    notifyListeners();

    // The thread is on screen, so what arrived has been seen. An answer that
    // comes in after a pause has not; the load on resume marks it.
    if (thread != null && thread.feedback.unreadCount > 0 && !_paused) {
      final marked = await _conversations.markRead(feedbackId);
      if (marked && !_disposed) onRead?.call();
    }
  }

  /// Sends [body] as a reply of the user. Returns `true` if the server took
  /// it, so the page can empty the field. Never throws.
  Future<bool> reply(String body) async {
    if (!canReply(body)) return false;
    _sending = true;
    _replyFailure = null;
    notifyListeners();

    final result = await _conversations.reply(feedbackId, body.trim());
    if (_disposed) return false;
    _sending = false;
    _replyFailure = result == LotseReplyResult.sent ? null : result;
    notifyListeners();
    if (result != LotseReplyResult.sent) return false;
    await refresh();
    return true;
  }

  @override
  void dispose() {
    _disposed = true;
    _stop();
    super.dispose();
  }
}
