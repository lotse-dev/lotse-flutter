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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'journey_arm.dart' as _i34jp9wz;

/// The figures of one group of a journey in the report. Every figure counts
/// devices that were assigned to the group.
abstract class JourneyGroup
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JourneyGroup._({
    required this.arm,
    this.campaignId,
    required this.assigned,
    required this.sent,
    required this.opened,
    required this.matured,
    required this.goal,
    this.chanceToBeatHoldout,
  });

  factory JourneyGroup({
    required _i34jp9wz.JourneyArm arm,
    int? campaignId,
    required int assigned,
    required int sent,
    required int opened,
    required int matured,
    required int goal,
    double? chanceToBeatHoldout,
  }) = _JourneyGroupImpl;

  factory JourneyGroup.fromJson(Map<String, dynamic> jsonSerialization) {
    return JourneyGroup(
      arm: _i34jp9wz.JourneyArm.fromJson((jsonSerialization['arm'] as String)),
      campaignId: jsonSerialization['campaignId'] as int?,
      assigned: jsonSerialization['assigned'] as int,
      sent: jsonSerialization['sent'] as int,
      opened: jsonSerialization['opened'] as int,
      matured: jsonSerialization['matured'] as int,
      goal: jsonSerialization['goal'] as int,
      chanceToBeatHoldout: (jsonSerialization['chanceToBeatHoldout'] as num?)
          ?.toDouble(),
    );
  }

  _i34jp9wz.JourneyArm arm;

  /// The campaign of the variant, null for the holdout.
  int? campaignId;

  int assigned;

  /// Of those, the ones whose push FCM or APNs accepted.
  int sent;

  /// Sent ones whose device reported push_open for the variant.
  int opened;

  /// Assigned ones whose measuring window is over.
  int matured;

  /// Matured ones that tracked the goal within the window after the
  /// decision, sent or not.
  int goal;

  /// Chance that this variant reaches the goal more often than the holdout.
  /// Null for the holdout itself, and without a holdout.
  double? chanceToBeatHoldout;

  /// Returns a shallow copy of this [JourneyGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JourneyGroup copyWith({
    _i34jp9wz.JourneyArm? arm,
    int? campaignId,
    int? assigned,
    int? sent,
    int? opened,
    int? matured,
    int? goal,
    double? chanceToBeatHoldout,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JourneyGroup',
      'arm': arm.toJson(),
      if (campaignId != null) 'campaignId': campaignId,
      'assigned': assigned,
      'sent': sent,
      'opened': opened,
      'matured': matured,
      'goal': goal,
      if (chanceToBeatHoldout != null)
        'chanceToBeatHoldout': chanceToBeatHoldout,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JourneyGroup',
      'arm': arm.toJson(),
      if (campaignId != null) 'campaignId': campaignId,
      'assigned': assigned,
      'sent': sent,
      'opened': opened,
      'matured': matured,
      'goal': goal,
      if (chanceToBeatHoldout != null)
        'chanceToBeatHoldout': chanceToBeatHoldout,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyGroupImpl extends JourneyGroup {
  _JourneyGroupImpl({
    required _i34jp9wz.JourneyArm arm,
    int? campaignId,
    required int assigned,
    required int sent,
    required int opened,
    required int matured,
    required int goal,
    double? chanceToBeatHoldout,
  }) : super._(
         arm: arm,
         campaignId: campaignId,
         assigned: assigned,
         sent: sent,
         opened: opened,
         matured: matured,
         goal: goal,
         chanceToBeatHoldout: chanceToBeatHoldout,
       );

  /// Returns a shallow copy of this [JourneyGroup]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JourneyGroup copyWith({
    _i34jp9wz.JourneyArm? arm,
    Object? campaignId = _Undefined,
    int? assigned,
    int? sent,
    int? opened,
    int? matured,
    int? goal,
    Object? chanceToBeatHoldout = _Undefined,
  }) {
    return JourneyGroup(
      arm: arm ?? this.arm,
      campaignId: campaignId is int? ? campaignId : this.campaignId,
      assigned: assigned ?? this.assigned,
      sent: sent ?? this.sent,
      opened: opened ?? this.opened,
      matured: matured ?? this.matured,
      goal: goal ?? this.goal,
      chanceToBeatHoldout: chanceToBeatHoldout is double?
          ? chanceToBeatHoldout
          : this.chanceToBeatHoldout,
    );
  }
}
