import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/lotse.dart';
import 'package:lotse/src/lotse_feature_board.dart';
import 'package:lotse/src/lotse_feature_board_page.dart';

LotseFeatureIdea _idea(
  int id,
  String title, {
  String description = '',
  LotseFeatureStatus status = LotseFeatureStatus.open,
  int votes = 0,
  bool voted = false,
}) => LotseFeatureIdea(
  id: id,
  title: title,
  description: description,
  status: status,
  voteCount: votes,
  hasVoted: voted,
);

/// The board of the server in memory. With [hold] set a vote waits until the
/// test lets it through.
class _FakeBoard implements LotseFeatureBoard {
  _FakeBoard([this.stored = const []]);

  List<LotseFeatureIdea> stored;
  bool failing = false;
  LotseVoteResult voteAnswer = LotseVoteResult.done;
  Completer<void>? hold;
  int loads = 0;
  final votes = <(int, bool)>[];

  @override
  Future<List<LotseFeatureIdea>?> ideas() async {
    loads++;
    return failing ? null : [...stored];
  }

  @override
  Future<(LotseVoteResult, LotseFeatureIdea?)> setVote(
    int id, {
    required bool voted,
  }) async {
    votes.add((id, voted));
    await hold?.future;
    if (voteAnswer != LotseVoteResult.done) return (voteAnswer, null);
    final after = stored
        .firstWhere((idea) => idea.id == id)
        .withVote(voted: voted);
    stored = [
      for (final current in stored)
        if (current.id == id) after else current,
    ];
    return (LotseVoteResult.done, after);
  }
}

Widget _app(_FakeBoard board, {LotseFeedbackTexts? texts, Locale? locale}) =>
    MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => showLotseFeatureBoard(
              context,
              board: board,
              texts:
                  texts ??
                  (locale == null
                      ? null
                      : LotseFeedbackTexts.forLocale(locale)),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

Future<void> _showTab(WidgetTester tester, String label) async {
  await tester.tap(find.widgetWithText(Tab, label));
  await tester.pumpAndSettle();
}

/// The count inside the vote button of the idea, found by its tooltip.
Finder _count(String tooltip, int count) =>
    find.descendant(of: find.byTooltip(tooltip), matching: find.text('$count'));

void main() {
  const texts = LotseFeedbackTexts.english;

  group('Given a board with ideas', () {
    late _FakeBoard board;

    setUp(() {
      board = _FakeBoard([
        _idea(1, 'Dark mode', description: 'Easy on the eyes.', votes: 9),
        _idea(2, 'CSV export', status: LotseFeatureStatus.planned, votes: 4),
        _idea(3, 'Widgets', votes: 2, voted: true),
        _idea(4, 'Offline mode', status: LotseFeatureStatus.inProgress),
        _idea(5, 'Search', status: LotseFeatureStatus.shipped, votes: 30),
      ]);
    });

    testWidgets('when the screen is narrow then no tab label is cut', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_app(board));
      await _open(tester);

      for (final label in [
        texts.featureTabIdeas,
        texts.featureTabPlanned,
        texts.featureTabInProgress,
        texts.featureTabShipped,
      ]) {
        final paragraph = tester.renderObject<RenderParagraph>(
          find.descendant(
            of: find.widgetWithText(Tab, label),
            matching: find.byType(RichText),
          ),
        );
        expect(
          paragraph.size.width,
          greaterThanOrEqualTo(paragraph.getMaxIntrinsicWidth(double.infinity)),
          reason: label,
        );
      }
    });

    testWidgets('when the board is opened then the four tabs are there '
        'and the first one shows the open ideas with their votes', (
      tester,
    ) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);

      expect(find.text(texts.featureBoardTitle), findsOneWidget);
      for (final label in [
        texts.featureTabIdeas,
        texts.featureTabPlanned,
        texts.featureTabInProgress,
        texts.featureTabShipped,
      ]) {
        expect(find.widgetWithText(Tab, label), findsOneWidget);
      }
      expect(find.text('Dark mode'), findsOneWidget);
      expect(find.text('Easy on the eyes.'), findsOneWidget);
      expect(find.text('Widgets'), findsOneWidget);
      expect(find.text('CSV export'), findsNothing);
      expect(_count(texts.featureVote, 9), findsOneWidget);
      expect(_count(texts.featureUnvote, 2), findsOneWidget);
    });

    testWidgets('when another tab is picked then it shows its ideas', (
      tester,
    ) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await _showTab(tester, texts.featureTabPlanned);
      expect(find.text('CSV export'), findsOneWidget);
      expect(find.text('Dark mode'), findsNothing);

      await _showTab(tester, texts.featureTabInProgress);
      expect(find.text('Offline mode'), findsOneWidget);

      await _showTab(tester, texts.featureTabShipped);
      expect(find.text('Search'), findsOneWidget);
      expect(_count(texts.featureVote, 30), findsOneWidget);
    });

    testWidgets('when the user votes then the count moves at once, '
        'before the server has answered', (tester) async {
      board.hold = Completer();
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pump();

      expect(_count(texts.featureUnvote, 10), findsOneWidget);
      expect(board.votes, [(1, true)]);

      board.hold!.complete();
      await tester.pumpAndSettle();

      expect(_count(texts.featureUnvote, 10), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('when the user taps an idea voted for '
        'then the vote is taken back', (tester) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureUnvote, 2));
      await tester.pumpAndSettle();

      expect(board.votes, [(3, false)]);
      expect(_count(texts.featureVote, 1), findsOneWidget);
      expect(find.byTooltip(texts.featureUnvote), findsNothing);
    });

    testWidgets('when the server does not take the vote '
        'then it is taken back on screen with a message', (tester) async {
      board
        ..voteAnswer = LotseVoteResult.failed
        ..hold = Completer();
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pump();
      expect(_count(texts.featureUnvote, 10), findsOneWidget);

      board.hold!.complete();
      await tester.pumpAndSettle();

      expect(_count(texts.featureVote, 9), findsOneWidget);
      // Only the idea that was voted for before.
      expect(find.byTooltip(texts.featureUnvote), findsOneWidget);
      expect(find.text(texts.featureVoteFailed), findsOneWidget);
    });

    testWidgets('when the same vote fails twice '
        'then the message shows again', (tester) async {
      board.voteAnswer = LotseVoteResult.failed;
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pumpAndSettle();
      expect(find.text(texts.featureVoteFailed), findsOneWidget);
      // The message has had its time.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(find.text(texts.featureVoteFailed), findsNothing);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pumpAndSettle();
      expect(find.text(texts.featureVoteFailed), findsOneWidget);
    });

    testWidgets('when the vote quota is used up then the message says so', (
      tester,
    ) async {
      board.voteAnswer = LotseVoteResult.limitReached;
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pumpAndSettle();

      expect(find.text(texts.featureVoteLimitReached), findsOneWidget);
      expect(_count(texts.featureVote, 9), findsOneWidget);
    });

    testWidgets('when the idea is gone then it leaves the tab '
        'and the message says so', (tester) async {
      board.voteAnswer = LotseVoteResult.gone;
      await tester.pumpWidget(_app(board));
      await _open(tester);

      await tester.tap(_count(texts.featureVote, 9));
      await tester.pumpAndSettle();

      expect(find.text('Dark mode'), findsNothing);
      expect(find.text('Widgets'), findsOneWidget);
      expect(find.text(texts.featureGone), findsOneWidget);
    });

    testWidgets('when the user leaves after a failed vote '
        'then the message does not follow into the app', (tester) async {
      board.voteAnswer = LotseVoteResult.failed;
      await tester.pumpWidget(_app(board));
      await _open(tester);
      await tester.tap(_count(texts.featureVote, 9));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.text('open'), findsOneWidget);
      expect(find.text(texts.featureVoteFailed), findsNothing);
    });

    testWidgets('when the user pulls a tab down '
        'then the board is loaded again', (tester) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);
      expect(board.loads, 1);
      board.stored = [
        _idea(6, 'Tablet layout', votes: 1),
        _idea(1, 'Dark mode', status: LotseFeatureStatus.planned, votes: 9),
      ];

      await tester.fling(find.text('Dark mode'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(board.loads, 2);
      expect(find.text('Tablet layout'), findsOneWidget);
      expect(find.text('Dark mode'), findsNothing);
      await _showTab(tester, texts.featureTabPlanned);
      expect(find.text('Dark mode'), findsOneWidget);
    });

    testWidgets('when a reload fails then the ideas stay', (tester) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);
      board.failing = true;

      await tester.fling(find.text('Dark mode'), const Offset(0, 400), 1000);
      await tester.pumpAndSettle();

      expect(board.loads, 2);
      expect(find.text('Dark mode'), findsOneWidget);
      expect(find.text(texts.loadFailed), findsNothing);
    });

    testWidgets('when an idea has no description then only its title shows', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeBoard([_idea(1, 'Dark mode')])));
      await _open(tester);

      expect(find.text('Dark mode'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(TabBarView),
          matching: find.byType(Text),
        ),
        // The title and the count.
        findsNWidgets(2),
      );
    });

    testWidgets('when the board is open then nothing lets the user '
        'hand in an idea', (tester) async {
      await tester.pumpWidget(_app(board));
      await _open(tester);

      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(TextField), findsNothing);
    });
  });

  group('Given a board without ideas', () {
    testWidgets('when a tab is empty then it says so in its own words', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeBoard()));
      await _open(tester);

      expect(find.text(texts.featureEmptyIdeas), findsOneWidget);
      await _showTab(tester, texts.featureTabPlanned);
      expect(find.text(texts.featureEmptyPlanned), findsOneWidget);
      await _showTab(tester, texts.featureTabInProgress);
      expect(find.text(texts.featureEmptyInProgress), findsOneWidget);
      await _showTab(tester, texts.featureTabShipped);
      expect(find.text(texts.featureEmptyShipped), findsOneWidget);
    });

    testWidgets('when an empty tab is pulled down '
        'then the board is loaded again', (tester) async {
      final board = _FakeBoard();
      await tester.pumpWidget(_app(board));
      await _open(tester);
      board.stored = [_idea(1, 'Dark mode')];

      await tester.fling(
        find.text(texts.featureEmptyIdeas),
        const Offset(0, 400),
        1000,
      );
      await tester.pumpAndSettle();

      expect(board.loads, 2);
      expect(find.text('Dark mode'), findsOneWidget);
      expect(find.text(texts.featureEmptyIdeas), findsNothing);
    });

    testWidgets('when only one tab has ideas then the others are empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _FakeBoard([_idea(1, 'Search', status: LotseFeatureStatus.shipped)]),
        ),
      );
      await _open(tester);

      expect(find.text(texts.featureEmptyIdeas), findsOneWidget);
      await _showTab(tester, texts.featureTabShipped);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text(texts.featureEmptyShipped), findsNothing);
    });
  });

  group('Given a board that cannot be loaded', () {
    testWidgets('when loading fails then retry loads the board', (
      tester,
    ) async {
      final board = _FakeBoard([_idea(1, 'Dark mode')])..failing = true;
      await tester.pumpWidget(_app(board));
      await _open(tester);

      expect(find.text(texts.loadFailed), findsOneWidget);
      expect(find.text('Dark mode'), findsNothing);

      board.failing = false;
      await tester.tap(find.text(texts.retry));
      await tester.pumpAndSettle();

      expect(find.text(texts.loadFailed), findsNothing);
      expect(find.text('Dark mode'), findsOneWidget);
    });
  });

  group('Given the texts of the feature board', () {
    testWidgets('when the texts are German then the board is German', (
      tester,
    ) async {
      await tester.pumpWidget(_app(_FakeBoard(), locale: const Locale('de')));
      await _open(tester);

      const german = LotseFeedbackTexts.german;
      expect(find.text(german.featureBoardTitle), findsOneWidget);
      expect(
        find.widgetWithText(Tab, german.featureTabShipped),
        findsOneWidget,
      );
      expect(find.text(german.featureEmptyIdeas), findsOneWidget);
    });

    testWidgets('when an app passes its own texts then they are shown', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _FakeBoard(),
          texts: texts.copyWith(
            featureBoardTitle: 'Roadmap',
            featureTabIdeas: 'Vote',
            featureEmptyIdeas: 'Nothing here.',
          ),
        ),
      );
      await _open(tester);

      expect(find.text('Roadmap'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Vote'), findsOneWidget);
      expect(find.text('Nothing here.'), findsOneWidget);
    });

    test('when an app overrides the texts of the feature board '
        'then each one lands in its own field', () {
      final custom = texts.copyWith(
        featureBoardTitle: 'a',
        featureTabIdeas: 'b',
        featureTabPlanned: 'c',
        featureTabInProgress: 'd',
        featureTabShipped: 'e',
        featureEmptyIdeas: 'f',
        featureEmptyPlanned: 'g',
        featureEmptyInProgress: 'h',
        featureEmptyShipped: 'i',
        featureVote: 'j',
        featureUnvote: 'k',
        featureVoteFailed: 'l',
        featureVoteLimitReached: 'm',
        featureGone: 'n',
      );

      expect(
        [
          custom.featureBoardTitle,
          custom.featureTabIdeas,
          custom.featureTabPlanned,
          custom.featureTabInProgress,
          custom.featureTabShipped,
          custom.featureEmptyIdeas,
          custom.featureEmptyPlanned,
          custom.featureEmptyInProgress,
          custom.featureEmptyShipped,
          custom.featureVote,
          custom.featureUnvote,
          custom.featureVoteFailed,
          custom.featureVoteLimitReached,
          custom.featureGone,
        ],
        ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n'],
      );
      expect(custom.supportChatTitle, texts.supportChatTitle);
    });

    test('when the feature board is shown in German '
        'then no text is left in English', () {
      const german = LotseFeedbackTexts.german;

      expect(german.featureBoardTitle, isNot(texts.featureBoardTitle));
      expect(german.featureTabIdeas, isNot(texts.featureTabIdeas));
      expect(german.featureTabPlanned, isNot(texts.featureTabPlanned));
      expect(german.featureTabInProgress, isNot(texts.featureTabInProgress));
      expect(german.featureTabShipped, isNot(texts.featureTabShipped));
      expect(german.featureEmptyIdeas, isNot(texts.featureEmptyIdeas));
      expect(german.featureEmptyPlanned, isNot(texts.featureEmptyPlanned));
      expect(
        german.featureEmptyInProgress,
        isNot(texts.featureEmptyInProgress),
      );
      expect(german.featureEmptyShipped, isNot(texts.featureEmptyShipped));
      expect(german.featureVote, isNot(texts.featureVote));
      expect(german.featureUnvote, isNot(texts.featureUnvote));
      expect(german.featureVoteFailed, isNot(texts.featureVoteFailed));
      expect(
        german.featureVoteLimitReached,
        isNot(texts.featureVoteLimitReached),
      );
      expect(german.featureGone, isNot(texts.featureGone));
    });
  });
}
