import 'package:flutter/material.dart';

import 'lotse_feedback.dart';
import 'lotse_feedback_texts.dart';
import 'lotse_identity_boundary.dart';
import 'lotse_my_feedback.dart';
import 'lotse_log.dart';

/// Opens the list of this device's feedback above [context] and completes
/// when the user leaves it. The pages use the theme found at [context].
///
/// Failures are logged and shown in the pages, never thrown into the app.
Future<void> showLotseMyFeedback(
  BuildContext context, {
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
            LotseMyFeedbackPage(
              conversations: conversations,
              texts: resolvedTexts,
              onRead: onRead,
            ),
          ),
        ),
      ),
    );
  } catch (error) {
    lotseLog('could not show the feedback list', error);
  }
}

// Conversations that are on screen. A reply push for one of them must not put
// a second copy of the same page on top.
final _openThreads = <int>{};

/// Notes that the conversation [feedbackId] is on screen outside of
/// [pushLotseFeedbackThread], which is the case in the support chat. `false`
/// if it already was; only a caller that got `true` calls
/// [lotseThreadClosed].
bool lotseThreadOpened(int feedbackId) => _openThreads.add(feedbackId);

/// Takes back [lotseThreadOpened].
void lotseThreadClosed(int feedbackId) => _openThreads.remove(feedbackId);

/// Pushes the conversation [feedbackId] onto [navigator] and completes when
/// the user leaves it. Does nothing while that conversation is already open.
///
/// [wrap] carries the themes of the calling context; a conversation opened
/// from a push has none and uses the theme around the navigator.
Future<void> pushLotseFeedbackThread(
  NavigatorState navigator, {
  required LotseConversations conversations,
  required int feedbackId,
  required LotseFeedbackTexts texts,
  VoidCallback? onRead,
  Widget Function(Widget child)? wrap,
}) async {
  if (!_openThreads.add(feedbackId)) return;
  try {
    final page = LotseFeedbackThreadPage(
      conversations: conversations,
      feedbackId: feedbackId,
      texts: texts,
      onRead: onRead,
    );
    await navigator.push(
      MaterialPageRoute<void>(
        builder: (context) =>
            LotseIdentityBoundary(child: wrap?.call(page) ?? page),
      ),
    );
  } catch (error) {
    // Also reached from a push, where nobody awaits the result.
    lotseLog('could not show the conversation', error);
  } finally {
    _openThreads.remove(feedbackId);
  }
}

/// The label of [category] in [texts].
String lotseCategoryLabel(
  LotseFeedbackTexts texts,
  LotseFeedbackCategory category,
) => switch (category) {
  LotseFeedbackCategory.bug => texts.categoryBug,
  LotseFeedbackCategory.idea => texts.categoryIdea,
  LotseFeedbackCategory.praise => texts.categoryPraise,
  LotseFeedbackCategory.other => texts.categoryOther,
  LotseFeedbackCategory.question => texts.categoryQuestion,
};

/// The label of [status] in [texts].
String lotseStatusLabel(
  LotseFeedbackTexts texts,
  LotseMyFeedbackStatus status,
) => switch (status) {
  LotseMyFeedbackStatus.open => texts.statusOpen,
  LotseMyFeedbackStatus.inProgress => texts.statusInProgress,
  LotseMyFeedbackStatus.done => texts.statusDone,
  LotseMyFeedbackStatus.dismissed => texts.statusDismissed,
};

/// [time] in the device's time zone, as date and clock, in the language of
/// [texts].
///
/// Uses the app's [MaterialLocalizations] when the app is localized for that
/// language. Otherwise German is written out here and everything else falls
/// back to English, so a German page never shows "Sep 24, 2026".
@visibleForTesting
String lotseFormatTime(
  BuildContext context,
  LotseFeedbackTexts texts,
  DateTime time,
) {
  final local = time.toLocal();
  final use24Hour = MediaQuery.alwaysUse24HourFormatOf(context);
  final appLanguage = Localizations.maybeLocaleOf(context)?.languageCode;
  if (appLanguage != texts.languageCode && texts.languageCode == 'de') {
    return lotseGermanTime(local);
  }
  final localizations = appLanguage == texts.languageCode
      ? MaterialLocalizations.of(context)
      : const DefaultMaterialLocalizations();
  final clock = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(local),
    alwaysUse24HourFormat: use24Hour,
  );
  return '${localizations.formatShortDate(local)}, $clock';
}

const _germanMonths = [
  'Jan.',
  'Feb.',
  'März',
  'Apr.',
  'Mai',
  'Juni',
  'Juli',
  'Aug.',
  'Sept.',
  'Okt.',
  'Nov.',
  'Dez.',
];

/// [time] the way a German Material app shows it: "24. Sept. 2026, 19:50".
@visibleForTesting
String lotseGermanTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '${time.day}. ${_germanMonths[time.month - 1]} ${time.year}, '
      '$hour:$minute';
}

/// The list of this device's feedback with status and unread marker. Renders
/// a [LotseMyFeedbackListController]; a tap opens the conversation.
class LotseMyFeedbackPage extends StatefulWidget {
  /// Creates the list on [conversations].
  const LotseMyFeedbackPage({
    required this.conversations,
    required this.texts,
    this.onRead,
    super.key,
  });

  /// Where the list and the conversations come from.
  final LotseConversations conversations;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Called after a conversation was marked read.
  final VoidCallback? onRead;

  @override
  State<LotseMyFeedbackPage> createState() => _LotseMyFeedbackPageState();
}

class _LotseMyFeedbackPageState extends State<LotseMyFeedbackPage> {
  late final _controller = LotseMyFeedbackListController(widget.conversations)
    ..load();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _open(LotseMyFeedback feedback) async {
    final navigator = Navigator.of(context);
    final themes = InheritedTheme.capture(from: context, to: navigator.context);
    await pushLotseFeedbackThread(
      navigator,
      conversations: widget.conversations,
      feedbackId: feedback.id,
      texts: widget.texts,
      onRead: widget.onRead,
      wrap: themes.wrap,
    );
    // The unread marker and the order may have changed in there.
    if (mounted) await _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    final texts = widget.texts;
    return Scaffold(
      appBar: AppBar(title: Text(texts.myFeedbackTitle)),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => switch (_controller.status) {
          LotseLoadStatus.loading => const Center(
            child: CircularProgressIndicator(),
          ),
          LotseLoadStatus.failed => LotseLoadFailed(
            texts: texts,
            onRetry: _controller.retry,
          ),
          LotseLoadStatus.loaded when _controller.items.isEmpty => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(texts.myFeedbackEmpty, textAlign: TextAlign.center),
            ),
          ),
          LotseLoadStatus.loaded => RefreshIndicator(
            onRefresh: _controller.load,
            child: ListView.separated(
              itemCount: _controller.items.length,
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final feedback = _controller.items[index];
                return _FeedbackTile(
                  feedback: feedback,
                  texts: texts,
                  onTap: () => _open(feedback),
                );
              },
            ),
          ),
        },
      ),
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  const _FeedbackTile({
    required this.feedback,
    required this.texts,
    required this.onTap,
  });

  final LotseMyFeedback feedback;
  final LotseFeedbackTexts texts;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unread = feedback.unreadCount > 0;
    return ListTile(
      onTap: onTap,
      title: Text(
        feedback.message,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: unread ? const TextStyle(fontWeight: FontWeight.w600) : null,
      ),
      subtitle: Text(
        '${lotseCategoryLabel(texts, feedback.category)} · '
        '${lotseStatusLabel(texts, feedback.status)} · '
        '${lotseFormatTime(context, texts, feedback.lastMessageAt ?? feedback.createdAt)}',
      ),
      trailing: unread
          ? Semantics(
              label: texts.unreadLabel,
              child: Badge(
                label: Text('${feedback.unreadCount}'),
                backgroundColor: theme.colorScheme.primary,
                textColor: theme.colorScheme.onPrimary,
              ),
            )
          : const Icon(Icons.chevron_right),
    );
  }
}

/// The message and the retry button of a page whose first load failed.
class LotseLoadFailed extends StatelessWidget {
  /// Creates the message with a button that calls [onRetry].
  const LotseLoadFailed({
    required this.texts,
    required this.onRetry,
    super.key,
  });

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Loads again.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(texts.loadFailed, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: Text(texts.retry)),
        ],
      ),
    ),
  );
}

/// One conversation with a reply field. Renders a
/// [LotseFeedbackThreadController], which keeps the conversation live (or
/// polls, without the live stream) for as long as this page is in the tree.
class LotseFeedbackThreadPage extends StatefulWidget {
  /// Creates the page of the conversation [feedbackId].
  const LotseFeedbackThreadPage({
    required this.conversations,
    required this.feedbackId,
    required this.texts,
    this.title,
    this.onRead,
    super.key,
  });

  /// Heading of the page, the conversation title of [texts] without one. The
  /// support chat shows its own.
  final String? title;

  /// Where the conversation comes from and replies go to.
  final LotseConversations conversations;

  /// The conversation to show.
  final int feedbackId;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  /// Called after the conversation was marked read.
  final VoidCallback? onRead;

  @override
  State<LotseFeedbackThreadPage> createState() =>
      _LotseFeedbackThreadPageState();
}

class _LotseFeedbackThreadPageState extends State<LotseFeedbackThreadPage>
    with WidgetsBindingObserver {
  late final _controller = LotseFeedbackThreadController(
    widget.conversations,
    widget.feedbackId,
    onRead: widget.onRead,
  );
  final _reply = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.start();
  }

  // Behind another app nothing is shown, so nothing is streamed, polled or
  // marked read.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller.resume();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _reply.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final sent = await _controller.reply(_reply.text);
    // On failure the text stays, so nothing the user wrote is lost.
    if (sent && mounted) _reply.clear();
  }

  @override
  Widget build(BuildContext context) {
    final texts = widget.texts;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? texts.conversationTitle)),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final thread = _controller.thread;
          if (thread == null) {
            return _controller.status == LotseLoadStatus.failed
                ? LotseLoadFailed(texts: texts, onRetry: _controller.retry)
                : const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Column(
              children: [
                Expanded(child: _buildMessages(context, thread)),
                _buildReplyField(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessages(BuildContext context, LotseFeedbackThread thread) {
    final texts = widget.texts;
    final feedback = thread.feedback;
    // Newest at the bottom and the bottom in view: the list is reversed, so
    // index 0 is the last reply and the feedback message itself comes last.
    final replies = thread.replies.reversed.toList();
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(16),
      itemCount: replies.length + 1,
      itemBuilder: (context, index) {
        if (index == replies.length) {
          return _Bubble(
            fromTeam: false,
            author: texts.authorYou,
            body: feedback.message,
            footer:
                '${lotseCategoryLabel(texts, feedback.category)} · '
                '${lotseStatusLabel(texts, feedback.status)} · '
                '${lotseFormatTime(context, texts, feedback.createdAt)}',
          );
        }
        final reply = replies[index];
        return _Bubble(
          fromTeam: reply.fromTeam,
          author: reply.fromTeam ? texts.authorTeam : texts.authorYou,
          body: reply.body,
          footer: lotseFormatTime(context, texts, reply.createdAt),
        );
      },
    );
  }

  Widget _buildReplyField(BuildContext context) {
    final theme = Theme.of(context);
    final texts = widget.texts;
    final failure = _controller.replyFailure;
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
                failure == LotseReplyResult.limitReached
                    ? texts.replyLimitReached
                    : texts.replyFailed,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _reply,
                  builder: (context, value, _) => TextField(
                    controller: _reply,
                    enabled: !_controller.isSending,
                    minLines: 1,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: texts.replyHint,
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
                valueListenable: _reply,
                builder: (context, value, _) => IconButton(
                  tooltip: texts.replySend,
                  onPressed: _controller.canReply(value.text) ? _send : null,
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

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.fromTeam,
    required this.author,
    required this.body,
    required this.footer,
  });

  final bool fromTeam;
  final String author;
  final String body;
  final String footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final small = theme.textTheme.labelSmall?.copyWith(
      color: fromTeam ? colors.onSurfaceVariant : colors.onPrimaryContainer,
    );
    return Align(
      alignment: fromTeam ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fromTeam
              ? colors.surfaceContainerHighest
              : colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(author, style: small),
            const SizedBox(height: 4),
            Text(
              body,
              style: TextStyle(
                color: fromTeam ? colors.onSurface : colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            Text(footer, style: small),
          ],
        ),
      ),
    );
  }
}
