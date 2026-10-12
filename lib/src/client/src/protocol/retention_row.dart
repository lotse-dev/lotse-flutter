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
import 'device_platform.dart' as _ij3iar7l;

/// The installs of one cohort or of one part of it, see RetentionReport.
abstract class RetentionRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RetentionRow._({
    required this.organic,
    this.campaign,
    this.platform,
    required this.installs,
    required this.matured,
    required this.returned,
  });

  factory RetentionRow({
    required bool organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    required int installs,
    required List<int> matured,
    required List<int> returned,
  }) = _RetentionRowImpl;

  factory RetentionRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return RetentionRow(
      organic: _isc.BoolJsonExtension.fromJson(jsonSerialization['organic']),
      campaign: jsonSerialization['campaign'] as String?,
      platform: jsonSerialization['platform'] == null
          ? null
          : _ij3iar7l.DevicePlatform.fromJson(
              (jsonSerialization['platform'] as String),
            ),
      installs: jsonSerialization['installs'] as int,
      matured: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['matured'],
      ),
      returned: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['returned'],
      ),
    );
  }

  /// Split by campaign: true for devices without an attributed link.
  bool organic;

  /// Split by campaign: the campaign of the attributed link. Null for
  /// organic devices and for links without a campaign.
  String? campaign;

  /// Split by platform: the platform of the devices.
  _ij3iar7l.DevicePlatform? platform;

  int installs;

  /// Per entry of RetentionReport.days: installs whose return window is over
  /// at RetentionReport.measuredAt. Only these count as returned or not.
  List<int> matured;

  /// Per entry of RetentionReport.days: matured installs with a
  /// session_start in the return window.
  List<int> returned;

  /// Returns a shallow copy of this [RetentionRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RetentionRow copyWith({
    bool? organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    int? installs,
    List<int>? matured,
    List<int>? returned,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RetentionRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (platform != null) 'platform': platform?.toJson(),
      'installs': installs,
      'matured': matured.toJson(),
      'returned': returned.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RetentionRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (platform != null) 'platform': platform?.toJson(),
      'installs': installs,
      'matured': matured.toJson(),
      'returned': returned.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RetentionRowImpl extends RetentionRow {
  _RetentionRowImpl({
    required bool organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    required int installs,
    required List<int> matured,
    required List<int> returned,
  }) : super._(
         organic: organic,
         campaign: campaign,
         platform: platform,
         installs: installs,
         matured: matured,
         returned: returned,
       );

  /// Returns a shallow copy of this [RetentionRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RetentionRow copyWith({
    bool? organic,
    Object? campaign = _Undefined,
    Object? platform = _Undefined,
    int? installs,
    List<int>? matured,
    List<int>? returned,
  }) {
    return RetentionRow(
      organic: organic ?? this.organic,
      campaign: campaign is String? ? campaign : this.campaign,
      platform: platform is _ij3iar7l.DevicePlatform?
          ? platform
          : this.platform,
      installs: installs ?? this.installs,
      matured: matured ?? this.matured.map((e0) => e0).toList(),
      returned: returned ?? this.returned.map((e0) => e0).toList(),
    );
  }
}
