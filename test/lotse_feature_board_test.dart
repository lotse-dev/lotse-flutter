import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/lotse_feature_board.dart';
import 'package:lotse/src/lotse_my_feedback.dart';

LotseFeatureIdea _idea(
  int id, {
  LotseFeatureStatus status = LotseFeatureStatus.open,
  int votes = 0,
  bool voted = false,
}) => LotseFeatureIdea(
  id: id,
  title: 'Idea $id',
  description: 'About $id',
  status: status,
  voteCount: votes,
  hasVoted: voted,
);

/// A board in memory that answers like the server would. With [hold] set a
/// vote waits until the test lets it through, with [listHold] a list that is
/// already read does.
class _FakeBoard implements LotseFeatureBoard {
  _FakeBoard(this.stored);

  List<LotseFeatureIdea> stored;
  bool failing = false;
  LotseVoteResult voteAnswer = LotseVoteResult.done;
  Completer<void>? hold;
  Completer<void>? listHold;
  int lists = 0;
  final votes = <(int, bool)>[];

  @override
  Future<List<LotseFeatureIdea>?> ideas() async {
    lists++;
    final list = failing ? null : [...stored];
    final waiting = listHold;
    listHold = null;
    await waiting?.future;
    return list;
  }

  @override
  Future<(LotseVoteResult, LotseFeatureIdea?)> setVote(
    int id, {
    required bool voted,
  }) async {
    votes.add((id, voted));
    await hold?.future;
    if (voteAnswer != LotseVoteResult.done) return (voteAnswer, null);
    final idea = stored.firstWhere((idea) => idea.id == id);
    final after = idea.withVote(voted: voted);
    stored = [
      for (final current in stored)
        if (current.id == id) after else current,
    ];
    return (LotseVoteResult.done, after);
  }
}

generated.FeatureBoardItem _item(
  int id, {
  generated.FeatureRequestStatus status = generated.FeatureRequestStatus.open,
  int votes = 0,
  bool voted = false,
}) => generated.FeatureBoardItem(
  id: id,
  title: 'Idea $id',
  description: 'About $id',
  status: status,
  voteCount: votes,
  hasVoted: voted,
  createdAt: DateTime.utc(2026, 9, 1),
);

void main() {
  group('Given the generated feature board calls', () {
    late List<(String, int, bool)> calls;
    Object? voteError;

    ServerLotseFeatureBoard board({
      Future<List<generated.FeatureBoardItem>> Function(
        String installId, {
        generated.FeatureRequestStatus? status,
      })?
      list,
      generated.FeatureBoardItem Function(int id, bool voted)? answer,
    }) {
      Future<generated.FeatureBoardItem> call(
        String installId,
        int id,
        bool voted,
      ) async {
        calls.add((installId, id, voted));
        final error = voteError;
        if (error != null) throw error;
        return answer?.call(id, voted) ??
            _item(id, votes: voted ? 1 : 0, voted: voted);
      }

      return ServerLotseFeatureBoard(
        installId: 'install-1',
        listFeatureRequests: list ?? (installId, {status}) async => [],
        voteFeature: (installId, id) => call(installId, id, true),
        unvoteFeature: (installId, id) => call(installId, id, false),
      );
    }

    setUp(() {
      calls = [];
      voteError = null;
    });

    test(
      'when the board is loaded '
      'then all of it is asked for this install and mapped in order',
      () async {
        String? askedFor;
        generated.FeatureRequestStatus? askedStatus;
        final ideas = await board(
          list: (installId, {status}) async {
            askedFor = installId;
            askedStatus = status;
            return [
              _item(
                2,
                status: generated.FeatureRequestStatus.inProgress,
                votes: 5,
                voted: true,
              ),
              _item(1, status: generated.FeatureRequestStatus.shipped),
            ];
          },
        ).ideas();

        expect(askedFor, 'install-1');
        expect(askedStatus, isNull);
        expect(ideas!.map((idea) => idea.id), [2, 1]);
        expect(ideas.first.title, 'Idea 2');
        expect(ideas.first.description, 'About 2');
        expect(ideas.first.status, LotseFeatureStatus.inProgress);
        expect(ideas.first.voteCount, 5);
        expect(ideas.first.hasVoted, isTrue);
        expect(ideas.last.status, LotseFeatureStatus.shipped);
      },
    );

    test(
      'when the server sends an archived idea then it is left out',
      () async {
        final ideas = await board(
          list: (installId, {status}) async => [
            _item(1, status: generated.FeatureRequestStatus.archived),
            _item(2, status: generated.FeatureRequestStatus.planned),
          ],
        ).ideas();

        expect(ideas!.map((idea) => idea.id), [2]);
      },
    );

    test('when loading fails then null instead of an error', () async {
      final ideas = await board(
        list: (installId, {status}) async => throw Exception('offline'),
      ).ideas();

      expect(ideas, isNull);
    });

    test('when the device votes then voteFeature is called '
        'and the idea of the server comes back', () async {
      final (result, idea) = await board().setVote(3, voted: true);

      expect(calls, [('install-1', 3, true)]);
      expect(result, LotseVoteResult.done);
      expect(idea!.id, 3);
      expect(idea.voteCount, 1);
      expect(idea.hasVoted, isTrue);
    });

    test('when the device takes its vote back '
        'then unvoteFeature is called', () async {
      final (result, idea) = await board().setVote(3, voted: false);

      expect(calls, [('install-1', 3, false)]);
      expect(result, LotseVoteResult.done);
      expect(idea!.hasVoted, isFalse);
    });

    test('when the idea is not found then it is gone', () async {
      voteError = generated.LotseNotFoundException(message: 'Idea not found.');

      expect(await board().setVote(3, voted: true), (
        LotseVoteResult.gone,
        null,
      ));
    });

    test('when the idea was archived with the vote then it is gone', () async {
      final answer = await board(
        answer: (id, voted) =>
            _item(id, status: generated.FeatureRequestStatus.archived),
      ).setVote(3, voted: true);

      expect(answer, (LotseVoteResult.gone, null));
    });

    test('when the vote quota is used up then limitReached', () async {
      voteError = generated.LotseQuotaExceededException(
        message: 'full',
        resource: 'featureVotes',
        limit: 50,
      );

      expect(await board().setVote(3, voted: true), (
        LotseVoteResult.limitReached,
        null,
      ));
    });

    test('when anything else goes wrong then failed', () async {
      voteError = Exception('offline');

      expect(await board().setVote(3, voted: true), (
        LotseVoteResult.failed,
        null,
      ));
    });
  });

  group('Given an idea', () {
    test('when the vote is set then the count moves with it', () {
      final voted = _idea(1, votes: 4).withVote(voted: true);
      expect((voted.voteCount, voted.hasVoted), (5, true));

      final back = voted.withVote(voted: false);
      expect((back.voteCount, back.hasVoted), (4, false));
    });

    test('when the vote already stands like that then nothing changes', () {
      final idea = _idea(1, votes: 4, voted: true);

      expect(idea.withVote(voted: true), same(idea));
    });

    test('when a stale count is zero then taking the vote back '
        'does not go below zero', () {
      final back = _idea(1, voted: true).withVote(voted: false);

      expect(back.voteCount, 0);
    });
  });

  group('Given the feature board controller', () {
    late _FakeBoard board;
    late LotseFeatureBoardController controller;

    setUp(() {
      board = _FakeBoard([
        _idea(1, votes: 9),
        _idea(2, status: LotseFeatureStatus.planned, votes: 4, voted: true),
        _idea(3, votes: 2),
        _idea(4, status: LotseFeatureStatus.shipped),
      ]);
      controller = LotseFeatureBoardController(board);
      addTearDown(controller.dispose);
    });

    test('when it loads then the ideas are there, split by tab', () async {
      expect(controller.status, LotseLoadStatus.loading);

      await controller.load();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.ideas.map((idea) => idea.id), [1, 2, 3, 4]);
      expect(
        controller.ideasIn(LotseFeatureStatus.open).map((idea) => idea.id),
        [1, 3],
      );
      expect(
        controller.ideasIn(LotseFeatureStatus.planned).map((idea) => idea.id),
        [2],
      );
      expect(controller.ideasIn(LotseFeatureStatus.inProgress), isEmpty);
      expect(
        controller.ideasIn(LotseFeatureStatus.shipped).map((idea) => idea.id),
        [4],
      );
    });

    test('when the first load fails then failed, and retry loads', () async {
      board.failing = true;
      await controller.load();
      expect(controller.status, LotseLoadStatus.failed);

      board.failing = false;
      final retried = controller.retry();
      expect(controller.status, LotseLoadStatus.loading);
      await retried;

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.ideas, hasLength(4));
    });

    test('when a reload fails then the ideas that are there stay', () async {
      await controller.load();
      board.failing = true;

      await controller.load();

      expect(controller.status, LotseLoadStatus.loaded);
      expect(controller.ideas, hasLength(4));
    });

    test('when a reload succeeds then the board is the new one', () async {
      await controller.load();
      board.stored = [
        _idea(3, status: LotseFeatureStatus.inProgress, votes: 7),
      ];

      await controller.load();

      expect(controller.ideas.single.id, 3);
      expect(controller.ideas.single.status, LotseFeatureStatus.inProgress);
    });

    test('when the user votes then the vote shows before the server answers '
        'and stays after', () async {
      await controller.load();
      board.hold = Completer();
      var notified = 0;
      controller.addListener(() => notified++);

      final toggled = controller.toggleVote(1);

      expect(controller.ideas.first.hasVoted, isTrue);
      expect(controller.ideas.first.voteCount, 10);
      expect(controller.isVoting(1), isTrue);
      expect(notified, 1);

      board.hold!.complete();
      expect(await toggled, isTrue);

      expect(board.votes, [(1, true)]);
      expect(controller.ideas.first.hasVoted, isTrue);
      expect(controller.ideas.first.voteCount, 10);
      expect(controller.isVoting(1), isFalse);
      expect(controller.voteFailure, isNull);
      expect(notified, 2);
    });

    test(
      'when the user has voted then the toggle takes the vote back',
      () async {
        await controller.load();

        expect(await controller.toggleVote(2), isTrue);

        expect(board.votes, [(2, false)]);
        final idea = controller.ideasIn(LotseFeatureStatus.planned).single;
        expect((idea.voteCount, idea.hasVoted), (3, false));
      },
    );

    test('when the server counts differently '
        'then its count replaces the optimistic one', () async {
      await controller.load();
      // Someone else voted in the meantime.
      board.stored = [_idea(1, votes: 12), ...board.stored.skip(1)];

      await controller.toggleVote(1);

      expect(controller.ideas.first.voteCount, 13);
    });

    test('when the user votes '
        'then the list keeps its order until the next load', () async {
      await controller.load();
      board.stored = [
        _idea(3, votes: 20),
        ...board.stored.where((idea) => idea.id != 3),
      ];

      await controller.toggleVote(3);
      expect(controller.ideas.map((idea) => idea.id), [1, 2, 3, 4]);

      await controller.load();
      expect(controller.ideas.map((idea) => idea.id), [3, 1, 2, 4]);
    });

    for (final failure in [
      LotseVoteResult.failed,
      LotseVoteResult.limitReached,
    ]) {
      test('when a vote ends as ${failure.name} '
          'then it is taken back and the failure is kept', () async {
        await controller.load();
        board
          ..voteAnswer = failure
          ..hold = Completer();

        final toggled = controller.toggleVote(1);
        expect(controller.ideas.first.voteCount, 10);
        board.hold!.complete();

        expect(await toggled, isFalse);
        expect(controller.ideas.first.hasVoted, isFalse);
        expect(controller.ideas.first.voteCount, 9);
        expect(controller.isVoting(1), isFalse);
        expect(controller.voteFailure, failure);
      });
    }

    test(
      'when taking a vote back fails then the vote is there again',
      () async {
        await controller.load();
        board.voteAnswer = LotseVoteResult.failed;

        await controller.toggleVote(2);

        final idea = controller.ideasIn(LotseFeatureStatus.planned).single;
        expect((idea.voteCount, idea.hasVoted), (4, true));
      },
    );

    test('when the next vote starts then the old failure is gone', () async {
      await controller.load();
      board.voteAnswer = LotseVoteResult.failed;
      await controller.toggleVote(1);
      expect(controller.voteFailure, LotseVoteResult.failed);

      board.voteAnswer = LotseVoteResult.done;
      await controller.toggleVote(1);

      expect(controller.voteFailure, isNull);
      expect(controller.ideas.first.hasVoted, isTrue);
    });

    test('when the idea is gone then it leaves the board', () async {
      await controller.load();
      board.voteAnswer = LotseVoteResult.gone;

      expect(await controller.toggleVote(1), isFalse);

      expect(controller.ideas.map((idea) => idea.id), [2, 3, 4]);
      expect(controller.voteFailure, LotseVoteResult.gone);
    });

    test('when the user taps twice then only one vote goes out', () async {
      await controller.load();
      board.hold = Completer();

      final first = controller.toggleVote(1);
      expect(await controller.toggleVote(1), isFalse);
      board.hold!.complete();
      await first;

      expect(board.votes, [(1, true)]);
      expect(controller.ideas.first.voteCount, 10);
    });

    test('when votes for two ideas are on their way '
        'then each one ends on its own', () async {
      await controller.load();
      board.hold = Completer();

      final first = controller.toggleVote(1);
      final second = controller.toggleVote(3);
      expect(controller.isVoting(1) && controller.isVoting(3), isTrue);
      board.hold!.complete();

      expect(await first, isTrue);
      expect(await second, isTrue);
      expect(board.votes, [(1, true), (3, true)]);
      expect(
        controller.ideasIn(LotseFeatureStatus.open).map((i) => i.voteCount),
        [10, 3],
      );
    });

    test('when an idea is unknown then nothing goes out', () async {
      await controller.load();

      expect(await controller.toggleVote(99), isFalse);
      expect(board.votes, isEmpty);
    });

    test('when an older list arrives while a vote is on its way '
        'then the vote stays on screen', () async {
      await controller.load();
      board.hold = Completer();
      final toggled = controller.toggleVote(1);

      // The list of the server does not know the vote yet.
      await controller.load();
      expect(controller.ideas.first.hasVoted, isTrue);
      expect(controller.ideas.first.voteCount, 10);

      board.hold!.complete();
      await toggled;
      expect(controller.ideas.first.voteCount, 10);
    });

    test('when a list arrived while a vote that fails was on its way '
        'then the vote is still taken back', () async {
      await controller.load();
      board
        ..voteAnswer = LotseVoteResult.failed
        ..hold = Completer();
      final toggled = controller.toggleVote(1);
      await controller.load();

      board.hold!.complete();
      await toggled;

      expect(controller.ideas.first.hasVoted, isFalse);
      expect(controller.ideas.first.voteCount, 9);
    });

    test('when a list from before a vote arrives after its answer '
        'then the board is loaded again and the vote stays', () async {
      await controller.load();
      final listHold = board.listHold = Completer();
      final loading = controller.load();

      expect(await controller.toggleVote(1), isTrue);
      listHold.complete();
      await loading;

      expect(board.lists, 3);
      expect(controller.ideas.first.hasVoted, isTrue);
      expect(controller.ideas.first.voteCount, 10);
    });

    test('when a list from before a vote on an idea that is gone arrives '
        'after its answer then the idea stays away', () async {
      await controller.load();
      final listHold = board.listHold = Completer();
      final loading = controller.load();
      board.voteAnswer = LotseVoteResult.gone;
      await controller.toggleVote(1);
      board.stored = board.stored.sublist(1);
      listHold.complete();
      await loading;

      expect(controller.ideas.map((idea) => idea.id), [2, 3, 4]);
    });

    test('when it is disposed while loading or voting '
        'then nothing is notified', () async {
      final other = LotseFeatureBoardController(board);
      await other.load();
      board.hold = Completer();
      final toggled = other.toggleVote(1);
      final loading = other.load();
      other.dispose();
      board.hold!.complete();

      expect(await toggled, isFalse);
      await loading;
    });
  });
}
