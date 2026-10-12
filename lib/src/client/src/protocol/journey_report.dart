/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:lotse/src/client/src/protocol/protocol.dart' as _ist2d7e6;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'journey_group.dart' as _ihadhz3u;

/// What one journey achieved, from `AnalyticsEndpoint.journeyReport`. See
/// docs/JOURNEYS.md, section "Report".
abstract class JourneyReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyReport._({
    required this.journeyId,
    required this.waiting,
    required this.knownUser,
    required this.goalReached,
    required this.notInAudience,
    required this.unreachable,
    required this.budget,
    required this.groups,
    required this.sinceWinner,
    this.chanceBBeatsA,
    required this.maturedNeeded,
    this.decidableFrom,
    required this.holdoutLeads,
    required this.measuredAt,
  });

  factory JourneyReport({
    required int journeyId,
    required int waiting,
    required int knownUser,
    required int goalReached,
    required int notInAudience,
    required int unreachable,
    required int budget,
    required List<_ihadhz3u.JourneyGroup> groups,
    required List<_ihadhz3u.JourneyGroup> sinceWinner,
    double? chanceBBeatsA,
    required int maturedNeeded,
    DateTime? decidableFrom,
    required bool holdoutLeads,
    required DateTime measuredAt,
  }) = _JourneyReportImpl;

  factory JourneyReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyReport(
      journeyId: jsonSerialization['journeyId'] as int,
      waiting: jsonSerialization['waiting'] as int,
      knownUser: jsonSerialization['knownUser'] as int,
      goalReached: jsonSerialization['goalReached'] as int,
      notInAudience: jsonSerialization['notInAudience'] as int,
      unreachable: jsonSerialization['unreachable'] as int,
      budget: jsonSerialization['budget'] as int,
      groups: _ist2d7e6.Protocol().deserialize<List<_ihadhz3u.JourneyGroup>>(
        jsonSerialization['groups'],
      ),
      sinceWinner: _ist2d7e6.Protocol()
          .deserialize<List<_ihadhz3u.JourneyGroup>>(
            jsonSerialization['sinceWinner'],
          ),
      chanceBBeatsA: (jsonSerialization['chanceBBeatsA'] as num?)?.toDouble(),
      maturedNeeded: jsonSerialization['maturedNeeded'] as int,
      decidableFrom: jsonSerialization['decidableFrom'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['decidableFrom'],
            ),
      holdoutLeads: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['holdoutLeads'],
      ),
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
    );
  }

  int journeyId;

  /// Devices whose wait runs or that wait for the next scan.
  int waiting;

  /// Devices that left before the assignment, by reason.
  int knownUser;

  int goalReached;

  int notInAudience;

  int unreachable;

  int budget;

  /// The groups during the test: decided before winnerAt, or all while
  /// there is no winner. A, B, then the holdout; groups without devices
  /// included.
  List<_ihadhz3u.JourneyGroup> groups;

  /// The groups decided since winnerAt. Empty without a winner.
  List<_ihadhz3u.JourneyGroup> sinceWinner;

  /// Chance that B reaches the goal more often than A, from the matured
  /// devices of the test. Null with one variant.
  double? chanceBBeatsA;

  /// Matured devices each variant needs before a winner is picked.
  int maturedNeeded;

  /// Earliest time a winner is picked automatically. Null before the start.
  DateTime? decidableFrom;

  /// Whether the holdout reaches the goal more often than every variant.
  /// Then no winner is picked automatically.
  bool holdoutLeads;

  DateTime measuredAt;

  /// Returns a shallow copy of this [JourneyReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyReport copyWith({
    int? journeyId,
    int? waiting,
    int? knownUser,
    int? goalReached,
    int? notInAudience,
    int? unreachable,
    int? budget,
    List<_ihadhz3u.JourneyGroup>? groups,
    List<_ihadhz3u.JourneyGroup>? sinceWinner,
    double? chanceBBeatsA,
    int? maturedNeeded,
    DateTime? decidableFrom,
    bool? holdoutLeads,
    DateTime? measuredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyReport',
      'journeyId': journeyId,
      'waiting': waiting,
      'knownUser': knownUser,
      'goalReached': goalReached,
      'notInAudience': notInAudience,
      'unreachable': unreachable,
      'budget': budget,
      'groups': groups.toJson(valueToJson: (v) => v.toJson()),
      'sinceWinner': sinceWinner.toJson(valueToJson: (v) => v.toJson()),
      if (chanceBBeatsA != null) 'chanceBBeatsA': chanceBBeatsA,
      'maturedNeeded': maturedNeeded,
      if (decidableFrom != null) 'decidableFrom': decidableFrom?.toJson(),
      'holdoutLeads': holdoutLeads,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyReport',
      'journeyId': journeyId,
      'waiting': waiting,
      'knownUser': knownUser,
      'goalReached': goalReached,
      'notInAudience': notInAudience,
      'unreachable': unreachable,
      'budget': budget,
      'groups': groups.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'sinceWinner': sinceWinner.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (chanceBBeatsA != null) 'chanceBBeatsA': chanceBBeatsA,
      'maturedNeeded': maturedNeeded,
      if (decidableFrom != null) 'decidableFrom': decidableFrom?.toJson(),
      'holdoutLeads': holdoutLeads,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyReportImpl extends JourneyReport {
  _JourneyReportImpl({
    required int journeyId,
    required int waiting,
    required int knownUser,
    required int goalReached,
    required int notInAudience,
    required int unreachable,
    required int budget,
    required List<_ihadhz3u.JourneyGroup> groups,
    required List<_ihadhz3u.JourneyGroup> sinceWinner,
    double? chanceBBeatsA,
    required int maturedNeeded,
    DateTime? decidableFrom,
    required bool holdoutLeads,
    required DateTime measuredAt,
  }) : super._(
         journeyId: journeyId,
         waiting: waiting,
         knownUser: knownUser,
         goalReached: goalReached,
         notInAudience: notInAudience,
         unreachable: unreachable,
         budget: budget,
         groups: groups,
         sinceWinner: sinceWinner,
         chanceBBeatsA: chanceBBeatsA,
         maturedNeeded: maturedNeeded,
         decidableFrom: decidableFrom,
         holdoutLeads: holdoutLeads,
         measuredAt: measuredAt,
       );

  /// Returns a shallow copy of this [JourneyReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyReport copyWith({
    int? journeyId,
    int? waiting,
    int? knownUser,
    int? goalReached,
    int? notInAudience,
    int? unreachable,
    int? budget,
    List<_ihadhz3u.JourneyGroup>? groups,
    List<_ihadhz3u.JourneyGroup>? sinceWinner,
    Object? chanceBBeatsA = _Undefined,
    int? maturedNeeded,
    Object? decidableFrom = _Undefined,
    bool? holdoutLeads,
    DateTime? measuredAt,
  }) {
    return JourneyReport(
      journeyId: journeyId ?? this.journeyId,
      waiting: waiting ?? this.waiting,
      knownUser: knownUser ?? this.knownUser,
      goalReached: goalReached ?? this.goalReached,
      notInAudience: notInAudience ?? this.notInAudience,
      unreachable: unreachable ?? this.unreachable,
      budget: budget ?? this.budget,
      groups: groups ?? this.groups.map((e0) => e0.copyWith()).toList(),
      sinceWinner:
          sinceWinner ?? this.sinceWinner.map((e0) => e0.copyWith()).toList(),
      chanceBBeatsA: chanceBBeatsA is double?
          ? chanceBBeatsA
          : this.chanceBBeatsA,
      maturedNeeded: maturedNeeded ?? this.maturedNeeded,
      decidableFrom: decidableFrom is DateTime?
          ? decidableFrom
          : this.decidableFrom,
      holdoutLeads: holdoutLeads ?? this.holdoutLeads,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }
}
