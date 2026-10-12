import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_my_feedback.dart';
import 'package:lotse/src/lotse_my_feedback_page.dart';
import 'package:lotse/src/lotse_support_chat.dart';
import 'package:lotse/src/lotse_support_chat_page.dart';

final _sentAt = DateTime.utc(2026, 9, 1, 10);

/// The server in memory: one project switch, at most one question of this
/// device, and its replies.
class _FakeServer implements LotseSupportChat, LotseConversations {
  _FakeServer({this.enabled = true});

  bool enabled;
  bool failing = false;
  LotseSupportChatResult askAnswer = LotseSupportChatResult.started;
  String? question;
  int unread = 0;
  final replies = <LotseFeedbackReply>[];
  final markedRead = <int>[];

  static const feedbackId = 7;

  void startWith(String text, {String? teamReply}) {
    question = text;
    if (teamReply != null) {
      replies.add(
        LotseFeedbackReply(
          id: 1,
          fromTeam: true,
          body: teamReply,
          createdAt: _sentAt,
        ),
      );
      unread = 1;
    }
  }

  @override
  Future<LotseSupportChatState?> state() async => failing
      ? null
      : LotseSupportChatState(
          enabled: enabled,
          feedbackId: question == null ? null : feedbackId,
        );

  @override
  Future<(LotseSupportChatResult, int?)> ask(String text) async {
    if (askAnswer != LotseSupportChatResult.started) return (askAnswer, null);
    question = text;
    return (askAnswer, feedbackId);
  }

  LotseMyFeedback get _feedback => LotseMyFeedback(
    id: feedbackId,
    category: LotseFeedbackCategory.question,
    message: question!,
    status: LotseMyFeedbackStatus.open,
    createdAt: _sentAt,
    unreadCount: unread,
  );

  @override
  Future<List<LotseMyFeedback>?> list() async =>
      question == null ? [] : [_feedback];

  @override
  Future<LotseFeedbackThread?> thread(int id) async =>
      LotseFeedbackThread(feedback: _feedback, replies: [...replies]);

  @override
  Future<LotseReplyResult> reply(int id, String body) async {
    replies.add(
      LotseFeedbackReply(
        id: 100 + replies.length,
        fromTeam: false,
        body: body,
        createdAt: _sentAt,
      ),
    );
    return LotseReplyResult.sent;
  }

  @override
  Future<bool> markRead(int id) async {
    markedRead.add(id);
    unread = 0;
    return true;
  }

  /// What the server says on the live stream of the conversation.
  final live = StreamController<void>.broadcast();

  @override
  Stream<void> changes(int id) => live.stream;
}

Widget _app(
  _FakeServer server, {
  LotseFeedbackTexts? texts,
  Locale? locale,
  VoidCallback? onRead,
}) => MaterialApp(
  home: Builder(
    builder: (context) => Scaffold(
      body: TextButton(
        onPressed: () => showLotseSupportChat(
          context,
          chat: server,
          conversations: server,
          texts:
              texts ??
              (locale == null ? null : LotseFeedbackTexts.forLocale(locale)),
          onRead: onRead,
        ),
        child: const Text('open'),
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

/// Leaves the chat, which ends the polling of an open conversation.
Future<void> _back(WidgetTester tester) async {
  await tester.pageBack();
  await tester.pumpAndSettle();
}

void main() {
  const texts = LotseFeedbackTexts.english;

  group('Given a project with the support chat switched on', () {
    testWidgets('when the chat is opened without a running conversation '
        'then the intro and the question field are shown', (tester) async {
      await tester.pumpWidget(_app(_FakeServer()));
      await _open(tester);

      expect(find.text(texts.supportChatTitle), findsOneWidget);
      expect(find.text(texts.supportChatIntro), findsOneWidget);
      expect(find.text(texts.supportChatHint), findsOneWidget);
      expect(find.text(texts.supportChatDisabled), findsNothing);
      expect(
        tester
            .widget<IconButton>(find.widgetWithIcon(IconButton, Icons.send))
            .onPressed,
        isNull,
      );
    });

    testWidgets('when the first question is sent '
        'then the conversation opens in place and takes replies', (
      tester,
    ) async {
      final server = _FakeServer();
      await tester.pumpWidget(_app(server));
      await _open(tester);

      await tester.enterText(find.byType(TextField), 'How do I export?');
      await tester.pump();
      await tester.tap(find.byTooltip(texts.supportChatSend));
      await tester.pumpAndSettle();

      expect(server.question, 'How do I export?');
      expect(find.text('How do I export?'), findsOneWidget);
      expect(find.text(texts.supportChatTitle), findsOneWidget);
      expect(find.text(texts.supportChatIntro), findsNothing);
      expect(find.text(texts.replyHint), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'As a CSV file.');
      await tester.pump();
      await tester.tap(find.byTooltip(texts.replySend));
      await tester.pumpAndSettle();

      expect(server.replies.single.body, 'As a CSV file.');
      expect(find.text('As a CSV file.'), findsOneWidget);
      await _back(tester);
    });

    testWidgets('when the team answers while the chat is open then the answer '
        'shows as soon as the live stream says so, before any poll', (
      tester,
    ) async {
      final server = _FakeServer()..startWith('How do I export?');
      await tester.pumpWidget(_app(server));
      await _open(tester);
      // The stream listens: its first event.
      server.live.add(null);
      await tester.pump();

      server.startWith('How do I export?', teamReply: 'Under Settings.');
      server.live.add(null);
      await tester.pump();
      await tester.pump();

      expect(find.text('Under Settings.'), findsOneWidget);
      expect(server.markedRead, [_FakeServer.feedbackId]);
      await _back(tester);
      expect(server.live.hasListener, isFalse);
    });

    testWidgets('when a conversation is running '
        'then it is opened, marked read and onRead runs', (tester) async {
      final server = _FakeServer()
        ..startWith('How do I export?', teamReply: 'Under Settings.');
      var read = 0;
      await tester.pumpWidget(_app(server, onRead: () => read++));
      await _open(tester);

      expect(find.text('How do I export?'), findsOneWidget);
      expect(find.text('Under Settings.'), findsOneWidget);
      expect(find.text(texts.supportChatIntro), findsNothing);
      expect(server.markedRead, [_FakeServer.feedbackId]);
      expect(read, 1);
      await _back(tester);
    });

    testWidgets('when a push for the conversation on screen is tapped '
        'then no second copy is put on top', (tester) async {
      final server = _FakeServer()..startWith('How do I export?');
      await tester.pumpWidget(_app(server));
      await _open(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      await pushLotseFeedbackThread(
        navigator,
        conversations: server,
        feedbackId: _FakeServer.feedbackId,
        texts: texts,
      );
      await tester.pumpAndSettle();
      expect(find.byType(LotseFeedbackThreadPage), findsOneWidget);

      // Once the chat is closed the same push opens the conversation again.
      await _back(tester);
      final pushed = pushLotseFeedbackThread(
        navigator,
        conversations: server,
        feedbackId: _FakeServer.feedbackId,
        texts: texts,
      );
      await tester.pumpAndSettle();
      expect(find.byType(LotseFeedbackThreadPage), findsOneWidget);
      await _back(tester);
      await pushed;
    });

    testWidgets('when the question hits a quota or fails '
        'then the page says so and keeps the text', (tester) async {
      final server = _FakeServer()
        ..askAnswer = LotseSupportChatResult.limitReached;
      await tester.pumpWidget(_app(server));
      await _open(tester);

      await tester.enterText(find.byType(TextField), 'Hello?');
      await tester.pump();
      await tester.tap(find.byTooltip(texts.supportChatSend));
      await tester.pumpAndSettle();
      expect(find.text(texts.supportChatLimitReached), findsOneWidget);
      expect(find.text('Hello?'), findsOneWidget);

      server.askAnswer = LotseSupportChatResult.failed;
      await tester.tap(find.byTooltip(texts.supportChatSend));
      await tester.pumpAndSettle();
      expect(find.text(texts.supportChatFailed), findsOneWidget);
      expect(find.text('Hello?'), findsOneWidget);
    });

    testWidgets('when loading fails then retry loads the chat', (tester) async {
      final server = _FakeServer()..failing = true;
      await tester.pumpWidget(_app(server));
      await _open(tester);
      expect(find.text(texts.loadFailed), findsOneWidget);

      server.failing = false;
      await tester.tap(find.text(texts.retry));
      await tester.pumpAndSettle();
      expect(find.text(texts.supportChatIntro), findsOneWidget);
    });
  });

  group('Given a project with the support chat switched off', () {
    testWidgets('when the chat is opened '
        'then a notice is shown instead of the question field', (tester) async {
      await tester.pumpWidget(_app(_FakeServer(enabled: false)));
      await _open(tester);

      expect(find.text(texts.supportChatDisabled), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(find.text(texts.supportChatIntro), findsNothing);
    });

    testWidgets('when a conversation was started before '
        'then it is still shown and can be answered', (tester) async {
      final server = _FakeServer(enabled: false)
        ..startWith('How do I export?', teamReply: 'Under Settings.');
      await tester.pumpWidget(_app(server));
      await _open(tester);

      expect(find.text('Under Settings.'), findsOneWidget);
      expect(find.text(texts.supportChatDisabled), findsNothing);
      await tester.enterText(find.byType(TextField), 'Thanks!');
      await tester.pump();
      await tester.tap(find.byTooltip(texts.replySend));
      await tester.pumpAndSettle();
      expect(server.replies.last.body, 'Thanks!');
      await _back(tester);
    });

    testWidgets('when it is switched off while the page is open '
        'then the refused question turns the field into the notice', (
      tester,
    ) async {
      final server = _FakeServer()..askAnswer = LotseSupportChatResult.disabled;
      await tester.pumpWidget(_app(server));
      await _open(tester);

      await tester.enterText(find.byType(TextField), 'Hello?');
      await tester.pump();
      await tester.tap(find.byTooltip(texts.supportChatSend));
      await tester.pumpAndSettle();

      expect(find.text(texts.supportChatDisabled), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
    });
  });

  group('Given the texts of the support chat', () {
    testWidgets('when the texts are German then the notice is German', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_FakeServer(enabled: false), locale: const Locale('de')),
      );
      await _open(tester);

      expect(
        find.text(LotseFeedbackTexts.german.supportChatDisabled),
        findsOneWidget,
      );
    });

    testWidgets('when an app passes its own texts then they are shown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _FakeServer(),
          texts: texts.copyWith(
            supportChatTitle: 'Help',
            supportChatIntro: 'Ask away.',
          ),
        ),
      );
      await _open(tester);

      expect(find.text('Help'), findsOneWidget);
      expect(find.text('Ask away.'), findsOneWidget);
    });

    test('when an app overrides the texts of the support chat '
        'then each one lands in its own field', () {
      final custom = texts.copyWith(
        categoryQuestion: 'a',
        supportChatTitle: 'b',
        supportChatIntro: 'c',
        supportChatHint: 'd',
        supportChatSend: 'e',
        supportChatDisabled: 'f',
        supportChatFailed: 'g',
        supportChatLimitReached: 'h',
      );

      expect(
        [
          custom.categoryQuestion,
          custom.supportChatTitle,
          custom.supportChatIntro,
          custom.supportChatHint,
          custom.supportChatSend,
          custom.supportChatDisabled,
          custom.supportChatFailed,
          custom.supportChatLimitReached,
        ],
        ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
      );
      expect(custom.replyHint, texts.replyHint);
    });

    test('when the support chat is shown in German '
        'then no sentence is left in English', () {
      const german = LotseFeedbackTexts.german;

      expect(german.categoryQuestion, isNot(texts.categoryQuestion));
      expect(german.supportChatIntro, isNot(texts.supportChatIntro));
      expect(german.supportChatHint, isNot(texts.supportChatHint));
      expect(german.supportChatSend, isNot(texts.supportChatSend));
      expect(german.supportChatDisabled, isNot(texts.supportChatDisabled));
      expect(german.supportChatFailed, isNot(texts.supportChatFailed));
      expect(
        german.supportChatLimitReached,
        isNot(texts.supportChatLimitReached),
      );
    });
  });

  group('Given the unread counter', () {
    test('when the team answered in the support chat '
        'then the reply counts, and reading it clears the count', () async {
      final server = _FakeServer()
        ..startWith('How do I export?', teamReply: 'Under Settings.');
      final unread = LotseUnreadFeedback(server);

      await unread.refresh();
      expect(unread.count.value, 1);

      await server.markRead(_FakeServer.feedbackId);
      await unread.refresh();
      expect(unread.count.value, 0);
    });
  });
}
