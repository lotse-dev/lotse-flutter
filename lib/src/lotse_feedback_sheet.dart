import 'package:flutter/material.dart';

import 'lotse_annotation_editor.dart';
import 'lotse_capture.dart';
import 'lotse_feedback.dart';
import 'lotse_feedback_texts.dart';
import 'lotse_replay_recorder.dart';
import 'lotse_retake.dart';
import 'lotse_scope.dart';
import 'lotse_log.dart';

/// Captures the screen, then opens the feedback sheet above [context] and
/// completes when the user is done with it.
///
/// The screenshot is taken before the sheet opens, so it shows the app and not
/// the sheet. "Retake" closes the sheet and shows a floating bar instead: the
/// user goes to the screen the feedback is about, anywhere in the app, and
/// captures it there, or cancels. Either way the sheet comes back with
/// everything the user entered, on top of the screen they are on. Without a
/// `LotseScope` there is no screenshot.
///
/// With replays on, the recorder of the scope pauses while the sheet is open,
/// so the message being typed is never recorded, and the sheet offers to
/// attach what it recorded before. During a retake it records again.
///
/// Failures are logged, never thrown into the app.
Future<void> showLotseFeedbackSheet(
  BuildContext context, {
  required LotseFeedbackSender send,
  Map<String, String>? metadata,
  bool askForEmail = false,
  LotseFeedbackTexts? texts,
}) async {
  LotseFeedbackController? controller;
  LotseReplayRecorder? recorder;
  try {
    // Everything that needs the context is read before the first await.
    final navigator = Navigator.of(context);
    final capture = lotseCaptureControllerOf(context);
    recorder = lotseReplayRecorderOf(context)?..hold();
    final replay = recorder;
    final themes = InheritedTheme.capture(from: context, to: navigator.context);
    // The retake bar lives above the app, so it needs every theme up to the
    // root, the app's `Theme` included.
    final appThemes = InheritedTheme.capture(from: context, to: null);
    final textDirection = Directionality.of(context);
    final resolvedTexts =
        texts ??
        LotseFeedbackTexts.forLocale(
          View.of(context).platformDispatcher.locale,
        );
    final state = controller = LotseFeedbackController(
      send,
      askForEmail: askForEmail,
      lastScreen: ModalRoute.of(context)?.settings.name,
      metadata: metadata,
      replay: replay?.chunks,
      replaySeconds: replay?.options.windowSeconds ?? 60,
      attachReplay: replay?.options.attachByDefault ?? true,
    );

    if (capture != null) {
      await _recorderIdle(replay);
      state.applyCapture(await capture.capture());
    }
    while (navigator.mounted) {
      final route = ModalBottomSheetRoute<bool>(
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: true,
        capturedThemes: themes,
        builder: (context) => LotseFeedbackSheet(
          controller: state,
          texts: resolvedTexts,
          canRetake: capture != null,
        ),
      );
      final retake = await navigator.push(route) ?? false;
      if (!retake || capture == null) break;
      // Popped is not gone: the sheet still slides out. Capturing before the
      // transition has ended would put the sheet into the image.
      await route.completed;
      // The user goes looking for the screen: that belongs to the story.
      recorder?.release();
      final choice = await capture.retake.request(
        LotseRetakeRequest(
          hint: resolvedTexts.retakeHint,
          captureLabel: resolvedTexts.retakeCapture,
          cancelLabel: resolvedTexts.retakeCancel,
          themes: appThemes,
          textDirection: textDirection,
        ),
      );
      recorder?.hold();
      // Null: the app went away, or another sheet took over the bar.
      if (choice == null || !navigator.mounted) break;
      if (choice == LotseRetakeChoice.capture) {
        await _recorderIdle(recorder);
        state
          ..applyCapture(await capture.capture())
          ..lastScreen = _topRouteName(navigator) ?? state.lastScreen;
      }
    }
  } catch (error) {
    lotseLog('could not show the feedback sheet', error);
  } finally {
    recorder?.release();
    controller?.dispose();
  }
}

/// Waits for a replay capture that is still running, at most a second: the
/// screenshot must not render at the same time.
Future<void> _recorderIdle(LotseReplayRecorder? recorder) async {
  if (recorder == null) return;
  await recorder.idle.timeout(const Duration(seconds: 1), onTimeout: () {});
}

/// The name of the route on top of [navigator], the screen the user is on.
String? _topRouteName(NavigatorState navigator) {
  String? name;
  // Returning true at once stops at the top route; nothing is popped.
  navigator.popUntil((route) {
    name = route.settings.name;
    return true;
  });
  return name;
}

/// The content of the feedback sheet. Renders [controller] and forwards what
/// the user does; holds no state of its own beyond the text fields.
///
/// Pops its route with `true` when the user asks for a new screenshot and
/// with `null` when the user is done.
class LotseFeedbackSheet extends StatefulWidget {
  /// Creates the sheet for [controller].
  const LotseFeedbackSheet({
    required this.controller,
    required this.texts,
    required this.canRetake,
    super.key,
  });

  /// The state of the sheet. Outlives the widget across a retake.
  final LotseFeedbackController controller;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Whether a screenshot can be taken, which needs a `LotseScope`.
  final bool canRetake;

  @override
  State<LotseFeedbackSheet> createState() => _LotseFeedbackSheetState();
}

class _LotseFeedbackSheetState extends State<LotseFeedbackSheet> {
  // Seeded from the controller: after a retake the sheet is a new widget, but
  // the text is still there.
  late final _message = TextEditingController(text: widget.controller.message);
  late final _email = TextEditingController(text: widget.controller.email);

  @override
  void dispose() {
    _message.dispose();
    _email.dispose();
    super.dispose();
  }

  /// Opens the editor above the sheet and takes over what it hands back. The
  /// editor starts from the captured screenshot and the strokes so far, so
  /// marks of an earlier visit can still be undone.
  Future<void> _annotate() async {
    final controller = widget.controller;
    final captured = controller.capturedScreenshot;
    if (captured == null) return;
    final navigator = Navigator.of(context);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);
    FocusManager.instance.primaryFocus?.unfocus();
    final result = await navigator.push(
      MaterialPageRoute<LotseAnnotationResult>(
        fullscreenDialog: true,
        builder: (context) => themes.wrap(
          LotseAnnotationEditor(
            screenshot: captured,
            strokes: controller.strokes,
            texts: widget.texts,
          ),
        ),
      ),
    );
    if (result == null) return;
    controller.applyAnnotation(result.strokes, result.screenshot);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Keeps the send button above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) =>
              widget.controller.status == LotseFeedbackStatus.sent
              ? _buildSent(context)
              : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildSent(BuildContext context) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 56,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(texts.sentTitle, style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(texts.sentBody, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(texts.close),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    final controller = widget.controller;
    final sending = controller.status == LotseFeedbackStatus.sending;
    final failed = controller.status == LotseFeedbackStatus.failed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(texts.title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            for (final category in lotseSheetCategories)
              ChoiceChip(
                label: Text(_categoryLabel(category)),
                selected: controller.category == category,
                onSelected: sending
                    ? null
                    : (_) => controller.category = category,
              ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _message,
          enabled: !sending,
          minLines: 3,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) => controller.message = value,
          decoration: InputDecoration(
            hintText: texts.messageHint,
            border: const OutlineInputBorder(),
            errorText: controller.isMessageTooLong
                ? texts.messageTooLong
                : null,
          ),
        ),
        if (controller.askForEmail) ...[
          const SizedBox(height: 16),
          TextField(
            controller: _email,
            enabled: !sending,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            onChanged: (value) => controller.email = value,
            decoration: InputDecoration(
              labelText: texts.emailLabel,
              border: const OutlineInputBorder(),
              errorText: controller.isEmailInvalid ? texts.emailInvalid : null,
            ),
          ),
        ],
        ..._buildScreenshot(context, sending: sending),
        if (controller.replayAvailable)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: controller.attachReplay,
            onChanged: sending
                ? null
                : (value) => controller.attachReplay = value,
            title: Text(
              texts.replayAttach.replaceAll(
                '{seconds}',
                '${controller.replaySeconds}',
              ),
            ),
            subtitle: Text(texts.replayHint),
          ),
        if (failed) ...[
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                controller.lastResult == LotseFeedbackSendResult.limitReached
                    ? texts.limitReached
                    : texts.sendFailed,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: controller.canSend ? controller.send : null,
          child: sending
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(failed ? texts.retry : texts.send),
        ),
      ],
    );
  }

  List<Widget> _buildScreenshot(BuildContext context, {required bool sending}) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    final controller = widget.controller;
    final screenshot = controller.screenshot;
    final explanation = _captureExplanation(controller.captureFailure);
    final retake = widget.canRetake
        ? TextButton.icon(
            onPressed: sending ? null : () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.screenshot_outlined),
            label: Text(texts.retake),
          )
        : null;
    if (screenshot == null && explanation == null && retake == null) {
      return const [];
    }

    return [
      const SizedBox(height: 16),
      if (screenshot != null)
        Align(
          alignment: Alignment.centerLeft,
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                screenshot.png,
                height: 160,
                gaplessPlayback: true,
                semanticLabel: texts.screenshotLabel,
              ),
            ),
          ),
        ),
      if (explanation != null)
        Text(
          explanation,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      Wrap(
        spacing: 8,
        children: [
          ?retake,
          if (screenshot != null)
            TextButton.icon(
              onPressed: sending ? null : _annotate,
              icon: const Icon(Icons.draw_outlined),
              label: Text(texts.annotate),
            ),
          if (screenshot != null)
            TextButton.icon(
              onPressed: sending ? null : controller.removeScreenshot,
              icon: const Icon(Icons.delete_outline),
              label: Text(texts.remove),
            ),
        ],
      ),
    ];
  }

  String _categoryLabel(LotseFeedbackCategory category) => switch (category) {
    LotseFeedbackCategory.bug => widget.texts.categoryBug,
    LotseFeedbackCategory.idea => widget.texts.categoryIdea,
    LotseFeedbackCategory.praise => widget.texts.categoryPraise,
    LotseFeedbackCategory.other => widget.texts.categoryOther,
    LotseFeedbackCategory.question => widget.texts.categoryQuestion,
  };

  /// What the sheet says about a failed capture. A missing scope is not worth
  /// a sentence: the app chose to run without screenshots.
  String? _captureExplanation(LotseCaptureFailure? failure) =>
      switch (failure) {
        null || LotseCaptureFailure.noBoundary => null,
        LotseCaptureFailure.renderFailed => widget.texts.captureRenderFailed,
        LotseCaptureFailure.tooLarge => widget.texts.captureTooLarge,
        LotseCaptureFailure.unknown => widget.texts.captureFailed,
      };
}
