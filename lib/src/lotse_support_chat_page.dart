import 'package:flutter/material.dart';

import 'lotse_feedback.dart';
import 'lotse_feedback_texts.dart';
import 'lotse_identity_boundary.dart';
import 'lotse_my_feedback.dart';
import 'lotse_my_feedback_page.dart';
import 'lotse_support_chat.dart';
import 'lotse_log.dart';

/// Opens the support chat above [context] and completes when the user leaves
/// it. The page uses the theme found at [context].
///
/// Failures are logged and shown in the page, never thrown into the app.
Future<void> showLotseSupportChat(
  BuildContext context, {
  required LotseSupportChat chat,
  required LotseConversations conversations,
  LotseFeedbackTexts? texts,
  VoidCallback? onRead,
}) async {
  try {
    final navigator = Navigator.of(context);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);
    final resolvedTexts =
        texts ??
        LotseFeedbackTexts.forLocale(
          View.of(context).platformDispatcher.locale,
        );
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (context) => LotseIdentityBoundary(
          child: themes.wrap(
            LotseSupportChatPage(
              chat: chat,
              conversations: conversations,
              texts: resolvedTexts,
              onRead: onRead,
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    lotseLog('could not show the support chat', error);
  }
}

/// The support chat: the running question conversation of this device, or
/// the field for a first question, or a notice while the project has the chat
/// switched off. Renders a [LotseSupportChatController]; the conversation
/// itself is a [LotseFeedbackThreadPage].
class LotseSupportChatPage extends StatefulWidget {
  /// Creates the support chat on [chat] and [conversations].
  const LotseSupportChatPage({
    required this.chat,
    required this.conversations,
    required this.texts,
    this.onRead,
    super.key,
  });

  /// Whether the chat is on, and where the first question goes to.
  final LotseSupportChat chat;

  /// Where the conversation comes from and replies go to.
  final LotseConversations conversations;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Called after the conversation was marked read.
  final VoidCallback? onRead;

  @override
  State<LotseSupportChatPage> createState() => _LotseSupportChatPageState();
}

class _LotseSupportChatPageState extends State<LotseSupportChatPage> {
  late final _controller = LotseSupportChatController(widget.chat)
    ..addListener(_noteOpenThread)
    ..load();
  final _question = TextEditingController();
  int? _notedThread;

  // A reply push for the conversation shown here must not put it on top a
  // second time.
  void _noteOpenThread() {
    final id = _controller.feedbackId;
    if (id == null || _notedThread != null) return;
    if (lotseThreadOpened(id)) _notedThread = id;
  }

  @override
  void dispose() {
    final noted = _notedThread;
    if (noted != null) lotseThreadClosed(noted);
    _controller.dispose();
    _question.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    // On failure the text stays, so nothing the user wrote is lost.
    await _controller.ask(_question.text);
  }

  @override
  Widget build(BuildContext context) {
    final texts = widget.texts;
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final feedbackId = _controller.feedbackId;
        if (feedbackId != null) {
          return LotseFeedbackThreadPage(
            conversations: widget.conversations,
            feedbackId: feedbackId,
            texts: texts,
            title: texts.supportChatTitle,
            onRead: widget.onRead,
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(texts.supportChatTitle)),
          body: switch (_controller.status) {
            LotseLoadStatus.loading => const Center(
              child: CircularProgressIndicator(),
            ),
            LotseLoadStatus.failed => LotseLoadFailed(
              texts: texts,
              onRetry: _controller.retry,
            ),
            LotseLoadStatus.loaded => SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: _Notice(
                      _controller.enabled
                          ? texts.supportChatIntro
                          : texts.supportChatDisabled,
                    ),
                  ),
                  if (_controller.enabled) _buildQuestionField(context),
                ],
              ),
            ),
          },
        );
      },
    );
  }

  Widget _buildQuestionField(BuildContext context) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    final failure = _controller.failure;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (failure != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 8),
              child: Text(
                failure == LotseSupportChatResult.limitReached
                    ? texts.supportChatLimitReached
                    : texts.supportChatFailed,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _question,
                  builder: (context, value, _) => TextField(
                    controller: _question,
                    enabled: !_controller.isSending,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: texts.supportChatHint,
                      border: const OutlineInputBorder(),
                      errorText:
                          value.text.trim().length > maxFeedbackMessageLength
                          ? texts.messageTooLong
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              ValueListenableBuilder(
                valueListenable: _question,
                builder: (context, value, _) => IconButton(
                  tooltip: texts.supportChatSend,
                  onPressed: _controller.canAsk(value.text) ? _send : null,
                  icon: _controller.isSending
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}
