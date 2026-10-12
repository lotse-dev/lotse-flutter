import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_feedback.dart';
import 'package:lotse/src/lotse_my_feedback.dart';

final _sentAt = DateTime.utc(2026, 9, 1, 10);
final _repliedAt = DateTime.utc(2026, 9, 2, 8, 30);

LotseMyFeedback _feedback(int id, {int unread = 0}) => LotseMyFeedback(
  id: id,
  category: LotseFeedbackCategory.bug,
  message: 'Message $id',
  status: LotseMyFeedbackStatus.open,
  createdAt: _sentAt,
  unreadCount: unread,
);

LotseFeedbackThread _thread(int id, {int unread = 0, int replies = 0}) =>
    LotseFeedbackThread(
      feedback: _feedback(id, unread: unread),
      replies: [
        for (var i = 1; i <= replies; i++)
          LotseFeedbackReply(
            id: i,
            fromTeam: i.isOdd,
            body: 'Reply $i',
            createdAt: _repliedAt,
          ),
      ],
    );

/// Conversations held in memory. `null` answers stand for a failed call.
class _FakeConversations implements LotseConversations {
  List<LotseMyFeedback>? listAnswer = const [];
  LotseFeedbackThread? threadAnswer;
  LotseReplyResult replyAnswer = LotseReplyResult.sent;
  bool markReadAnswer = true;

  /// When set, `thread` waits for it.
  Completer<void>? threadGate;

  int listCalls = 0;
  int threadCalls = 0;
  final replies = <(int, String)>[];
  final markedRead = <int>[];

  @override
  Future<List<LotseMyFeedback>?> list() async {
    listCalls++;
    return listAnswer;
  }

  @override
  Future<LotseFeedbackThread?> thread(int feedbackId) async {
    threadCalls++;
    final answer = threadAnswer;
    await threadGate?.future;
    return answer;
  }

  @override
  Future<LotseReplyResult> reply(int feedbackId, String body) async {
    replies.add((feedbackId, body));
    return replyAnswer;
  }

  @override
  Future<bool> markRead(int feedbackId) async {
    markedRead.add(feedbackId);
    return markReadAnswer;
  }

  /// Whether [changes] opens a stream. Without, it fails at once, like a
  /// server that cannot be reached.
  bool liveAvailable = false;

  /// Every stream [changes] opened, oldest first. The test adds the events.
  final opened = <StreamController<void>>[];

  /// How often [changes] was asked, opened or not.
  int liveAsked = 0;

  @override
  Stream<void> changes(int feedbackId) {
    liveAsked++;
    if (!liveAvailable) return Stream.error(const LotseLiveUnavailable());
    final live = StreamController<void>();
    opened.add(live);
    return live.stream;
  }
}

ServerLotseConversations _server({
  Future<List<generated.MyFeedback>> Function(String)? list,
  Future<generated.MyFeedbackThread> Function(String, int)? get,
  Future<int> Function(String, int, String)? reply,
  Future<void> Function(String, int)? markRead,
}) => ServerLotseConversations(
  installId: 'install-1',
  listMyFeedback: list ?? (_) async => [],
  getMyFeedback: get ?? (_, _) => throw StateError('unused'),
  replyToFeedback: reply ?? (_, _, _) async => 1,
  markFeedbackRead: markRead ?? (_, _) async {},
);

void main() {
  group('Given the generated conversation calls', () {
    final row = generated.MyFeedback(
      id: 7,
      category: generated.FeedbackCategory.idea,
      message: 'Dark mode please',
      status: generated.FeedbackStatus.inProgress,
      createdAt: _sentAt,
      lastMessageAt: _repliedAt,
      unreadCount: 2,
    );

    test('when the live stream is opened then it is the one of this install '
        'and conversation, and every change is one event', () async {
      final asked = <(String, int)>[];
      final server = StreamController<generated.FeedbackConversationChange>();
      final conversations = ServerLotseConversations(
        installId: 'install-1',
        listMyFeedback: (_) async => [],
        getMyFeedback: (_, _) => throw StateError('unused'),
        replyToFeedback: (_, _, _) async => 1,
        markFeedbackRead: (_, _) async {},
        watchMyFeedback: (installId, feedbackId) {
          asked.add((installId, feedbackId));
          return server.stream;
        },
      );

      final events = <void>[];
      final subscription = conversations.changes(7).listen(events.add);
      server
        ..add(generated.FeedbackConversationChange(feedbackId: 7))
        ..add(generated.FeedbackConversationChange(feedbackId: 8))
        ..add(generated.FeedbackConversationChange(feedbackId: 7));
      await pumpEventQueue();

      expect(asked, [('install-1', 7)]);
      expect(events, hasLength(2));
      await subscription.cancel();
    });

    test('when there is no live stream then it fails with '
        'LotseLiveUnavailable instead of throwing', () async {
      final conversations = _server();

      await expectLater(
        conversations.changes(7),
        emitsError(isA<LotseLiveUnavailable>()),
      );
    });

    test('when the list is read '
        'then every field arrives in the SDK types for this install', () async {
      late String askedInstallId;
      final conversations = _server(
        list: (installId) async {
          askedInstallId = installId;
          return [row];
        },
      );

      final list = await conversations.list();

      expect(askedInstallId, 'install-1');
      final feedback = list!.single;
      expect(feedback.id, 7);
      expect(feedback.category, LotseFeedbackCategory.idea);
      expect(feedback.message, 'Dark mode please');
      expect(feedback.status, LotseMyFeedbackStatus.inProgress);
      expect(feedback.createdAt, _sentAt);
      expect(feedback.lastMessageAt, _repliedAt);
      expect(feedback.unreadCount, 2);
    });

    test('when every generated category and status is mapped '
        'then each has a counterpart of the same name', () {
      for (final category in generated.FeedbackCategory.values) {
        for (final status in generated.FeedbackStatus.values) {
          final mapped = lotseMyFeedbackFrom(
            row.copyWith(category: category, status: status),
          );
          expect(mapped.category.name, category.name);
          expect(mapped.status.name, status.name);
        }
      }
    });

    test('when a thread is read '
        'then the replies keep their order and their side', () async {
      late int askedId;
      final conversations = _server(
        get: (installId, feedbackId) async {
          askedId = feedbackId;
          return generated.MyFeedbackThread(
            feedback: row,
            messages: [
              generated.MyFeedbackMessage(
                id: 1,
                author: generated.FeedbackMessageAuthor.team,
                body: 'Which phone?',
                createdAt: _repliedAt,
              ),
              generated.MyFeedbackMessage(
                id: 2,
                author: generated.FeedbackMessageAuthor.user,
                body: 'A OnePlus',
                createdAt: _repliedAt,
              ),
            ],
          );
        },
      );

      final thread = await conversations.thread(7);

      expect(askedId, 7);
      expect(thread!.feedback.id, 7);
      expect(thread.replies.map((reply) => reply.id), [1, 2]);
      expect(thread.replies.map((reply) => reply.fromTeam), [true, false]);
      expect(thread.replies.first.body, 'Which phone?');
      expect(thread.replies.first.createdAt, _repliedAt);
    });

    test('when a read fails then null instead of an error', () async {
      final conversations = _server(
        list: (_) => throw StateError('offline'),
        get: (_, _) =>
            throw generated.LotseNotFoundException(message: 'Feedback'),
      );

      expect(await conversations.list(), isNull);
      expect(await conversations.thread(7), isNull);
    });

    test('when a reply is sent then it goes out for this install', () async {
      late (String, int, String) sent;
      final conversations = _server(
        reply: (installId, feedbackId, body) async {
          sent = (installId, feedbackId, body);
          return 3;
        },
      );

      expect(await conversations.reply(7, 'Thanks'), LotseReplyResult.sent);
      expect(sent, ('install-1', 7, 'Thanks'));
    });

    test('when the reply quota is used up then limitReached', () async {
      final conversations = _server(
        reply: (_, _, _) => throw generated.LotseQuotaExceededException(
          resource: 'replies per device',
          limit: 20,
          message: 'quota',
        ),
      );

      expect(
        await conversations.reply(7, 'Thanks'),
        LotseReplyResult.limitReached,
      );
    });

    test('when a reply fails in any other way then failed', () async {
      final conversations = _server(
        reply: (_, _, _) => throw StateError('offline'),
      );

      expect(await conversations.reply(7, 'Thanks'), LotseReplyResult.failed);
    });

    test('when marking read then true, and false if the call fails', () async {
      final marked = <(String, int)>[];
      final working = _server(
        markRead: (installId, feedbackId) async =>
            marked.add((installId, feedbackId)),
      );
      final broken = _server(markRead: (_, _) => throw StateError('offline'));

      expect(await working.markRead(7), isTrue);
      expect(marked, [('install-1', 7)]);
      expect(await broken.markRead(7), isFalse);
    });
  });

  group('Given the unread counter', () {
    test('when nothing has been asked yet then zero', () {
      expect(LotseUnreadFeedback(_FakeConversations()).count.value, 0);
    });

    test('when it refreshes '
        'then it is the sum of the unread replies of all messages', () async {
      final conversations = _FakeConversations()
        ..listAnswer = [
          _feedback(1, unread: 2),
          _feedback(2),
          _feedback(3, unread: 1),
        ];
      final unread = LotseUnreadFeedback(conversations);

      await unread.refresh();

      expect(unread.count.value, 3);
    });

    test('when a refresh fails then the last number stays', () async {
      final conversations = _FakeConversations()
        ..listAnswer = [_feedback(1, unread: 2)];
      final unread = LotseUnreadFeedback(conversations);
      await unread.refresh();

      conversations.listAnswer = null;
      await unread.refresh();

      expect(unread.count.value, 2);
    });

    test('when everything was read then listeners see zero again', () async {
      final conversations = _FakeConversations()
        ..listAnswer = [_feedback(1, unread: 2)];
      final unread = LotseUnreadFeedback(conversations);
      final seen = <int>[];
      unread.count.addListener(() => seen.add(unread.count.value));

      await unread.refresh();
      conversations.listAnswer = [_feedback(1)];
      await unread.refresh();

      expect(seen, [2, 0]);
    });
  });

  group('Given the list of my feedback', () {
    test('when it loads then the items are there', () async {
      final conversations = _FakeConversations()
        ..listAnswer = [_feedback(1), _feedback(2)];
      final controller = LotseMyFeedbackListController(conversations);
      addTearDown(controller.dispose);
      expect(controller.status, LotseLoadStatus.loading);

      await controller.load();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.items.map((feedback) => feedback.id), [1, 2]);
    });

    test('when the first load fails then failed, and retry recovers', () async {
      final conversations = _FakeConversations()..listAnswer = null;
      final controller = LotseMyFeedbackListController(conversations);
      addTearDown(controller.dispose);

      await controller.load();
      expect(controller.status, LotseLoadStatus.failed);

      conversations.listAnswer = [_feedback(1)];
      final retry = controller.retry();
      expect(controller.status, LotseLoadStatus.loading);
      await retry;

      expect(controller.status, LotseLoadStatus.loaded);
    });

    test('when a reload fails then the loaded list stays', () async {
      final conversations = _FakeConversations()..listAnswer = [_feedback(1)];
      final controller = LotseMyFeedbackListController(conversations);
      addTearDown(controller.dispose);
      await controller.load();

      conversations.listAnswer = null;
      await controller.load();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.items.single.id, 1);
    });

    test('when it is disposed during a load then nothing happens', () async {
      final controller = LotseMyFeedbackListController(_FakeConversations());
      final load = controller.load();
      controller.dispose();

      await expectLater(load, completes);
    });
  });

  group('Given an open conversation', () {
    test('when it starts then the thread is loaded', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7, replies: 2);
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      expect(controller.status, LotseLoadStatus.loading);

      await controller.refresh();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.thread!.replies, hasLength(2));
    });

    // testWidgets for its fake clock; no widget is involved.
    testWidgets('when it is open then it polls, and stops once it is closed', (
      tester,
    ) async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        pollInterval: const Duration(seconds: 5),
      )..start();
      await tester.pump();
      expect(conversations.threadCalls, 1);

      // A second start must not start a second timer.
      controller.start();
      await tester.pump(const Duration(seconds: 5));
      await tester.pump(const Duration(seconds: 5));
      expect(conversations.threadCalls, 3);

      controller.dispose();
      await tester.pump(const Duration(minutes: 1));
      expect(conversations.threadCalls, 3);
    });

    testWidgets('when it is paused then nothing is polled or marked read, '
        'and resume catches up', (tester) async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        pollInterval: const Duration(seconds: 5),
      )..start();
      await tester.pump();

      // A poll is on its way when the app goes to the background; its answer
      // brings a reply nobody sees.
      conversations
        ..threadAnswer = _thread(7, unread: 1, replies: 1)
        ..threadGate = Completer();
      await tester.pump(const Duration(seconds: 5));
      controller.pause();
      conversations.threadGate!.complete();
      conversations.threadGate = null;
      await tester.pump(const Duration(minutes: 1));
      expect(conversations.threadCalls, 2);
      expect(conversations.markedRead, isEmpty);

      controller.resume();
      await tester.pump();
      expect(conversations.threadCalls, 3);
      expect(conversations.markedRead, [7]);
      await tester.pump(const Duration(seconds: 5));
      expect(conversations.threadCalls, 4);

      controller.dispose();
    });

    testWidgets('when a poll brings a new reply then the thread shows it', (
      tester,
    ) async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(conversations, 7)
        ..start();
      await tester.pump();
      expect(controller.thread!.replies, isEmpty);

      conversations.threadAnswer = _thread(7, replies: 1);
      await tester.pump(lotseThreadPollInterval);

      expect(controller.thread!.replies, hasLength(1));
      controller.dispose();
    });

    test('when the thread has unread replies '
        'then it is marked read and onRead runs', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7, unread: 2, replies: 2);
      var read = 0;
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        onRead: () => read++,
      );
      addTearDown(controller.dispose);

      await controller.refresh();

      expect(conversations.markedRead, [7]);
      expect(read, 1);
    });

    test('when nothing is unread then nothing is marked', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7, replies: 2);
      var read = 0;
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        onRead: () => read++,
      );
      addTearDown(controller.dispose);

      await controller.refresh();

      expect(conversations.markedRead, isEmpty);
      expect(read, 0);
    });

    test('when marking read fails then onRead does not run', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7, unread: 1, replies: 1)
        ..markReadAnswer = false;
      var read = 0;
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        onRead: () => read++,
      );
      addTearDown(controller.dispose);

      await controller.refresh();

      expect(read, 0);
    });

    test('when the first load fails then failed, and retry recovers', () async {
      final conversations = _FakeConversations();
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);

      await controller.refresh();
      expect(controller.status, LotseLoadStatus.failed);
      expect(controller.canReply('Hello'), isFalse);

      conversations.threadAnswer = _thread(7);
      await controller.retry();

      expect(controller.status, LotseLoadStatus.loaded);
    });

    test('when a poll fails then the loaded thread stays', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7, replies: 1);
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      await controller.refresh();

      conversations.threadAnswer = null;
      await controller.refresh();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.thread!.replies, hasLength(1));
    });

    test('when the reply is empty or too long then it cannot go out', () async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      await controller.refresh();

      expect(controller.canReply('   '), isFalse);
      expect(
        controller.canReply('a' * (maxFeedbackMessageLength + 1)),
        isFalse,
      );
      expect(controller.canReply('a' * maxFeedbackMessageLength), isTrue);
      expect(await controller.reply('   '), isFalse);
      expect(conversations.replies, isEmpty);
    });

    test('when a reply is sent '
        'then it goes out trimmed and the thread is loaded again', () async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      await controller.refresh();

      conversations.threadAnswer = _thread(7, replies: 1);
      final sent = await controller.reply('  Thanks  ');

      expect(sent, isTrue);
      expect(conversations.replies, [(7, 'Thanks')]);
      expect(controller.thread!.replies, hasLength(1));
      expect(controller.replyFailure, isNull);
      expect(controller.isSending, isFalse);
    });

    test('when a reply is sent while a poll is running '
        'then the thread is loaded once more after it', () async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      await controller.refresh();

      // The poll has read the old thread and is still on its way.
      final gate = conversations.threadGate = Completer<void>();
      final poll = controller.refresh();
      await Future<void>.delayed(Duration.zero);
      conversations
        ..threadGate = null
        ..threadAnswer = _thread(7, replies: 1);
      final reply = controller.reply('Thanks');
      await Future<void>.delayed(Duration.zero);
      gate.complete();
      await Future.wait([poll, reply]);

      expect(controller.thread!.replies, hasLength(1));
    });

    test('when a reply fails then the reason is kept for the page', () async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7)
        ..replyAnswer = LotseReplyResult.limitReached;
      final controller = LotseFeedbackThreadController(conversations, 7);
      addTearDown(controller.dispose);
      await controller.refresh();

      expect(await controller.reply('Thanks'), isFalse);
      expect(controller.replyFailure, LotseReplyResult.limitReached);

      conversations.replyAnswer = LotseReplyResult.sent;
      expect(await controller.reply('Thanks'), isTrue);
      expect(controller.replyFailure, isNull);
    });
  });

  group('Given a stream that is still opening', () {
    test('when it is cancelled before its first event then it is cancelled '
        'when that event arrives, and nothing is delivered', () async {
      final server = StreamController<int>();
      final events = <int>[];
      final subscription = lotseCancelAfterFirst(
        server.stream,
      ).listen(events.add);

      await subscription.cancel();
      expect(server.hasListener, isTrue, reason: 'still opening');
      server.add(1);
      await pumpEventQueue();

      expect(server.hasListener, isFalse);
      expect(events, isEmpty);
    });

    test(
      'when it delivered already then a cancel is passed on at once',
      () async {
        final server = StreamController<int>();
        final events = <int>[];
        final subscription = lotseCancelAfterFirst(
          server.stream,
        ).listen(events.add);
        server.add(1);
        await pumpEventQueue();

        await subscription.cancel();

        expect(events, [1]);
        expect(server.hasListener, isFalse);
      },
    );

    test('when it fails before its first event then the error arrives and '
        'the stream ends', () async {
      final server = StreamController<int>();
      final errors = <Object>[];
      var done = false;
      lotseCancelAfterFirst(
        server.stream,
      ).listen((_) {}, onError: errors.add, onDone: () => done = true);

      server.addError(const LotseLiveUnavailable());
      await server.close();
      await pumpEventQueue();

      expect(errors.single, isA<LotseLiveUnavailable>());
      expect(done, isTrue);
    });
  });

  // testWidgets for its fake clock; no widget is involved.
  group('Given an open conversation with a live stream', () {
    testWidgets('when the stream delivers then every change loads the thread '
        'at once and nothing is polled any more', (tester) async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7)
        ..liveAvailable = true;
      final controller = LotseFeedbackThreadController(conversations, 7)
        ..start();
      await tester.pump();
      expect(conversations.threadCalls, 1);
      expect(controller.isLive, isFalse);

      // The first event says the stream listens; whatever happened between
      // the first load and the subscription is loaded with it.
      final live = conversations.opened.single..add(null);
      await tester.pump();
      expect(controller.isLive, isTrue);
      expect(conversations.threadCalls, 2);

      await tester.pump(lotseThreadPollInterval * 3);
      expect(conversations.threadCalls, 2);

      conversations.threadAnswer = _thread(7, unread: 1, replies: 1);
      live.add(null);
      await tester.pump();
      expect(conversations.threadCalls, 3);
      expect(controller.thread!.replies, hasLength(1));
      expect(conversations.markedRead, [7]);

      controller.dispose();
      expect(live.hasListener, isFalse);
    });

    testWidgets('when the stream fails then it polls, and once a new stream '
        'delivers it stops polling again', (tester) async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7)
        ..liveAvailable = true;
      final controller = LotseFeedbackThreadController(conversations, 7)
        ..start();
      await tester.pump();
      conversations.opened.single.add(null);
      await tester.pump();
      expect(conversations.threadCalls, 2);

      conversations.opened.single.addError(StateError('connection lost'));
      await tester.pump();
      expect(controller.isLive, isFalse);

      // A delivering stream had reset the delays: the first one applies.
      await tester.pump(lotseLiveRetryDelays.first);
      expect(conversations.opened, hasLength(2));
      await tester.pump(lotseThreadPollInterval - lotseLiveRetryDelays.first);
      expect(conversations.threadCalls, 3, reason: 'polled meanwhile');

      conversations.opened.last.add(null);
      await tester.pump();
      expect(controller.isLive, isTrue);
      expect(conversations.threadCalls, 4);
      await tester.pump(lotseThreadPollInterval * 3);
      expect(conversations.threadCalls, 4);

      controller.dispose();
    });

    testWidgets('when the stream cannot be opened then the waits grow up to '
        'the last one, and the page keeps polling', (tester) async {
      final conversations = _FakeConversations()..threadAnswer = _thread(7);
      final controller = LotseFeedbackThreadController(
        conversations,
        7,
        liveRetryDelays: const [Duration(seconds: 1), Duration(seconds: 3)],
      )..start();
      await tester.pump();
      expect(conversations.liveAsked, 1);

      await tester.pump(const Duration(seconds: 1));
      expect(conversations.liveAsked, 2);
      await tester.pump(const Duration(seconds: 2));
      expect(conversations.liveAsked, 2);
      await tester.pump(const Duration(seconds: 1));
      expect(conversations.liveAsked, 3);
      await tester.pump(const Duration(seconds: 3));
      expect(conversations.liveAsked, 4);
      expect(conversations.threadCalls, 2, reason: 'one load, one poll');
      expect(controller.isLive, isFalse);

      controller.dispose();
      await tester.pump(const Duration(minutes: 5));
      expect(conversations.liveAsked, 4);
    });

    testWidgets('when the server ends the stream after its lifetime then a '
        'new one is opened after the shortest wait', (tester) async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7)
        ..liveAvailable = true;
      final controller = LotseFeedbackThreadController(conversations, 7)
        ..start();
      await tester.pump();
      conversations.opened.single.add(null);
      await tester.pump();

      await conversations.opened.single.close();
      await tester.pump(lotseLiveRetryDelays.first);

      expect(conversations.opened, hasLength(2));
      conversations.opened.last.add(null);
      await tester.pump();
      expect(controller.isLive, isTrue);

      controller.dispose();
    });

    testWidgets('when it is paused then the stream is closed and nothing is '
        'marked read, and resume opens a new one', (tester) async {
      final conversations = _FakeConversations()
        ..threadAnswer = _thread(7)
        ..liveAvailable = true;
      final controller = LotseFeedbackThreadController(conversations, 7)
        ..start();
      await tester.pump();
      conversations.opened.single.add(null);
      await tester.pump();

      controller.pause();
      expect(conversations.opened.single.hasListener, isFalse);
      expect(controller.isLive, isFalse);
      await tester.pump(const Duration(minutes: 5));
      expect(conversations.opened, hasLength(1));

      conversations.threadAnswer = _thread(7, unread: 1, replies: 1);
      controller.resume();
      await tester.pump();
      expect(conversations.opened, hasLength(2));
      expect(conversations.markedRead, [7]);

      controller.dispose();
    });
  });
}
