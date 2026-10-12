import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:flutter/cupertino.dart'
    show CupertinoLocalizations, DefaultCupertinoLocalizations;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_in_app.dart';
import 'package:lotse/src/lotse_in_app_view.dart';
import 'package:lotse/src/lotse_survey.dart';

const _nps = LotseSurvey(
  id: 7,
  kind: LotseSurveyKind.nps,
  question: 'Would you recommend Nook?',
  askComment: true,
);
const _npsNoComment = LotseSurvey(
  id: 8,
  kind: LotseSurveyKind.nps,
  question: 'Would you recommend Nook?',
);
const _choice = LotseSurvey(
  id: 9,
  kind: LotseSurveyKind.choice,
  question: 'What brought you here?',
  choices: ['Newsletter', 'Friend', 'Search'],
);
const _message = LotseInAppMessage(
  id: 1,
  title: 'Spring sale',
  body: '20 % off everything.',
  style: LotseInAppStyle.card,
);

/// A server in memory: hands out [survey], records answers and events.
class _Server {
  LotseSurvey? survey;
  int fetches = 0;
  Object? answerError;
  Completer<void>? hold;

  /// `id score choice comment` per answer.
  final answers = <String>[];

  /// `name surveyId` per tracked event.
  final events = <String>[];

  Future<LotseSurvey?> fetch() async {
    fetches++;
    return survey;
  }

  Future<void> answer(
    int surveyId, {
    int? score,
    int? choice,
    String? comment,
  }) async {
    await hold?.future;
    if (answerError case final error?) throw error;
    answers.add('$surveyId $score $choice $comment');
  }

  Future<void> track(String name, Map<String, String> props) async =>
      events.add('$name ${props['surveyId']}');
}

void main() {
  late _Server server;
  late DateTime now;
  var blocked = false;

  LotseSurveyDesk desk({Duration thanks = Duration.zero}) => LotseSurveyDesk(
    fetch: server.fetch,
    answer: server.answer,
    track: server.track,
    isBlocked: () => blocked,
    clock: () => now,
    thanksDuration: thanks,
  );

  setUp(() {
    server = _Server();
    now = DateTime.utc(2026, 10, 1, 12);
    blocked = false;
  });

  group('LotseSurveyDesk', () {
    test('shows the survey of the server and tracks the view once', () async {
      server.survey = _nps;
      final d = desk();
      await d.check();
      expect(d.current.value!.survey, _nps);
      expect(d.current.value!.step, LotseSurveyStep.question);
      d.shown(_nps);
      d.shown(_nps);
      expect(server.events, ['survey_view 7']);
    });

    test('does not fetch while an in-app message is on screen, and fetches '
        'at most once a minute unless forced', () async {
      server.survey = _nps;
      final d = desk();
      blocked = true;
      await d.check(force: true);
      expect(server.fetches, 0);
      blocked = false;
      server.survey = null;
      await d.check();
      await d.check();
      expect(server.fetches, 1);
      now = now.add(const Duration(minutes: 1));
      await d.check();
      expect(server.fetches, 2);
      await d.check(force: true);
      expect(server.fetches, 3);
    });

    test('an NPS score with the comment field asks for the comment, then '
        'sends score and trimmed comment and thanks', () async {
      server.survey = _nps;
      final d = desk();
      await d.check();
      d.chooseScore(4);
      expect(d.current.value!.step, LotseSurveyStep.comment);
      expect(d.current.value!.score, 4);
      expect(server.answers, isEmpty);
      await d.send(comment: '  Too slow.  ');
      expect(server.answers, ['7 4 null Too slow.']);
      expect(d.current.value!.step, LotseSurveyStep.thanks);
      await Future<void>.delayed(Duration.zero);
      expect(d.current.value, isNull);
      expect(server.events, isEmpty);
    });

    test('skipping the comment sends the score alone, and an empty comment '
        'counts as none', () async {
      server.survey = _nps;
      final d = desk();
      await d.check();
      d.chooseScore(10);
      await d.skipComment();
      // The thanks close after zero time, on the next turn.
      await Future<void>.delayed(Duration.zero);
      server.survey = _nps.copyWithId(70);
      await d.check(force: true);
      d.chooseScore(9);
      await d.send(comment: '   ');
      expect(server.answers, ['7 10 null null', '70 9 null null']);
    });

    test('an NPS score without the comment field and a choice go out at '
        'once', () async {
      server.survey = _npsNoComment;
      final d = desk();
      await d.check();
      d.chooseScore(6);
      await pumpEventQueue();
      server.survey = _choice;
      await d.check(force: true);
      d.chooseAnswer(2);
      await pumpEventQueue();
      expect(server.answers, ['8 6 null null', '9 null 2 null']);
    });

    test('a failed answer keeps the card and sends again on retry', () async {
      server.survey = _nps;
      server.answerError = Exception('offline');
      final d = desk(thanks: const Duration(hours: 1));
      await d.check();
      d.chooseScore(2);
      await d.send(comment: 'Crashes');
      expect(d.current.value!.step, LotseSurveyStep.failed);
      expect(d.current.value!.comment, 'Crashes');
      server.answerError = null;
      await d.send();
      expect(server.answers, ['7 2 null Crashes']);
      expect(d.current.value!.step, LotseSurveyStep.thanks);
    });

    test('an answer the server has already counts as sent', () async {
      server.survey = _choice;
      server.answerError = generated.LotseConflictException(message: 'twice');
      final d = desk(thanks: const Duration(hours: 1));
      await d.check();
      d.chooseAnswer(0);
      await pumpEventQueue();
      expect(d.current.value!.step, LotseSurveyStep.thanks);
    });

    test('closing before the answer is a dismissal and the survey does not '
        'come again in this run; closing the thanks is none', () async {
      server.survey = _nps;
      final d = desk(thanks: const Duration(hours: 1));
      await d.check();
      d.dismissed(_nps);
      expect(d.current.value, isNull);
      expect(server.events, ['survey_dismiss 7']);
      await d.check(force: true);
      expect(d.current.value, isNull);

      server.survey = _choice;
      await d.check(force: true);
      d.chooseAnswer(1);
      await pumpEventQueue();
      d.dismissed(_choice);
      expect(d.current.value, isNull);
      expect(server.events, ['survey_dismiss 7']);
    });

    test('a new identity drops the card and a pending answer', () async {
      server.survey = _nps;
      server.hold = Completer<void>();
      final d = desk();
      await d.check();
      d.chooseScore(3);
      final sending = d.send(comment: 'x');
      d.clear();
      server.hold!.complete();
      await sending;
      expect(d.current.value, isNull);
    });
  });

  group('the survey card in LotseInAppHost', () {
    late LotseSurveyDesk surveys;
    late LotseInAppInbox inbox;
    var messages = <LotseInAppMessage>[];
    final inAppEvents = <String>[];

    setUp(() {
      messages = [];
      inAppEvents.clear();
      inbox = LotseInAppInbox(
        fetch: () async => [...messages],
        track: (name, props) async => inAppEvents.add(name),
      );
      blocked = false;
      surveys = LotseSurveyDesk(
        fetch: server.fetch,
        answer: server.answer,
        track: server.track,
        isBlocked: () => inbox.current.value != null,
        thanksDuration: const Duration(seconds: 2),
      );
    });

    Future<void> pump(WidgetTester tester, {Locale? locale}) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          supportedLocales: const [Locale('en'), Locale('de')],
          localizationsDelegates: const [
            _AnyMaterialLocalizations(),
            _AnyCupertinoLocalizations(),
            DefaultWidgetsLocalizations.delegate,
          ],
          builder: (context, child) =>
              LotseInAppHost(inbox: inbox, surveys: surveys, child: child!),
          home: const Scaffold(body: Text('App')),
        ),
      );
      await tester.pump();
    }

    testWidgets('an NPS survey shows 0 to 10, asks for a comment and thanks', (
      tester,
    ) async {
      server.survey = _nps;
      await surveys.check();
      await pump(tester);
      expect(find.text('Would you recommend Nook?'), findsOneWidget);
      expect(find.text('Not likely'), findsOneWidget);
      expect(find.text('Very likely'), findsOneWidget);
      for (var s = 0; s <= 10; s++) {
        expect(find.byKey(ValueKey('lotse-survey-score-$s')), findsOneWidget);
      }
      expect(server.events, ['survey_view 7']);

      await tester.tap(find.byKey(const ValueKey('lotse-survey-score-3')));
      await tester.pump();
      expect(
        find.text('What is the main reason for your score?'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'Too slow.');
      await tester.tap(find.text('Send'));
      await tester.pump();
      expect(server.answers, ['7 3 null Too slow.']);
      expect(find.text('Thank you!'), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Thank you!'), findsNothing);
      expect(find.text('App'), findsOneWidget);
    });

    testWidgets('a choice survey sends the tapped answer', (tester) async {
      server.survey = _choice;
      await surveys.check();
      await pump(tester);
      await tester.tap(find.text('Friend'));
      await tester.pump();
      expect(server.answers, ['9 null 1 null']);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('the team\'s prompt replaces the SDK\'s, and a German app '
        'reads German', (tester) async {
      server.survey = const LotseSurvey(
        id: 11,
        kind: LotseSurveyKind.nps,
        question: 'Q',
        askComment: true,
        commentPrompt: 'What should we change?',
      );
      await surveys.check();
      await pump(tester, locale: const Locale('de'));
      expect(find.text('Unwahrscheinlich'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('lotse-survey-score-8')));
      await tester.pump();
      expect(find.text('What should we change?'), findsOneWidget);
      expect(find.text('Überspringen'), findsOneWidget);
      await tester.tap(find.text('Überspringen'));
      await tester.pump();
      expect(server.answers, ['11 8 null null']);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('closing the card dismisses the survey', (tester) async {
      server.survey = _nps;
      await surveys.check();
      await pump(tester);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      expect(find.text('Would you recommend Nook?'), findsNothing);
      expect(server.events, ['survey_view 7', 'survey_dismiss 7']);
    });

    testWidgets('a failed answer offers to send again', (tester) async {
      server.survey = _choice;
      server.answerError = Exception('offline');
      await surveys.check();
      await pump(tester);
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(find.text('Your answer could not be sent.'), findsOneWidget);
      server.answerError = null;
      await tester.tap(find.text('Try again'));
      await tester.pump();
      expect(server.answers, ['9 null 2 null']);
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('no survey comes while an in-app message is on screen, and '
        'the message shows instead', (tester) async {
      messages = [_message];
      server.survey = _nps;
      await inbox.check();
      await surveys.check(force: true);
      await pump(tester);
      expect(server.fetches, 0);
      expect(find.text('Spring sale'), findsOneWidget);
      expect(find.text('Would you recommend Nook?'), findsNothing);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();
      await surveys.check(force: true);
      await tester.pump();
      expect(find.text('Would you recommend Nook?'), findsOneWidget);
    });
  });
}

extension on LotseSurvey {
  LotseSurvey copyWithId(int id) => LotseSurvey(
    id: id,
    kind: kind,
    question: question,
    choices: choices,
    askComment: askComment,
    commentPrompt: commentPrompt,
  );
}

class _AnyMaterialLocalizations
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _AnyMaterialLocalizations();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultMaterialLocalizations());

  @override
  bool shouldReload(_AnyMaterialLocalizations old) => false;
}

class _AnyCupertinoLocalizations
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _AnyCupertinoLocalizations();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultCupertinoLocalizations());

  @override
  bool shouldReload(_AnyCupertinoLocalizations old) => false;
}
