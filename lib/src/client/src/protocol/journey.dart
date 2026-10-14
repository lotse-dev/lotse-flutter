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
import 'journey_status.dart' as _i6knwx07;
import 'journey_trigger.dart' as _ia9frtih;

/// A push that goes to every device reaching a trigger: after a wait, and
/// only if the device did not reach the goal first. Up to two variants and a
/// group without push decide which text works. See docs/JOURNEYS.md.
///
/// The variants are campaign rows in status `journey` (campaign.journeyId),
/// so the push worker sends them like any campaign.
abstract class Journey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Journey._({
    this.id,
    required this.projectId,
    required this.name,
    required this.status,
    required this.trigger,
    this.triggerEvent,
    this.triggerPropKey,
    this.triggerPropValue,
    required this.delayMinutes,
    required this.goalEvent,
    required this.goalWindowHours,
    this.segment,
    required this.holdoutPercent,
    required this.autoWinner,
    this.winnerVariant,
    this.winnerAt,
    this.startedAt,
    this.endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Journey({
    int? id,
    required int projectId,
    required String name,
    required _i6knwx07.JourneyStatus status,
    required _ia9frtih.JourneyTrigger trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    required int delayMinutes,
    required String goalEvent,
    required int goalWindowHours,
    Map<String, dynamic>? segment,
    required int holdoutPercent,
    required bool autoWinner,
    int? winnerVariant,
    DateTime? winnerAt,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _JourneyImpl;

  factory Journey.fromJson(Map<String, dynamic> jsonSerialization) {
    return Journey(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      name: jsonSerialization['name'] as String,
      status: _i6knwx07.JourneyStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      trigger: _ia9frtih.JourneyTrigger.fromJson(
        (jsonSerialization['trigger'] as String),
      ),
      triggerEvent: jsonSerialization['triggerEvent'] as String?,
      triggerPropKey: jsonSerialization['triggerPropKey'] as String?,
      triggerPropValue: jsonSerialization['triggerPropValue'] as String?,
      delayMinutes: jsonSerialization['delayMinutes'] as int,
      goalEvent: jsonSerialization['goalEvent'] as String,
      goalWindowHours: jsonSerialization['goalWindowHours'] as int,
      segment: jsonSerialization['segment'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, dynamic>>(
              jsonSerialization['segment'],
            ),
      holdoutPercent: jsonSerialization['holdoutPercent'] as int,
      autoWinner: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['autoWinner'],
      ),
      winnerVariant: jsonSerialization['winnerVariant'] as int?,
      winnerAt: jsonSerialization['winnerAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['winnerAt']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// Trimmed, 1 to 64 characters.
  String name;

  _i6knwx07.JourneyStatus status;

  _ia9frtih.JourneyTrigger trigger;

  /// Event name of the trigger `event`, null for `install`.
  String? triggerEvent;

  /// Optional prop the trigger event must carry with exactly
  /// triggerPropValue, like a funnel step. Set together or neither.
  String? triggerPropKey;

  String? triggerPropValue;

  /// Wait from the trigger to the decision, 10 minutes to 30 days.
  int delayMinutes;

  /// Who tracks it before the decision gets no push; within goalWindowHours
  /// after the decision it measures the groups.
  String goalEvent;

  /// How long after the decision the goal counts, 1 to 168 hours.
  int goalWindowHours;

  /// Audience predicate, see ARCHITECTURE.md, section "Segmente", checked
  /// at the decision. Stored validated; null means every device.
  Map<String, dynamic>? segment;

  /// Share of the devices that get no push, 0 to 50.
  int holdoutPercent;

  /// Whether the scanner sets the winner once the rule of
  /// `journeys/winner.dart` holds.
  bool autoWinner;

  /// 0 for A, 1 for B. From winnerAt on every device outside the holdout
  /// gets this variant.
  int? winnerVariant;

  DateTime? winnerAt;

  /// When the journey became active. Only triggers from here count.
  DateTime? startedAt;

  DateTime? endedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Journey copyWith({
    int? id,
    int? projectId,
    String? name,
    _i6knwx07.JourneyStatus? status,
    _ia9frtih.JourneyTrigger? trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    int? delayMinutes,
    String? goalEvent,
    int? goalWindowHours,
    Map<String, dynamic>? segment,
    int? holdoutPercent,
    bool? autoWinner,
    int? winnerVariant,
    DateTime? winnerAt,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      if (triggerEvent != null) 'triggerEvent': triggerEvent,
      if (triggerPropKey != null) 'triggerPropKey': triggerPropKey,
      if (triggerPropValue != null) 'triggerPropValue': triggerPropValue,
      'delayMinutes': delayMinutes,
      'goalEvent': goalEvent,
      'goalWindowHours': goalWindowHours,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) => _ist2d7e6.Protocol().dynamicFieldToJson(v),
        ),
      'holdoutPercent': holdoutPercent,
      'autoWinner': autoWinner,
      if (winnerVariant != null) 'winnerVariant': winnerVariant,
      if (winnerAt != null) 'winnerAt': winnerAt?.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Journey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'status': status.toJson(),
      'trigger': trigger.toJson(),
      if (triggerEvent != null) 'triggerEvent': triggerEvent,
      if (triggerPropKey != null) 'triggerPropKey': triggerPropKey,
      if (triggerPropValue != null) 'triggerPropValue': triggerPropValue,
      'delayMinutes': delayMinutes,
      'goalEvent': goalEvent,
      'goalWindowHours': goalWindowHours,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) =>
              _ist2d7e6.Protocol().dynamicFieldToJson(v, forProtocol: true),
        ),
      'holdoutPercent': holdoutPercent,
      'autoWinner': autoWinner,
      if (winnerVariant != null) 'winnerVariant': winnerVariant,
      if (winnerAt != null) 'winnerAt': winnerAt?.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JourneyImpl extends Journey {
  _JourneyImpl({
    int? id,
    required int projectId,
    required String name,
    required _i6knwx07.JourneyStatus status,
    required _ia9frtih.JourneyTrigger trigger,
    String? triggerEvent,
    String? triggerPropKey,
    String? triggerPropValue,
    required int delayMinutes,
    required String goalEvent,
    required int goalWindowHours,
    Map<String, dynamic>? segment,
    required int holdoutPercent,
    required bool autoWinner,
    int? winnerVariant,
    DateTime? winnerAt,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         status: status,
         trigger: trigger,
         triggerEvent: triggerEvent,
         triggerPropKey: triggerPropKey,
         triggerPropValue: triggerPropValue,
         delayMinutes: delayMinutes,
         goalEvent: goalEvent,
         goalWindowHours: goalWindowHours,
         segment: segment,
         holdoutPercent: holdoutPercent,
         autoWinner: autoWinner,
         winnerVariant: winnerVariant,
         winnerAt: winnerAt,
         startedAt: startedAt,
         endedAt: endedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Journey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Journey copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? name,
    _i6knwx07.JourneyStatus? status,
    _ia9frtih.JourneyTrigger? trigger,
    Object? triggerEvent = _Undefined,
    Object? triggerPropKey = _Undefined,
    Object? triggerPropValue = _Undefined,
    int? delayMinutes,
    String? goalEvent,
    int? goalWindowHours,
    Object? segment = _Undefined,
    int? holdoutPercent,
    bool? autoWinner,
    Object? winnerVariant = _Undefined,
    Object? winnerAt = _Undefined,
    Object? startedAt = _Undefined,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Journey(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      status: status ?? this.status,
      trigger: trigger ?? this.trigger,
      triggerEvent: triggerEvent is String? ? triggerEvent : this.triggerEvent,
      triggerPropKey: triggerPropKey is String?
          ? triggerPropKey
          : this.triggerPropKey,
      triggerPropValue: triggerPropValue is String?
          ? triggerPropValue
          : this.triggerPropValue,
      delayMinutes: delayMinutes ?? this.delayMinutes,
      goalEvent: goalEvent ?? this.goalEvent,
      goalWindowHours: goalWindowHours ?? this.goalWindowHours,
      segment: segment is Map<String, dynamic>?
          ? segment
          : this.segment?.map((key0, value0) => MapEntry(key0, value0)),
      holdoutPercent: holdoutPercent ?? this.holdoutPercent,
      autoWinner: autoWinner ?? this.autoWinner,
      winnerVariant: winnerVariant is int? ? winnerVariant : this.winnerVariant,
      winnerAt: winnerAt is DateTime? ? winnerAt : this.winnerAt,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
