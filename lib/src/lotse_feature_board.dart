import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

import 'lotse_my_feedback.dart';

/// Where an idea stands, which is also the tab it shows up in. Archived ideas
/// never reach a device.
enum LotseFeatureStatus {
  /// Up for votes, nothing decided yet.
  open,

  /// The team intends to build it.
  planned,

  /// The team is building it.
  inProgress,

  /// It is in the app.
  shipped,
}

/// An idea of the team on the feature board as this device sees it.
@immutable
class LotseFeatureIdea {
  /// Creates an idea.
  const LotseFeatureIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.voteCount,
    required this.hasVoted,
  });

  /// Identifies the idea when voting.
  final int id;

  /// The one line that names the idea.
  final String title;

  /// What the idea is about, possibly empty.
  final String description;

  /// Where the idea stands.
  final LotseFeatureStatus status;

  /// How many devices voted for it.
  final int voteCount;

  /// Whether this device voted for it.
  final bool hasVoted;

  /// The idea with the vote of this device set to [voted] and the count
  /// moved along. Unchanged if the vote already stands like that.
  LotseFeatureIdea withVote({required bool voted}) {
    if (voted == hasVoted) return this;
    final count = voteCount + (voted ? 1 : -1);
    return LotseFeatureIdea(
      id: id,
      title: title,
      description: description,
      status: status,
      // A stale count of zero with a vote of this device must not go negative.
      voteCount: count < 0 ? 0 : count,
      hasVoted: voted,
    );
  }
}

/// How an attempt to vote or to take a vote back ended.
enum LotseVoteResult {
  /// The server took it.
  done,

  /// The idea is not on the board any more: archived or merged into another.
  gone,

  /// The vote quota of the device is used up. Trying again right away will
  /// not help.
  limitReached,

  /// Anything else: no network, a server error.
  failed,
}

/// The feature board as this device sees it. No method throws.
abstract interface class LotseFeatureBoard {
  /// Every idea on the board, most votes first, `null` if the call failed.
  Future<List<LotseFeatureIdea>?> ideas();

  /// Votes for the idea [id] or takes the vote back. The idea as the server
  /// has it afterwards is set when the result is [LotseVoteResult.done].
  Future<(LotseVoteResult, LotseFeatureIdea?)> setVote(
    int id, {
    required bool voted,
  });
}

/// The status of the SDK for [status], `null` for one a device does not see.
LotseFeatureStatus? lotseFeatureStatus(generated.FeatureRequestStatus status) =>
    switch (status) {
      generated.FeatureRequestStatus.open => LotseFeatureStatus.open,
      generated.FeatureRequestStatus.planned => LotseFeatureStatus.planned,
      generated.FeatureRequestStatus.inProgress =>
        LotseFeatureStatus.inProgress,
      generated.FeatureRequestStatus.shipped => LotseFeatureStatus.shipped,
      generated.FeatureRequestStatus.archived => null,
    };

LotseFeatureIdea? _idea(generated.FeatureBoardItem item) {
  final status = lotseFeatureStatus(item.status);
  if (status == null) return null;
  return LotseFeatureIdea(
    id: item.id,
    title: item.title,
    description: item.description,
    status: status,
    voteCount: item.voteCount,
    hasVoted: item.hasVoted,
  );
}

/// [LotseFeatureBoard] on the generated client. The calls come in as
/// functions, so the mapping can be tested without a server.
///
/// Failures are logged with their kind only.
class ServerLotseFeatureBoard implements LotseFeatureBoard {
  /// Creates the board of the device [installId].
  ServerLotseFeatureBoard({
    required this.installId,
    required Future<List<generated.FeatureBoardItem>> Function(
      String installId, {
      generated.FeatureRequestStatus? status,
    })
    listFeatureRequests,
    required Future<generated.FeatureBoardItem> Function(
      String installId,
      int featureRequestId,
    )
    voteFeature,
    required Future<generated.FeatureBoardItem> Function(
      String installId,
      int featureRequestId,
    )
    unvoteFeature,
  }) : _list = listFeatureRequests,
       _vote = voteFeature,
       _unvote = unvoteFeature;

  /// Identifies this install.
  final String installId;

  final Future<List<generated.FeatureBoardItem>> Function(
    String, {
    generated.FeatureRequestStatus? status,
  })
  _list;
  final Future<generated.FeatureBoardItem> Function(String, int) _vote;
  final Future<generated.FeatureBoardItem> Function(String, int) _unvote;

  @override
  Future<List<LotseFeatureIdea>?> ideas() async {
    try {
      // One call for all tabs: the board is small, and a pull on one tab
      // refreshes the others with it.
      final items = await _list(installId);
      return [for (final item in items) ?_idea(item)];
    } catch (error) {
      debugPrint(
        'Lotse: could not load the feature board: ${error.runtimeType}',
      );
      return null;
    }
  }

  @override
  Future<(LotseVoteResult, LotseFeatureIdea?)> setVote(
    int id, {
    required bool voted,
  }) async {
    try {
      final item = await (voted ? _vote : _unvote)(installId, id);
      final idea = _idea(item);
      // Archived between the vote and the answer: as good as gone.
      if (idea == null) return (LotseVoteResult.gone, null);
      return (LotseVoteResult.done, idea);
    } on generated.LotseNotFoundException {
      debugPrint('Lotse: the idea is not on the board any more.');
      return (LotseVoteResult.gone, null);
    } on generated.LotseQuotaExceededException {
      debugPrint('Lotse: the vote quota is used up.');
      return (LotseVoteResult.limitReached, null);
    } catch (error) {
      debugPrint('Lotse: could not store the vote: ${error.runtimeType}');
      return (LotseVoteResult.failed, null);
    }
  }
}

/// The state of the feature board: the ideas, loading and voting. Plain Dart,
/// the page only renders it.
///
/// A vote shows at once and is taken back if the server does not take it.
class LotseFeatureBoardController extends ChangeNotifier {
  /// Creates the state on [_board].
  LotseFeatureBoardController(this._board);

  final LotseFeatureBoard _board;
  bool _disposed = false;

  // What this device wants for the ideas whose vote is on its way. A list
  // that arrives in between may be older than the vote and must not undo it
  // on screen.
  final _pending = <int, bool>{};

  // Counts the votes the server has answered. A list that was on its way
  // while one was answered may be older than that answer.
  int _answeredVotes = 0;

  /// Whether the first answer of the server is there.
  LotseLoadStatus get status => _status;
  LotseLoadStatus _status = LotseLoadStatus.loading;

  /// Every idea on the board in the order of the server, most votes first. A
  /// vote does not reorder the list under the finger; the next load does.
  List<LotseFeatureIdea> get ideas => _ideas;
  List<LotseFeatureIdea> _ideas = const [];

  /// How the last vote failed, `null` if it did not.
  LotseVoteResult? get voteFailure => _voteFailure;
  LotseVoteResult? _voteFailure;

  /// The ideas of one tab.
  List<LotseFeatureIdea> ideasIn(LotseFeatureStatus status) => [
    for (final idea in _ideas)
      if (idea.status == status) idea,
  ];

  /// `true` while a vote for the idea [id] is on its way.
  bool isVoting(int id) => _pending.containsKey(id);

  /// Loads the board, also on pull to refresh. A failed reload keeps the
  /// ideas that are there.
  Future<void> load() async {
    List<LotseFeatureIdea>? list;
    int answeredBefore;
    do {
      answeredBefore = _answeredVotes;
      list = await _board.ideas();
      if (_disposed) return;
      // A vote was answered in between: the list may not know it and would
      // undo it on screen or bring an idea back that is gone. Every round
      // takes a tap of the user, so this ends.
    } while (list != null && answeredBefore != _answeredVotes);
    if (list != null) {
      _ideas = List.unmodifiable([
        for (final idea in list)
          idea.withVote(voted: _pending[idea.id] ?? idea.hasVoted),
      ]);
      _status = LotseLoadStatus.loaded;
    } else if (_status != LotseLoadStatus.loaded) {
      _status = LotseLoadStatus.failed;
    }
    notifyListeners();
  }

  /// Shows the spinner and loads again after a failed first load.
  Future<void> retry() {
    _status = LotseLoadStatus.loading;
    notifyListeners();
    return load();
  }

  /// Votes for the idea [id], or takes the vote back if this device has
  /// voted. Returns `true` if the server took it. Never throws.
  ///
  /// Does nothing while a vote for the same idea is on its way, so two quick
  /// taps cannot overtake each other.
  Future<bool> toggleVote(int id) async {
    final before = _find(id);
    if (before == null || isVoting(id)) return false;
    final voted = !before.hasVoted;
    _pending[id] = voted;
    _voteFailure = null;
    _replace(id, before.withVote(voted: voted));
    notifyListeners();

    final (result, idea) = await _board.setVote(id, voted: voted);
    if (_disposed) return false;
    _pending.remove(id);
    _answeredVotes++;
    switch (result) {
      case LotseVoteResult.done:
        _replace(id, idea);
      case LotseVoteResult.gone:
        _replace(id, null);
        _voteFailure = result;
      case LotseVoteResult.limitReached:
      case LotseVoteResult.failed:
        // Whatever list is there by now, the vote on it is the optimistic
        // one; taking that back is the state of the server.
        _replace(id, _find(id)?.withVote(voted: !voted));
        _voteFailure = result;
    }
    notifyListeners();
    return result == LotseVoteResult.done;
  }

  LotseFeatureIdea? _find(int id) {
    for (final idea in _ideas) {
      if (idea.id == id) return idea;
    }
    return null;
  }

  /// Puts [idea] where the idea [id] is, or drops that one for `null`.
  void _replace(int id, LotseFeatureIdea? idea) {
    _ideas = List.unmodifiable([
      for (final current in _ideas)
        if (current.id != id) current else ?idea,
    ]);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
