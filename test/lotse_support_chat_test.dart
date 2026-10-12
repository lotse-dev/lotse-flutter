import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_feedback.dart';
import 'package:lotse/src/lotse_my_feedback.dart';
import 'package:lotse/src/lotse_support_chat.dart';

/// A support chat in memory that answers like the server would.
class _FakeSupportChat implements LotseSupportChat {
  _FakeSupportChat({this.enabled = true, this.running});

  bool enabled;
  int? running;
  bool failing = false;
  LotseSupportChatResult askAnswer = LotseSupportChatResult.started;
  final asked = <String>[];

  @override
  Future<LotseSupportChatState?> state() async => failing
      ? null
      : LotseSupportChatState(enabled: enabled, feedbackId: running);

  @override
  Future<(LotseSupportChatResult, int?)> ask(String question) async {
    asked.add(question);
    if (askAnswer != LotseSupportChatResult.started) return (askAnswer, null);
    return (askAnswer, running = 7);
  }
}

void main() {
  group('Given the generated support chat calls', () {
    late List<(String, generated.FeedbackSubmission, ByteData?)> submitted;
    Object? submitError;

    ServerLotseSupportChat chat({
      Future<generated.SupportChat> Function(String installId)? get,
    }) => ServerLotseSupportChat(
      installId: 'install-1',
      sessionId: 'session-1',
      getSupportChat:
          get ??
          (installId) async =>
              generated.SupportChat(enabled: true, feedbackId: 4),
      submitFeedback: (installId, submission, {screenshot}) async {
        final error = submitError;
        if (error != null) throw error;
        submitted.add((installId, submission, screenshot));
        return 9;
      },
    );

    setUp(() {
      submitted = [];
      submitError = null;
    });

    test('when the state is read '
        'then it is asked for this install and mapped', () async {
      String? askedFor;
      final state = await chat(
        get: (installId) async {
          askedFor = installId;
          return generated.SupportChat(enabled: false, feedbackId: 4);
        },
      ).state();

      expect(askedFor, 'install-1');
      expect(state!.enabled, isFalse);
      expect(state.feedbackId, 4);
    });

    test(
      'when reading the state fails then null instead of an error',
      () async {
        final state = await chat(
          get: (installId) async => throw Exception('offline'),
        ).state();

        expect(state, isNull);
      },
    );

    test('when a question is asked then it goes out as feedback of the '
        'category question, without a screenshot', () async {
      final (result, id) = await chat().ask('How do I export?');

      expect(result, LotseSupportChatResult.started);
      expect(id, 9);
      final (installId, submission, screenshot) = submitted.single;
      expect(installId, 'install-1');
      expect(submission.category, generated.FeedbackCategory.question);
      expect(submission.message, 'How do I export?');
      expect(submission.sessionId, 'session-1');
      expect(screenshot, isNull);
    });

    test('when the project has the chat switched off then disabled', () async {
      submitError = generated.LotseSupportChatDisabledException(message: 'off');

      expect(await chat().ask('Hello?'), (
        LotseSupportChatResult.disabled,
        null,
      ));
    });

    test('when the feedback quota is used up then limitReached', () async {
      submitError = generated.LotseQuotaExceededException(
        message: 'full',
        resource: 'feedback',
        limit: 10,
      );

      expect(await chat().ask('Hello?'), (
        LotseSupportChatResult.limitReached,
        null,
      ));
    });

    test('when asking fails in any other way then failed', () async {
      submitError = Exception('offline');

      expect(await chat().ask('Hello?'), (LotseSupportChatResult.failed, null));
    });
  });

  group('Given the feedback sheet and the support chat', () {
    test('when the sheet lists its categories then question is not one', () {
      expect(
        lotseSheetCategories,
        isNot(contains(LotseFeedbackCategory.question)),
      );
      expect(
        lotseSheetCategories,
        hasLength(LotseFeedbackCategory.values.length - 1),
      );
    });
  });

  group('Given the state of the support chat', () {
    test('when the chat is on and nothing runs '
        'then a question can be asked and opens the conversation', () async {
      final chat = _FakeSupportChat();
      final controller = LotseSupportChatController(chat);
      addTearDown(controller.dispose);
      expect(controller.status, LotseLoadStatus.loading);
      expect(controller.canAsk('Hello?'), isFalse);

      await controller.load();
      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.enabled, isTrue);
      expect(controller.feedbackId, isNull);
      expect(controller.canAsk('Hello?'), isTrue);

      expect(await controller.ask('  Hello?  '), isTrue);
      expect(chat.asked, ['Hello?']);
      expect(controller.feedbackId, 7);
      expect(controller.failure, isNull);
      // The conversation exists; what follows is a reply, not a question.
      expect(controller.canAsk('Again?'), isFalse);
    });

    test('when a conversation runs then it is the one to show', () async {
      final controller = LotseSupportChatController(
        _FakeSupportChat(running: 3),
      );
      addTearDown(controller.dispose);

      await controller.load();

      expect(controller.feedbackId, 3);
    });

    test('when the chat is off then nothing can be asked, '
        'but a running conversation is still shown', () async {
      final chat = _FakeSupportChat(enabled: false);
      final controller = LotseSupportChatController(chat);
      addTearDown(controller.dispose);

      await controller.load();
      expect(controller.enabled, isFalse);
      expect(controller.canAsk('Hello?'), isFalse);
      expect(await controller.ask('Hello?'), isFalse);
      expect(chat.asked, isEmpty);

      chat.running = 3;
      await controller.load();
      expect(controller.enabled, isFalse);
      expect(controller.feedbackId, 3);
    });

    test('when the chat was switched off after loading '
        'then the question is refused and the chat counts as off', () async {
      final chat = _FakeSupportChat()
        ..askAnswer = LotseSupportChatResult.disabled;
      final controller = LotseSupportChatController(chat);
      addTearDown(controller.dispose);
      await controller.load();

      expect(await controller.ask('Hello?'), isFalse);

      expect(controller.enabled, isFalse);
      expect(controller.feedbackId, isNull);
      expect(controller.failure, isNull);
    });

    test('when asking fails then the failure is kept until the next try '
        'succeeds', () async {
      final chat = _FakeSupportChat()
        ..askAnswer = LotseSupportChatResult.limitReached;
      final controller = LotseSupportChatController(chat);
      addTearDown(controller.dispose);
      await controller.load();

      expect(await controller.ask('Hello?'), isFalse);
      expect(controller.failure, LotseSupportChatResult.limitReached);
      expect(controller.isSending, isFalse);

      chat.askAnswer = LotseSupportChatResult.failed;
      expect(await controller.ask('Hello?'), isFalse);
      expect(controller.failure, LotseSupportChatResult.failed);

      chat.askAnswer = LotseSupportChatResult.started;
      expect(await controller.ask('Hello?'), isTrue);
      expect(controller.failure, isNull);
    });

    test(
      'when the question is empty or too long then it cannot go out',
      () async {
        final controller = LotseSupportChatController(_FakeSupportChat());
        addTearDown(controller.dispose);
        await controller.load();

        expect(controller.canAsk('   '), isFalse);
        expect(controller.canAsk('a' * maxFeedbackMessageLength), isTrue);
        expect(
          controller.canAsk('a' * (maxFeedbackMessageLength + 1)),
          isFalse,
        );
      },
    );

    test('when the load fails then failed, and retry recovers', () async {
      final chat = _FakeSupportChat()..failing = true;
      final controller = LotseSupportChatController(chat);
      addTearDown(controller.dispose);

      await controller.load();
      expect(controller.status, LotseLoadStatus.failed);

      chat.failing = false;
      await controller.retry();
      expect(controller.status, LotseLoadStatus.loaded);
    });

    test('when it is disposed during a load then nothing happens', () async {
      final controller = LotseSupportChatController(_FakeSupportChat());
      final load = controller.load();
      controller.dispose();

      await load;
    });
  });
}
