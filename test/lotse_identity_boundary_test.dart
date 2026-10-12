import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_feedback.dart';
import 'package:lotse/src/lotse_feedback_texts.dart';
import 'package:lotse/src/lotse_identity_boundary.dart';
import 'package:lotse/src/lotse_my_feedback.dart';
import 'package:lotse/src/lotse_my_feedback_page.dart';

class _Conversations implements LotseConversations {
  int threadCalls = 0;

  static final _feedback = LotseMyFeedback(
    id: 7,
    category: LotseFeedbackCategory.question,
    message: 'Private question of A',
    status: LotseMyFeedbackStatus.open,
    createdAt: DateTime.utc(2026),
    unreadCount: 0,
  );

  @override
  Future<List<LotseMyFeedback>?> list() async => [_feedback];

  @override
  Future<LotseFeedbackThread?> thread(int feedbackId) async {
    threadCalls++;
    return LotseFeedbackThread(feedback: _feedback, replies: const []);
  }

  @override
  Future<LotseReplyResult> reply(int feedbackId, String body) async =>
      LotseReplyResult.sent;

  @override
  Future<bool> markRead(int feedbackId) async => true;

  @override
  Stream<void> changes(int feedbackId) =>
      Stream.error(const LotseLiveUnavailable());
}

void main() {
  testWidgets('the child disappears in the frame the identity ends, and its '
      'route is removed', (tester) async {
    final epoch = ValueNotifier<int>(0);
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: const Scaffold(body: Text('Host app')),
      ),
    );
    var completed = false;
    navigator.currentState!
        .push(
          MaterialPageRoute<void>(
            builder: (context) => LotseIdentityBoundary(
              epoch: epoch,
              child: const Scaffold(body: Text('Private of A')),
            ),
          ),
        )
        .then((_) => completed = true);
    await tester.pumpAndSettle();
    expect(find.text('Private of A'), findsOneWidget);

    epoch.value++;
    await tester.pump();
    expect(find.text('Private of A'), findsNothing);

    await tester.pumpAndSettle();
    expect(completed, isTrue);
    expect(find.text('Host app'), findsOneWidget);
    expect(navigator.currentState!.canPop(), isFalse);
  });

  testWidgets('a page opened after the reset stays', (tester) async {
    final epoch = ValueNotifier<int>(3);
    await tester.pumpWidget(
      MaterialApp(
        home: LotseIdentityBoundary(epoch: epoch, child: const Text('Of B')),
      ),
    );
    expect(find.text('Of B'), findsOneWidget);
  });

  testWidgets('list and open conversation of A both close on a reset, the '
      'polling stops, and the conversation can be opened again under B', (
    tester,
  ) async {
    final conversations = _Conversations();
    final navigator = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () =>
                  showLotseMyFeedback(context, conversations: conversations),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Private question of A'));
    await tester.pumpAndSettle();
    expect(conversations.threadCalls, 1);
    expect(navigator.currentState!.canPop(), isTrue);

    // What Lotse.reset() does first.
    lotseIdentityEpoch.value++;
    await tester.pump();
    expect(find.text('Private question of A'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Open'), findsOneWidget);
    expect(navigator.currentState!.canPop(), isFalse);

    // No poll of the closed conversation any more.
    final callsAtReset = conversations.threadCalls;
    await tester.pump(lotseThreadPollInterval * 3);
    expect(conversations.threadCalls, callsAtReset);

    // The id is not stuck in the set of open conversations.
    final reopened = pushLotseFeedbackThread(
      navigator.currentState!,
      conversations: conversations,
      feedbackId: 7,
      texts: LotseFeedbackTexts.forLocale(const Locale('en')),
    );
    await tester.pumpAndSettle();
    expect(conversations.threadCalls, callsAtReset + 1);
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await reopened;
  });
}
