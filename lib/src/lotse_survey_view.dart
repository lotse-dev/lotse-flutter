import 'package:flutter/material.dart';

import 'lotse_feedback_texts.dart';
import 'lotse_survey.dart';

/// The card of the survey [desk] holds, in the middle of the screen above the
/// dimmed app, in the app's theme. Internal: `LotseInAppMessages` shows it
/// when no in-app message is on screen.
///
/// It brings its own [Overlay]: the host sits above the navigator, and the
/// comment field needs one for its selection handles.
class LotseSurveyCard extends StatefulWidget {
  /// The card of [state], acting on [desk].
  const LotseSurveyCard({
    required this.desk,
    required this.state,
    required this.texts,
    super.key,
  });

  final LotseSurveyDesk desk;
  final LotseSurveyState state;
  final LotseFeedbackTexts texts;

  @override
  State<LotseSurveyCard> createState() => _LotseSurveyCardState();
}

class _LotseSurveyCardState extends State<LotseSurveyCard> {
  final _comment = TextEditingController();
  late final OverlayEntry _entry = OverlayEntry(builder: _buildCard);

  @override
  void didUpdateWidget(LotseSurveyCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The entry builds from the widget and lies below it, so it may be
    // marked during this build.
    _entry.markNeedsBuild();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    final state = widget.state;
    final texts = widget.texts;
    final survey = state.survey;
    final insets = MediaQuery.viewInsetsOf(context);
    return ColoredBox(
      color: Colors.black54,
      child: Padding(
        padding: EdgeInsets.only(bottom: insets.bottom),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Material(
                  color: theme.colorScheme.surfaceContainerHigh,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(28),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 8, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  survey.question,
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                            ),
                            if (state.step != LotseSurveyStep.sending)
                              _CloseButton(
                                label: texts.close,
                                onPressed: () => widget.desk.dismissed(survey),
                              )
                            else
                              const SizedBox(width: 48, height: 48),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 16),
                          child: _body(context, state, texts),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    LotseSurveyState state,
    LotseFeedbackTexts texts,
  ) {
    final theme = Theme.of(context);
    final survey = state.survey;
    switch (state.step) {
      case LotseSurveyStep.question:
        return switch (survey.kind) {
          LotseSurveyKind.nps => _Scores(
            texts: texts,
            onScore: widget.desk.chooseScore,
          ),
          LotseSurveyKind.choice => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final (index, answer) in survey.choices.indexed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: OutlinedButton(
                    onPressed: () => widget.desk.chooseAnswer(index),
                    child: Text(answer),
                  ),
                ),
            ],
          ),
        };
      case LotseSurveyStep.comment:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              survey.commentPrompt ?? texts.surveyCommentPrompt,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _comment,
              autofocus: true,
              minLines: 2,
              maxLines: 5,
              maxLength: lotseSurveyMaxComment,
              decoration: InputDecoration(
                hintText: texts.surveyCommentHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.desk.skipComment,
                  child: Text(texts.surveySkip),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => widget.desk.send(comment: _comment.text),
                  child: Text(texts.surveySend),
                ),
              ],
            ),
          ],
        );
      case LotseSurveyStep.sending:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      case LotseSurveyStep.failed:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              texts.surveyFailed,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: widget.desk.send,
                child: Text(texts.retry),
              ),
            ),
          ],
        );
      case LotseSurveyStep.thanks:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(texts.surveyThanks, style: theme.textTheme.titleLarge),
        );
    }
  }
}

/// The scores 0 to 10 in a wrapping row, with the two labels below.
class _Scores extends StatelessWidget {
  const _Scores({required this.texts, required this.onScore});

  final LotseFeedbackTexts texts;
  final void Function(int score) onScore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelSmall;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 4,
          runSpacing: 4,
          alignment: WrapAlignment.center,
          children: [
            for (var score = 0; score <= 10; score++)
              SizedBox(
                width: 40,
                height: 40,
                child: OutlinedButton(
                  key: ValueKey('lotse-survey-score-$score'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: const CircleBorder(),
                  ),
                  onPressed: () => onScore(score),
                  child: Text('$score'),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text(texts.surveyNotLikely, style: label)),
            Text(texts.surveyVeryLikely, style: label),
          ],
        ),
      ],
    );
  }
}

/// A close icon without a tooltip, like the one of the in-app messages.
class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    excludeSemantics: true,
    child: IconButton(icon: const Icon(Icons.close), onPressed: onPressed),
  );
}
