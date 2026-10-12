import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_my_feedback.dart';
import 'package:lotse/src/lotse_my_feedback_page.dart';

const _seed = Color(0xFF00695C);
final _sentAt = DateTime.utc(2026, 9, 1, 10);

/// Two conversations in memory. Reading and replying change them like the
/// server would.
class _FakeConversations implements LotseConversations {
  bool failing = false;
  LotseReplyResult replyAnswer = LotseReplyResult.sent;
  int threadCalls = 0;
  final markedRead = <int>[];

  final _unread = {1: 2, 2: 0};
  final _replies = <int, List<LotseFeedbackReply>>{
    1: [
      LotseFeedbackReply(
        id: 1,
        fromTeam: true,
        body: 'Which phone do you use?',
        createdAt: _sentAt,
      ),
    ],
    2: [],
  };

  LotseMyFeedback _feedback(int id) => LotseMyFeedback(
    id: id,
    category: id == 1 ? LotseFeedbackCategory.bug : LotseFeedbackCategory.idea,
    message: id == 1 ? 'The cart is empty' : 'Dark mode please',
    status: id == 1
        ? LotseMyFeedbackStatus.inProgress
        : LotseMyFeedbackStatus.open,
    createdAt: _sentAt,
    unreadCount: _unread[id]!,
  );

  @override
  Future<List<LotseMyFeedback>?> list() async =>
      failing ? null : [_feedback(1), _feedback(2)];

  @override
  Future<LotseFeedbackThread?> thread(int feedbackId) async {
    threadCalls++;
    if (failing) return null;
    return LotseFeedbackThread(
      feedback: _feedback(feedbackId),
      replies: [..._replies[feedbackId]!],
    );
  }

  @override
  Future<LotseReplyResult> reply(int feedbackId, String body) async {
    if (replyAnswer == LotseReplyResult.sent) {
      _replies[feedbackId]!.add(
        LotseFeedbackReply(
          id: 100 + _replies[feedbackId]!.length,
          fromTeam: false,
          body: body,
          createdAt: _sentAt,
        ),
      );
    }
    return replyAnswer;
  }

  @override
  Future<bool> markRead(int feedbackId) async {
    markedRead.add(feedbackId);
    _unread[feedbackId] = 0;
    return true;
  }

  @override
  Stream<void> changes(int feedbackId) =>
      Stream.error(const LotseLiveUnavailable());
}

Widget _app(
  _FakeConversations conversations, {
  LotseFeedbackTexts? texts,
  VoidCallback? onRead,
}) => MaterialApp(
  theme: ThemeData(colorSchemeSeed: _seed),
  home: Builder(
    builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => showLotseMyFeedback(
          context,
          conversations: conversations,
          texts: texts,
          onRead: onRead,
        ),
        child: const Text('open'),
      ),
    ),
  ),
);

Future<void> _openList(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

/// Leaves the open conversation, which ends its polling.
Future<void> _back(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

void main() {
  group('Given the list of my feedback', () {
    testWidgets('when it opens '
        'then each message shows category, status and unread marker', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeConversations()));
      await _openList(tester);

      expect(find.text('My feedback'), findsOneWidget);
      expect(find.text('The cart is empty'), findsOneWidget);
      expect(find.textContaining('Bug · In progress'), findsOneWidget);
      expect(find.textContaining('Idea · Received'), findsOneWidget);
      // Only the first conversation has unread replies.
      expect(find.byType(Badge), findsOneWidget);
      expect(
        find.descendant(of: find.byType(Badge), matching: find.text('2')),
        findsOneWidget,
      );
    });

    testWidgets('when the device locale is not German and texts are given '
        'then the given texts are shown', (tester) async {
      await tester.pumpWidget(
        _app(_FakeConversations(), texts: LotseFeedbackTexts.german),
      );
      await _openList(tester);

      expect(find.text('Mein Feedback'), findsOneWidget);
      expect(find.textContaining('Fehler · In Arbeit'), findsOneWidget);
    });

    testWidgets('when there is no feedback yet then it says so', (
      tester,
    ) async {
      final conversations = _EmptyConversations();
      await tester.pumpWidget(
        MaterialApp(
          home: LotseMyFeedbackPage(
            conversations: conversations,
            texts: LotseFeedbackTexts.english,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(LotseFeedbackTexts.english.myFeedbackEmpty), findsOne);
    });

    testWidgets('when loading fails then retry loads it', (tester) async {
      final conversations = _FakeConversations()..failing = true;
      await tester.pumpWidget(_app(conversations));
      await _openList(tester);
      expect(find.text(LotseFeedbackTexts.english.loadFailed), findsOneWidget);

      conversations.failing = false;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.text('The cart is empty'), findsOneWidget);
    });

    testWidgets('when a conversation with unread replies was opened '
        'then it is marked read and the marker is gone on return', (
      tester,
    ) async {
      final conversations = _FakeConversations();
      var read = 0;
      await tester.pumpWidget(_app(conversations, onRead: () => read++));
      await _openList(tester);

      await tester.tap(find.text('The cart is empty'));
      await tester.pumpAndSettle();
      expect(find.text('Conversation'), findsOneWidget);
      expect(find.text('Which phone do you use?'), findsOneWidget);
      expect(conversations.markedRead, [1]);
      expect(read, 1);

      await _back(tester);
      expect(find.text('My feedback'), findsOneWidget);
      expect(find.byType(Badge), findsNothing);
    });
  });

  group('Given an open conversation', () {
    Future<_FakeConversations> openThread(
      WidgetTester tester, {
      _FakeConversations? conversations,
    }) async {
      final fake = conversations ?? _FakeConversations();
      await tester.pumpWidget(_app(fake));
      await _openList(tester);
      await tester.tap(find.text('The cart is empty'));
      await tester.pumpAndSettle();
      return fake;
    }

    testWidgets('when it opens then the feedback message leads the thread', (
      tester,
    ) async {
      await openThread(tester);

      final message = tester.getCenter(find.text('The cart is empty'));
      final reply = tester.getCenter(find.text('Which phone do you use?'));
      expect(message.dy, lessThan(reply.dy));
      expect(find.text('You'), findsOneWidget);
      expect(find.text('Team'), findsOneWidget);
      await _back(tester);
    });

    testWidgets('when the field is empty then send is off', (tester) async {
      await openThread(tester);

      expect(
        tester
            .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.send))
            .onPressed,
        isNull,
      );
      await _back(tester);
    });

    testWidgets('when the user replies '
        'then the reply is in the thread and the field is empty', (
      tester,
    ) async {
      await openThread(tester);

      await tester.enterText(find.byType(TextField), 'A OnePlus 7 Pro');
      await tester.pump();
      await tester.tap(find.byTooltip('Send reply'));
      await tester.pumpAndSettle();

      expect(find.text('A OnePlus 7 Pro'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
      await _back(tester);
    });

    testWidgets('when the reply fails then the text stays with the reason', (
      tester,
    ) async {
      final conversations = _FakeConversations()
        ..replyAnswer = LotseReplyResult.limitReached;
      await openThread(tester, conversations: conversations);

      await tester.enterText(find.byType(TextField), 'A OnePlus 7 Pro');
      await tester.pump();
      await tester.tap(find.byTooltip('Send reply'));
      await tester.pumpAndSettle();

      expect(
        find.text(LotseFeedbackTexts.english.replyLimitReached),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'A OnePlus 7 Pro',
      );
      await _back(tester);
    });

    testWidgets('when it stays open then it polls, and not after it closed', (
      tester,
    ) async {
      final conversations = await openThread(tester);
      final before = conversations.threadCalls;

      await tester.pump(lotseThreadPollInterval);
      await tester.pump(lotseThreadPollInterval);
      expect(conversations.threadCalls, before + 2);

      await _back(tester);
      final after = conversations.threadCalls;
      await tester.pump(lotseThreadPollInterval * 3);
      expect(conversations.threadCalls, after);
    });

    testWidgets('when the app is in the background then it does not poll, '
        'and again once it is back', (tester) async {
      final conversations = await openThread(tester);
      final before = conversations.threadCalls;

      // The framework only accepts the states in the order of the platform.
      const away = [
        AppLifecycleState.inactive,
        AppLifecycleState.hidden,
        AppLifecycleState.paused,
      ];
      away.forEach(tester.binding.handleAppLifecycleStateChanged);
      await tester.pump(lotseThreadPollInterval * 3);
      expect(conversations.threadCalls, before);

      [
        ...away.reversed.skip(1),
        AppLifecycleState.resumed,
      ].forEach(tester.binding.handleAppLifecycleStateChanged);
      await tester.pump();
      expect(conversations.threadCalls, before + 1);
      await tester.pump(lotseThreadPollInterval);
      expect(conversations.threadCalls, before + 2);
      await _back(tester);
    });

    testWidgets('when the same conversation is pushed again while it is open '
        'then there is still one page', (tester) async {
      final conversations = await openThread(tester);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      await pushLotseFeedbackThread(
        navigator,
        conversations: conversations,
        feedbackId: 1,
        texts: LotseFeedbackTexts.english,
      );
      await tester.pumpAndSettle();

      await _back(tester);
      expect(find.text('My feedback'), findsOneWidget);
    });
  });
}

class _EmptyConversations extends _FakeConversations {
  @override
  Future<List<LotseMyFeedback>?> list() async => const [];
}
