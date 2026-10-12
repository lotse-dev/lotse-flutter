import 'package:flutter/material.dart';

import 'lotse_feature_board.dart';
import 'lotse_feedback_texts.dart';
import 'lotse_identity_boundary.dart';
import 'lotse_my_feedback.dart';
import 'lotse_my_feedback_page.dart';
import 'lotse_log.dart';

/// Opens the feature board above [context] and completes when the user leaves
/// it. The page uses the theme found at [context].
///
/// Failures are logged and shown in the page, never thrown into the app.
Future<void> showLotseFeatureBoard(
  BuildContext context, {
  required LotseFeatureBoard board,
  LotseFeedbackTexts? texts,
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
        // The board shows which ideas this install voted for.
        builder: (context) => LotseIdentityBoundary(
          child: themes.wrap(
            LotseFeatureBoardPage(board: board, texts: resolvedTexts),
          ),
        ),
      ),
    );
  } catch (error) {
    lotseLog('could not show the feature board', error);
  }
}

/// The tabs of the board, left to right.
const lotseFeatureBoardTabs = [
  LotseFeatureStatus.open,
  LotseFeatureStatus.planned,
  LotseFeatureStatus.inProgress,
  LotseFeatureStatus.shipped,
];

/// The label of the tab [status] in [texts].
String lotseFeatureTabLabel(
  LotseFeedbackTexts texts,
  LotseFeatureStatus status,
) => switch (status) {
  LotseFeatureStatus.open => texts.featureTabIdeas,
  LotseFeatureStatus.planned => texts.featureTabPlanned,
  LotseFeatureStatus.inProgress => texts.featureTabInProgress,
  LotseFeatureStatus.shipped => texts.featureTabShipped,
};

/// What the tab [status] shows in [texts] while it is empty.
String lotseFeatureEmptyText(
  LotseFeedbackTexts texts,
  LotseFeatureStatus status,
) => switch (status) {
  LotseFeatureStatus.open => texts.featureEmptyIdeas,
  LotseFeatureStatus.planned => texts.featureEmptyPlanned,
  LotseFeatureStatus.inProgress => texts.featureEmptyInProgress,
  LotseFeatureStatus.shipped => texts.featureEmptyShipped,
};

/// The feature board: the ideas of the team in a tab per status, each with a
/// vote toggle. Renders a [LotseFeatureBoardController]. There is no way to
/// hand in an idea; that is what the feedback sheet is for.
class LotseFeatureBoardPage extends StatefulWidget {
  /// Creates the board on [board].
  const LotseFeatureBoardPage({
    required this.board,
    required this.texts,
    super.key,
  });

  /// Where the ideas come from and the votes go to.
  final LotseFeatureBoard board;

  /// The texts to show.
  final LotseFeedbackTexts texts;

  @override
  State<LotseFeatureBoardPage> createState() => _LotseFeatureBoardPageState();
}

class _LotseFeatureBoardPageState extends State<LotseFeatureBoardPage> {
  late final _controller = LotseFeatureBoardController(widget.board)
    ..addListener(_showVoteFailure)
    ..load();

  // An own messenger, so a message about a vote never outlives the page on a
  // screen of the app.
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  LotseVoteResult? _shownFailure;

  // The vote is already taken back on screen when this runs; the message says
  // why. Every new vote clears the failure first, so the same one shows again.
  void _showVoteFailure() {
    final failure = _controller.voteFailure;
    if (failure == _shownFailure) return;
    _shownFailure = failure;
    if (failure == null) return;
    final texts = widget.texts;
    _messenger.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(switch (failure) {
            LotseVoteResult.gone => texts.featureGone,
            LotseVoteResult.limitReached => texts.featureVoteLimitReached,
            LotseVoteResult.failed ||
            LotseVoteResult.done => texts.featureVoteFailed,
          }),
        ),
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final texts = widget.texts;
    return ScaffoldMessenger(
      key: _messenger,
      child: DefaultTabController(
        length: lotseFeatureBoardTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(texts.featureBoardTitle),
            // Scrollable, so no label is cut on a narrow screen.
            bottom: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              tabs: [
                for (final status in lotseFeatureBoardTabs)
                  Tab(text: lotseFeatureTabLabel(texts, status)),
              ],
            ),
          ),
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
              LotseLoadStatus.loaded => TabBarView(
                children: [
                  for (final status in lotseFeatureBoardTabs) _buildTab(status),
                ],
              ),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(LotseFeatureStatus status) {
    final ideas = _controller.ideasIn(status);
    return RefreshIndicator(
      onRefresh: _controller.load,
      child: ideas.isEmpty
          // Scrollable although it fits, so an empty tab can be pulled too.
          ? CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        lotseFeatureEmptyText(widget.texts, status),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: ideas.length,
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final idea = ideas[index];
                return _IdeaTile(
                  key: ValueKey(idea.id),
                  idea: idea,
                  texts: widget.texts,
                  onToggle: () => _controller.toggleVote(idea.id),
                );
              },
            ),
    );
  }
}

class _IdeaTile extends StatelessWidget {
  const _IdeaTile({
    required this.idea,
    required this.texts,
    required this.onToggle,
    super.key,
  });

  final LotseFeatureIdea idea;
  final LotseFeedbackTexts texts;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _VoteButton(idea: idea, texts: texts, onPressed: onToggle),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(idea.title, style: theme.textTheme.titleMedium),
                if (idea.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    idea.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The count of an idea as a toggle: filled while this device has voted.
class _VoteButton extends StatelessWidget {
  const _VoteButton({
    required this.idea,
    required this.texts,
    required this.onPressed,
  });

  final LotseFeatureIdea idea;
  final LotseFeedbackTexts texts;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: const Size(56, 56),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    final child = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.keyboard_arrow_up),
        Text('${idea.voteCount}'),
      ],
    );
    return Tooltip(
      message: idea.hasVoted ? texts.featureUnvote : texts.featureVote,
      child: Semantics(
        toggled: idea.hasVoted,
        child: idea.hasVoted
            ? FilledButton(onPressed: onPressed, style: style, child: child)
            : OutlinedButton(onPressed: onPressed, style: style, child: child),
      ),
    );
  }
}
