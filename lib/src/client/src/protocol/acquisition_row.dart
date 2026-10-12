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

/// One row of AcquisitionReport: the installs of one origin in the range
/// and how far they got. An origin is the campaign, source and medium of the
/// link an install is attributed to, as the link has them when the report
/// is made, or no link at all (organic).
abstract class AcquisitionRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AcquisitionRow._({
    required this.organic,
    this.campaign,
    this.source,
    this.medium,
    required this.clicks,
    required this.installs,
    required this.matured,
    required this.active,
    this.goal,
  });

  factory AcquisitionRow({
    required bool organic,
    String? campaign,
    String? source,
    String? medium,
    required int clicks,
    required int installs,
    required int matured,
    required int active,
    int? goal,
  }) = _AcquisitionRowImpl;

  factory AcquisitionRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return AcquisitionRow(
      organic: _isc.BoolJsonExtension.fromJson(jsonSerialization['organic']),
      campaign: jsonSerialization['campaign'] as String?,
      source: jsonSerialization['source'] as String?,
      medium: jsonSerialization['medium'] as String?,
      clicks: jsonSerialization['clicks'] as int,
      installs: jsonSerialization['installs'] as int,
      matured: jsonSerialization['matured'] as int,
      active: jsonSerialization['active'] as int,
      goal: jsonSerialization['goal'] as int?,
    );
  }

  /// True for the installs without an attributed link. They have no clicks,
  /// and campaign, source and medium are null.
  bool organic;

  String? campaign;

  String? source;

  String? medium;

  /// Clicks in the range on links with this campaign, source and medium.
  int clicks;

  /// Devices first seen in the range with this origin.
  int installs;

  /// Of the installs, those whose first acquisitionWindowDays days are over.
  /// Only these count for active and goal.
  int matured;

  /// Matured installs with a session_start on day 7 to 13 after the install.
  int active;

  /// Matured installs with the goal event in their first
  /// acquisitionWindowDays days. Null when the report has no goal event.
  int? goal;

  /// Returns a shallow copy of this [AcquisitionRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AcquisitionRow copyWith({
    bool? organic,
    String? campaign,
    String? source,
    String? medium,
    int? clicks,
    int? installs,
    int? matured,
    int? active,
    int? goal,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AcquisitionRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
      'clicks': clicks,
      'installs': installs,
      'matured': matured,
      'active': active,
      if (goal != null) 'goal': goal,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AcquisitionRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (source != null) 'source': source,
      if (medium != null) 'medium': medium,
      'clicks': clicks,
      'installs': installs,
      'matured': matured,
      'active': active,
      if (goal != null) 'goal': goal,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AcquisitionRowImpl extends AcquisitionRow {
  _AcquisitionRowImpl({
    required bool organic,
    String? campaign,
    String? source,
    String? medium,
    required int clicks,
    required int installs,
    required int matured,
    required int active,
    int? goal,
  }) : super._(
         organic: organic,
         campaign: campaign,
         source: source,
         medium: medium,
         clicks: clicks,
         installs: installs,
         matured: matured,
         active: active,
         goal: goal,
       );

  /// Returns a shallow copy of this [AcquisitionRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AcquisitionRow copyWith({
    bool? organic,
    Object? campaign = _Undefined,
    Object? source = _Undefined,
    Object? medium = _Undefined,
    int? clicks,
    int? installs,
    int? matured,
    int? active,
    Object? goal = _Undefined,
  }) {
    return AcquisitionRow(
      organic: organic ?? this.organic,
      campaign: campaign is String? ? campaign : this.campaign,
      source: source is String? ? source : this.source,
      medium: medium is String? ? medium : this.medium,
      clicks: clicks ?? this.clicks,
      installs: installs ?? this.installs,
      matured: matured ?? this.matured,
      active: active ?? this.active,
      goal: goal is int? ? goal : this.goal,
    );
  }
}
