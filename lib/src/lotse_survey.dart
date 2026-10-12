import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

// Surveys: one question of the team to a segment of devices, shown as a card
// by `LotseInAppMessages`. Internal: an app never handles a survey itself.

/// Event names the SDK tracks for a survey, each with the prop
/// [lotseSurveyIdProp]. Must match `surveys.dart` on the server, which
/// writes `survey_answered` itself.
const lotseSurveyViewEvent = 'survey_view';
const lotseSurveyDismissEvent = 'survey_dismiss';
const lotseSurveyIdProp = 'surveyId';

/// Least time between two automatic fetches, like the in-app messages.
const lotseSurveyFetchInterval = Duration(minutes: 1);

/// How long the thanks stay on the card after the answer arrived.
const lotseSurveyThanksDuration = Duration(seconds: 2);

/// Longest comment the server takes.
const lotseSurveyMaxComment = 1000;

/// The two kinds of question.
enum LotseSurveyKind {
  /// A score from 0 to 10, then an optional comment.
  nps,

  /// One of two to five answers.
  choice,
}

/// A survey as the card shows it.
@immutable
class LotseSurvey {
  const LotseSurvey({
    required this.id,
    required this.kind,
    required this.question,
    this.choices = const [],
    this.askComment = false,
    this.commentPrompt,
  });

  final int id;
  final LotseSurveyKind kind;
  final String question;

  /// The answers of a choice survey, empty for nps.
  final List<String> choices;

  /// Whether an nps survey asks for a comment after the score.
  final bool askComment;

  /// The team's prompt above the comment field, null for the SDK's own.
  final String? commentPrompt;
}

/// The survey of the server as the SDK uses it.
LotseSurvey lotseSurveyFrom(generated.SdkSurvey survey) => LotseSurvey(
  id: survey.id,
  kind: switch (survey.kind) {
    generated.SurveyKind.nps => LotseSurveyKind.nps,
    generated.SurveyKind.choice => LotseSurveyKind.choice,
  },
  question: survey.question,
  choices: survey.choices ?? const [],
  askComment: survey.askComment,
  commentPrompt: survey.commentPrompt,
);

/// Where the card of the current survey is.
enum LotseSurveyStep {
  /// The question with its scores or answers.
  question,

  /// An nps score is chosen; the comment field is open.
  comment,

  /// The answer is on its way.
  sending,

  /// The answer did not arrive; the card offers to send it again.
  failed,

  /// The answer arrived; the card thanks and closes by itself.
  thanks,
}

/// What the card shows: the survey, its step and the answer so far.
@immutable
class LotseSurveyState {
  const LotseSurveyState(
    this.survey, {
    this.step = LotseSurveyStep.question,
    this.score,
    this.choice,
    this.comment,
  });

  final LotseSurvey survey;
  final LotseSurveyStep step;
  final int? score;
  final int? choice;
  final String? comment;

  LotseSurveyState _with(
    LotseSurveyStep step, {
    int? score,
    int? choice,
    String? comment,
  }) => LotseSurveyState(
    survey,
    step: step,
    score: score ?? this.score,
    choice: choice ?? this.choice,
    comment: comment ?? this.comment,
  );
}

/// Asks the server for the survey of this device, null for none.
typedef LotseSurveyFetch = Future<LotseSurvey?> Function();

/// Sends an answer to the survey [surveyId].
typedef LotseSurveyAnswer =
    Future<void> Function(
      int surveyId, {
      int? score,
      int? choice,
      String? comment,
    });

/// Tracks a survey event with its props.
typedef LotseSurveyTrack =
    Future<void> Function(String name, Map<String, String> props);

/// Which survey the app shows now, and how far the user got with it.
///
/// [check] fetches the survey of the device unless one is on screen or
/// [isBlocked] says an in-app message is. The server decides which survey and
/// when; after an answer or a dismissal it sends none for a week. The card
/// calls [shown], [chooseScore], [chooseAnswer], [send], [skipComment] and
/// [dismissed].
class LotseSurveyDesk {
  /// A desk over the server calls. [clock] is for tests, [isBlocked] tells
  /// whether an in-app message is on screen.
  LotseSurveyDesk({
    required this._fetch,
    required this._answer,
    required this._track,
    bool Function()? isBlocked,
    DateTime Function()? clock,
    this.minInterval = lotseSurveyFetchInterval,
    this.thanksDuration = lotseSurveyThanksDuration,
  }) : _isBlocked = isBlocked ?? _never,
       _clock = clock ?? DateTime.now;

  static bool _never() => false;

  final LotseSurveyFetch _fetch;
  final LotseSurveyAnswer _answer;
  final LotseSurveyTrack _track;
  final bool Function() _isBlocked;
  final DateTime Function() _clock;

  /// Least time between two checks that are not forced.
  final Duration minInterval;

  /// How long the thanks stay before the card closes.
  final Duration thanksDuration;

  /// The card to show, null for none.
  ValueListenable<LotseSurveyState?> get current => _current;
  final _current = ValueNotifier<LotseSurveyState?>(null);

  /// Seen in this run of the app; the view is tracked once per run.
  final _viewed = <int>{};

  /// Answered or closed on this device. The server knows, but a check can
  /// come before the dismissal event arrives.
  final _done = <int>{};

  bool _checking = false;
  DateTime? _lastCheck;
  Timer? _thanks;

  /// Counts [clear]: an answer to a call from before is dropped.
  int _generation = 0;

  /// Fetches the survey of the device and shows it, unless a survey or an
  /// in-app message is on screen. Without [force] it does nothing within
  /// [minInterval] of the last fetch. Never throws.
  Future<void> check({bool force = false}) async {
    if (_checking || _current.value != null || _isBlocked()) return;
    final now = _clock();
    final last = _lastCheck;
    if (!force && last != null && now.difference(last) < minInterval) return;
    _lastCheck = now;
    _checking = true;
    final generation = _generation;
    try {
      final survey = await _fetch();
      if (generation != _generation ||
          survey == null ||
          _current.value != null ||
          _done.contains(survey.id) ||
          _isBlocked()) {
        return;
      }
      _current.value = LotseSurveyState(survey);
    } catch (error) {
      debugPrint('Lotse: could not fetch the survey: ${error.runtimeType}');
    } finally {
      if (generation == _generation) _checking = false;
    }
  }

  /// The card of [survey] is on screen. Tracks the view once per run.
  void shown(LotseSurvey survey) {
    if (!_viewed.add(survey.id)) return;
    unawaited(_track(lotseSurveyViewEvent, _props(survey)));
  }

  /// The user tapped [score] of an nps survey. With the comment field the
  /// card asks for it next, otherwise the answer goes out right away.
  void chooseScore(int score) {
    final state = _current.value;
    if (state == null || state.step != LotseSurveyStep.question) return;
    if (state.survey.kind != LotseSurveyKind.nps) return;
    if (state.survey.askComment) {
      _current.value = state._with(LotseSurveyStep.comment, score: score);
    } else {
      unawaited(_send(state._with(LotseSurveyStep.sending, score: score)));
    }
  }

  /// The user tapped the answer [choice] of a choice survey; it goes out
  /// right away.
  void chooseAnswer(int choice) {
    final state = _current.value;
    if (state == null || state.step != LotseSurveyStep.question) return;
    if (state.survey.kind != LotseSurveyKind.choice) return;
    unawaited(_send(state._with(LotseSurveyStep.sending, choice: choice)));
  }

  /// Sends the chosen score with [comment], or sends the failed answer
  /// again.
  Future<void> send({String? comment}) async {
    final state = _current.value;
    if (state == null) return;
    switch (state.step) {
      case LotseSurveyStep.comment:
        final text = comment?.trim() ?? '';
        await _send(
          state._with(
            LotseSurveyStep.sending,
            comment: text.length > lotseSurveyMaxComment
                ? text.substring(0, lotseSurveyMaxComment)
                : text,
          ),
        );
      case LotseSurveyStep.failed:
        await _send(state._with(LotseSurveyStep.sending));
      case LotseSurveyStep.question ||
          LotseSurveyStep.sending ||
          LotseSurveyStep.thanks:
    }
  }

  /// Sends the chosen score without a comment.
  Future<void> skipComment() async {
    final state = _current.value;
    if (state == null || state.step != LotseSurveyStep.comment) return;
    await _send(
      LotseSurveyState(
        state.survey,
        step: LotseSurveyStep.sending,
        score: state.score,
      ),
    );
  }

  /// The user closed the card. Before an answer that is a dismissal: the
  /// survey does not come again. After the answer it only closes the thanks.
  void dismissed(LotseSurvey survey) {
    final state = _current.value;
    if (state == null || state.survey.id != survey.id) return;
    if (state.step == LotseSurveyStep.sending) return;
    _done.add(survey.id);
    _thanks?.cancel();
    _current.value = null;
    if (state.step != LotseSurveyStep.thanks) {
      unawaited(_track(lotseSurveyDismissEvent, _props(survey)));
    }
  }

  Future<void> _send(LotseSurveyState state) async {
    final generation = _generation;
    _current.value = state;
    try {
      final comment = state.comment;
      await _answer(
        state.survey.id,
        score: state.score,
        choice: state.choice,
        comment: comment == null || comment.isEmpty ? null : comment,
      );
      if (generation != _generation) return;
      _thank(state);
    } catch (error) {
      if (generation != _generation) return;
      // Answered already, for example from a call whose answer got lost:
      // nothing left to send.
      if (error is generated.LotseConflictException) {
        _thank(state);
        return;
      }
      debugPrint('Lotse: could not send the answer: ${error.runtimeType}');
      _current.value = state._with(LotseSurveyStep.failed);
    }
  }

  /// The answer of [state] arrived: thanks, then the card closes.
  void _thank(LotseSurveyState state) {
    _done.add(state.survey.id);
    _current.value = state._with(LotseSurveyStep.thanks);
    _thanks = Timer(thanksDuration, () {
      if (_current.value?.survey.id == state.survey.id) _current.value = null;
    });
  }

  /// Forgets everything, for a new identity: the survey of the previous user
  /// must not show for the next one.
  void clear() {
    _generation++;
    _checking = false;
    _lastCheck = null;
    _thanks?.cancel();
    _viewed.clear();
    _done.clear();
    _current.value = null;
  }

  Map<String, String> _props(LotseSurvey survey) => {
    lotseSurveyIdProp: '${survey.id}',
  };
}

/// The desk of the initialised SDK, null before `Lotse.init`. Internal:
/// `LotseInAppMessages` shows what it holds.
final lotseSurveyDesk = ValueNotifier<LotseSurveyDesk?>(null);
