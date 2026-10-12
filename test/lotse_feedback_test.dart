import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_annotation.dart';
import 'package:lotse/src/lotse_capture.dart';
import 'package:lotse/src/lotse_feedback.dart';

LotseScreenshot _screenshot([List<int> bytes = const [1, 2, 3]]) =>
    LotseScreenshot(
      png: Uint8List.fromList(bytes),
      width: 1,
      height: 1,
      pixelRatio: 1,
    );

/// Records the drafts it gets and answers with [results] in order, then with
/// `sent`.
class _FakeSender {
  _FakeSender([List<LotseFeedbackSendResult> results = const []])
    : _results = [...results];

  final List<LotseFeedbackSendResult> _results;
  final drafts = <LotseFeedbackDraft>[];

  Future<LotseFeedbackSendResult> call(LotseFeedbackDraft draft) async {
    drafts.add(draft);
    return _results.isEmpty
        ? LotseFeedbackSendResult.sent
        : _results.removeAt(0);
  }
}

void main() {
  group('Given a draft and the generated submitFeedback', () {
    const draft = LotseFeedbackDraft(
      category: LotseFeedbackCategory.idea,
      message: 'Dark mode please',
      contactEmail: 'ada@example.com',
      lastScreen: '/settings',
      metadata: {'plan': 'pro'},
    );

    test('when the draft is sent '
        'then every field arrives in the generated types', () async {
      late String sentInstallId;
      late generated.FeedbackSubmission sent;
      ByteData? sentScreenshot;

      final result = await sendLotseFeedback(
        (installId, submission, {screenshot}) async {
          sentInstallId = installId;
          sent = submission;
          sentScreenshot = screenshot;
          return 7;
        },
        installId: 'install-1',
        sessionId: 'session-1',
        draft: draft,
      );

      expect(result, LotseFeedbackSendResult.sent);
      expect(sentInstallId, 'install-1');
      expect(sent.category, generated.FeedbackCategory.idea);
      expect(sent.message, 'Dark mode please');
      expect(sent.contactEmail, 'ada@example.com');
      expect(sent.lastScreen, '/settings');
      expect(sent.metadata, {'plan': 'pro'});
      expect(sent.sessionId, 'session-1');
      expect(sentScreenshot, isNull);
    });

    test('when the draft has a screenshot '
        'then exactly its bytes are sent, even from a view into a larger '
        'buffer', () async {
      final buffer = Uint8List.fromList([9, 9, 1, 2, 3, 9]);
      ByteData? sentScreenshot;

      await sendLotseFeedback(
        (installId, submission, {screenshot}) async {
          sentScreenshot = screenshot;
          return 1;
        },
        installId: 'install-1',
        sessionId: 'session-1',
        draft: LotseFeedbackDraft(
          category: LotseFeedbackCategory.bug,
          message: 'Broken',
          screenshot: Uint8List.sublistView(buffer, 2, 5),
        ),
      );

      final bytes = sentScreenshot!;
      expect(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
        [1, 2, 3],
      );
    });

    test('when the server reports a used-up quota '
        'then the result is limitReached and nothing is thrown', () async {
      final result = await sendLotseFeedback(
        (installId, submission, {screenshot}) async =>
            throw generated.LotseQuotaExceededException(
              resource: 'feedback',
              limit: 10,
              message: 'Too many.',
            ),
        installId: 'install-1',
        sessionId: 'session-1',
        draft: draft,
      );

      expect(result, LotseFeedbackSendResult.limitReached);
    });

    test('when the call fails '
        'then the result is failed and the log names neither message nor '
        'e-mail', () async {
      final logged = <String?>[];
      final original = debugPrint;
      debugPrint = (message, {wrapWidth}) => logged.add(message);
      addTearDown(() => debugPrint = original);

      final result = await sendLotseFeedback(
        (installId, submission, {screenshot}) async => throw StateError(
          '${submission.message} ${submission.contactEmail}',
        ),
        installId: 'install-1',
        sessionId: 'session-1',
        draft: draft,
      );

      expect(result, LotseFeedbackSendResult.failed);
      expect(logged, hasLength(1));
      expect(logged.single, isNot(contains('Dark mode')));
      expect(logged.single, isNot(contains('ada@example.com')));
    });

    test(
      'every public category maps to the generated one of the same name',
      () {
        for (final category in LotseFeedbackCategory.values) {
          expect(generatedFeedbackCategory(category).name, category.name);
        }
        expect(
          generated.FeedbackCategory.values,
          hasLength(LotseFeedbackCategory.values.length),
        );
      },
    );
  });

  group('Given the state of a feedback sheet', () {
    test('when nothing is entered then it cannot be sent', () async {
      final sender = _FakeSender();
      final controller = LotseFeedbackController(sender.call);

      expect(controller.canSend, isFalse);
      controller.message = '   \n ';
      expect(controller.canSend, isFalse);
      await controller.send();

      expect(sender.drafts, isEmpty);
      expect(controller.status, LotseFeedbackStatus.editing);
    });

    test('when the message is longer than 4000 characters '
        'then it is flagged and cannot be sent', () {
      final controller = LotseFeedbackController(_FakeSender().call);

      controller.message = 'a' * 4000;
      expect(controller.isMessageTooLong, isFalse);
      expect(controller.canSend, isTrue);

      controller.message = 'a' * 4001;
      expect(controller.isMessageTooLong, isTrue);
      expect(controller.canSend, isFalse);
    });

    test('when the e-mail field is on '
        'then an empty address is fine and a malformed one blocks sending', () {
      final controller = LotseFeedbackController(
        _FakeSender().call,
        askForEmail: true,
      )..message = 'Hello';

      expect(controller.canSend, isTrue);
      for (final bad in ['ada', 'ada@', 'ada@example', 'a da@example.com']) {
        controller.email = bad;
        expect(controller.isEmailInvalid, isTrue, reason: bad);
        expect(controller.canSend, isFalse, reason: bad);
      }
      controller.email = '${'a' * 250}@example.com';
      expect(controller.isEmailInvalid, isTrue);

      controller.email = ' ada@example.com ';
      expect(controller.isEmailInvalid, isFalse);
      expect(controller.draft.contactEmail, 'ada@example.com');
    });

    test('when the e-mail field is off then no address is ever sent', () {
      final controller = LotseFeedbackController(_FakeSender().call)
        ..message = 'Hello'
        ..email = 'ada@example.com';

      expect(controller.canSend, isTrue);
      expect(controller.draft.contactEmail, isNull);
    });

    test('when the draft is built '
        'then it carries the trimmed text, category, screen, metadata and '
        'screenshot', () {
      final controller =
          LotseFeedbackController(
              _FakeSender().call,
              lastScreen: '/offer/7',
              metadata: const {'cart': '3 items'},
            )
            ..category = LotseFeedbackCategory.praise
            ..message = '  Nice app \n'
            ..applyCapture(LotseCaptureSuccess(_screenshot([4, 5])));

      final draft = controller.draft;
      expect(draft.category, LotseFeedbackCategory.praise);
      expect(draft.message, 'Nice app');
      expect(draft.lastScreen, '/offer/7');
      expect(draft.metadata, {'cart': '3 items'});
      expect(draft.screenshot, [4, 5]);
    });

    test('when a capture fails '
        'then the failure is kept and the previous screenshot is gone', () {
      final controller = LotseFeedbackController(_FakeSender().call)
        ..applyCapture(LotseCaptureSuccess(_screenshot()));
      expect(controller.screenshot, isNotNull);
      expect(controller.captureFailure, isNull);

      controller.applyCapture(
        const LotseCaptureFailed(LotseCaptureFailure.renderFailed),
      );

      expect(controller.screenshot, isNull);
      expect(controller.captureFailure, LotseCaptureFailure.renderFailed);
    });

    test('when the screenshot is removed then the draft goes without it', () {
      final controller = LotseFeedbackController(_FakeSender().call)
        ..message = 'Hello'
        ..applyCapture(LotseCaptureSuccess(_screenshot()));

      controller.removeScreenshot();

      expect(controller.screenshot, isNull);
      expect(controller.draft.screenshot, isNull);
    });

    test('when the screenshot is annotated '
        'then the merged image is sent and the captured one is kept for the '
        'next session', () {
      final captured = _screenshot([1]);
      final merged = _screenshot([2]);
      final strokes = [
        LotseStroke(const [Offset(0, 0), Offset(1, 1)]),
      ];
      final controller = LotseFeedbackController(_FakeSender().call)
        ..applyCapture(LotseCaptureSuccess(captured));
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.applyAnnotation(strokes, merged);

      expect(controller.draft.screenshot, [2]);
      expect(controller.capturedScreenshot, same(captured));
      expect(controller.strokes, hasLength(1));
      expect(notifications, 1);
    });

    test('when every stroke was undone '
        'then the captured screenshot is sent again', () {
      final captured = _screenshot([1]);
      final controller = LotseFeedbackController(_FakeSender().call)
        ..applyCapture(LotseCaptureSuccess(captured))
        ..applyAnnotation([
          LotseStroke(const [Offset(0, 0)]),
        ], _screenshot([2]));

      controller.applyAnnotation(const [], _screenshot([3]));

      expect(controller.screenshot, same(captured));
      expect(controller.strokes, isEmpty);
    });

    test('when the screenshot is retaken or removed '
        'then the strokes of the old one are gone', () {
      final controller = LotseFeedbackController(_FakeSender().call)
        ..applyCapture(LotseCaptureSuccess(_screenshot([1])))
        ..applyAnnotation([
          LotseStroke(const [Offset(0, 0)]),
        ], _screenshot([2]));

      final retaken = _screenshot([4]);
      controller.applyCapture(LotseCaptureSuccess(retaken));

      expect(controller.screenshot, same(retaken));
      expect(controller.capturedScreenshot, same(retaken));
      expect(controller.strokes, isEmpty);

      controller
        ..applyAnnotation([
          LotseStroke(const [Offset(0, 0)]),
        ], _screenshot([5]))
        ..removeScreenshot();

      expect(controller.screenshot, isNull);
      expect(controller.capturedScreenshot, isNull);
      expect(controller.strokes, isEmpty);
    });

    test('when there is no screenshot then an annotation is ignored', () {
      final controller = LotseFeedbackController(_FakeSender().call);

      controller.applyAnnotation([
        LotseStroke(const [Offset(0, 0)]),
      ], _screenshot([2]));

      expect(controller.screenshot, isNull);
      expect(controller.strokes, isEmpty);
    });

    test('when sending is under way '
        'then the state is locked and a second send does nothing', () async {
      final answer = Completer<LotseFeedbackSendResult>();
      var calls = 0;
      final controller = LotseFeedbackController((draft) {
        calls++;
        return answer.future;
      })..message = 'Hello';
      final statuses = <LotseFeedbackStatus>[];
      controller.addListener(() => statuses.add(controller.status));

      final sending = controller.send();
      expect(controller.status, LotseFeedbackStatus.sending);
      expect(controller.canSend, isFalse);
      await controller.send();
      controller.message = 'changed';
      expect(controller.message, 'Hello');

      answer.complete(LotseFeedbackSendResult.sent);
      await sending;

      expect(calls, 1);
      expect(statuses, [LotseFeedbackStatus.sending, LotseFeedbackStatus.sent]);
      expect(controller.canSend, isFalse);
    });

    test('when sending fails '
        'then everything entered is kept and a retry sends the same '
        'draft', () async {
      final sender = _FakeSender([LotseFeedbackSendResult.failed]);
      final controller = LotseFeedbackController(sender.call, askForEmail: true)
        ..category = LotseFeedbackCategory.idea
        ..message = 'Dark mode please'
        ..email = 'ada@example.com'
        ..applyCapture(LotseCaptureSuccess(_screenshot()));

      await controller.send();

      expect(controller.status, LotseFeedbackStatus.failed);
      expect(controller.lastResult, LotseFeedbackSendResult.failed);
      expect(controller.category, LotseFeedbackCategory.idea);
      expect(controller.message, 'Dark mode please');
      expect(controller.email, 'ada@example.com');
      expect(controller.screenshot, isNotNull);
      expect(controller.canSend, isTrue);

      await controller.send();

      expect(controller.status, LotseFeedbackStatus.sent);
      expect(sender.drafts, hasLength(2));
      expect(sender.drafts.last.message, 'Dark mode please');
      expect(sender.drafts.last.contactEmail, 'ada@example.com');
      expect(sender.drafts.last.screenshot, [1, 2, 3]);
    });

    test('when the quota is used up then the failure says so', () async {
      final controller = LotseFeedbackController(
        _FakeSender([LotseFeedbackSendResult.limitReached]).call,
      )..message = 'Hello';

      await controller.send();

      expect(controller.status, LotseFeedbackStatus.failed);
      expect(controller.lastResult, LotseFeedbackSendResult.limitReached);
    });

    test('when the sender throws against its contract '
        'then the state is failed and nothing is thrown', () async {
      final controller = LotseFeedbackController(
        (draft) async => throw StateError('broken sender'),
      )..message = 'Hello';

      await controller.send();

      expect(controller.status, LotseFeedbackStatus.failed);
    });

    test('when the sheet is closed while sending '
        'then the late answer is dropped quietly', () async {
      final answer = Completer<LotseFeedbackSendResult>();
      final controller = LotseFeedbackController((draft) => answer.future)
        ..message = 'Hello';

      final sending = controller.send();
      controller.dispose();
      answer.complete(LotseFeedbackSendResult.sent);

      await expectLater(sending, completes);
    });
  });
}
