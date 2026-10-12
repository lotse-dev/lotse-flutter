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

/// What one campaign achieved, from `AnalyticsEndpoint.campaignReport`.
/// Every figure counts deliveries, one per device of the audience.
abstract class CampaignReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CampaignReport._({
    required this.campaignId,
    required this.recipients,
    required this.sent,
    required this.opened,
    required this.matured,
    this.goalEvent,
    this.goal,
    this.openedGoal,
    required this.eventNames,
    required this.measuredAt,
  });

  factory CampaignReport({
    required int campaignId,
    required int recipients,
    required int sent,
    required int opened,
    required int matured,
    String? goalEvent,
    int? goal,
    int? openedGoal,
    required List<String> eventNames,
    required DateTime measuredAt,
  }) = _CampaignReportImpl;

  factory CampaignReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CampaignReport(
      campaignId: jsonSerialization['campaignId'] as int,
      recipients: jsonSerialization['recipients'] as int,
      sent: jsonSerialization['sent'] as int,
      opened: jsonSerialization['opened'] as int,
      matured: jsonSerialization['matured'] as int,
      goalEvent: jsonSerialization['goalEvent'] as String?,
      goal: jsonSerialization['goal'] as int?,
      openedGoal: jsonSerialization['openedGoal'] as int?,
      eventNames: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['eventNames'],
      ),
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
    );
  }

  int campaignId;

  /// Deliveries of the campaign, whatever became of them.
  int recipients;

  /// Deliveries FCM or APNs accepted. Neither reports delivery to the device,
  /// so this is as far as "delivered" can be measured.
  int sent;

  /// Sent deliveries whose device reported push_open for this campaign.
  int opened;

  /// Sent deliveries whose 24 hours for the goal are over.
  int matured;

  /// The goal event the last two figures count, null for none.
  String? goalEvent;

  /// Matured deliveries whose device tracked goalEvent within 24 hours of
  /// the send. Null without a goal event.
  int? goal;

  /// Of those, the ones that opened the push as well.
  int? openedGoal;

  /// Suggestions for the goal: the event names of the project's devices in
  /// the last 30 days, most frequent first.
  List<String> eventNames;

  DateTime measuredAt;

  /// Returns a shallow copy of this [CampaignReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CampaignReport copyWith({
    int? campaignId,
    int? recipients,
    int? sent,
    int? opened,
    int? matured,
    String? goalEvent,
    int? goal,
    int? openedGoal,
    List<String>? eventNames,
    DateTime? measuredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CampaignReport',
      'campaignId': campaignId,
      'recipients': recipients,
      'sent': sent,
      'opened': opened,
      'matured': matured,
      if (goalEvent != null) 'goalEvent': goalEvent,
      if (goal != null) 'goal': goal,
      if (openedGoal != null) 'openedGoal': openedGoal,
      'eventNames': eventNames.toJson(),
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CampaignReport',
      'campaignId': campaignId,
      'recipients': recipients,
      'sent': sent,
      'opened': opened,
      'matured': matured,
      if (goalEvent != null) 'goalEvent': goalEvent,
      if (goal != null) 'goal': goal,
      if (openedGoal != null) 'openedGoal': openedGoal,
      'eventNames': eventNames.toJson(),
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampaignReportImpl extends CampaignReport {
  _CampaignReportImpl({
    required int campaignId,
    required int recipients,
    required int sent,
    required int opened,
    required int matured,
    String? goalEvent,
    int? goal,
    int? openedGoal,
    required List<String> eventNames,
    required DateTime measuredAt,
  }) : super._(
         campaignId: campaignId,
         recipients: recipients,
         sent: sent,
         opened: opened,
         matured: matured,
         goalEvent: goalEvent,
         goal: goal,
         openedGoal: openedGoal,
         eventNames: eventNames,
         measuredAt: measuredAt,
       );

  /// Returns a shallow copy of this [CampaignReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CampaignReport copyWith({
    int? campaignId,
    int? recipients,
    int? sent,
    int? opened,
    int? matured,
    Object? goalEvent = _Undefined,
    Object? goal = _Undefined,
    Object? openedGoal = _Undefined,
    List<String>? eventNames,
    DateTime? measuredAt,
  }) {
    return CampaignReport(
      campaignId: campaignId ?? this.campaignId,
      recipients: recipients ?? this.recipients,
      sent: sent ?? this.sent,
      opened: opened ?? this.opened,
      matured: matured ?? this.matured,
      goalEvent: goalEvent is String? ? goalEvent : this.goalEvent,
      goal: goal is int? ? goal : this.goal,
      openedGoal: openedGoal is int? ? openedGoal : this.openedGoal,
      eventNames: eventNames ?? this.eventNames.map((e0) => e0).toList(),
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }
}
