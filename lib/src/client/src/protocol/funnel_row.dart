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

/// The devices of one part of a funnel, see FunnelReport.
abstract class FunnelRow
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FunnelRow._({
    required this.organic,
    this.campaign,
    this.platform,
    required this.devices,
  });

  factory FunnelRow({
    required bool organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    required List<int> devices,
  }) = _FunnelRowImpl;

  factory FunnelRow.fromJson(Map<String, dynamic> jsonSerialization) {
    return FunnelRow(
      organic: _isc.BoolJsonExtension.fromJson(jsonSerialization['organic']),
      campaign: jsonSerialization['campaign'] as String?,
      platform: jsonSerialization['platform'] == null
          ? null
          : _ij3iar7l.DevicePlatform.fromJson(
              (jsonSerialization['platform'] as String),
            ),
      devices: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['devices'],
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

  /// Devices that reached each step, one entry per step. Never grows.
  List<int> devices;

  /// Returns a shallow copy of this [FunnelRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FunnelRow copyWith({
    bool? organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    List<int>? devices,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FunnelRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (platform != null) 'platform': platform?.toJson(),
      'devices': devices.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FunnelRow',
      'organic': organic,
      if (campaign != null) 'campaign': campaign,
      if (platform != null) 'platform': platform?.toJson(),
      'devices': devices.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FunnelRowImpl extends FunnelRow {
  _FunnelRowImpl({
    required bool organic,
    String? campaign,
    _ij3iar7l.DevicePlatform? platform,
    required List<int> devices,
  }) : super._(
         organic: organic,
         campaign: campaign,
         platform: platform,
         devices: devices,
       );

  /// Returns a shallow copy of this [FunnelRow]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FunnelRow copyWith({
    bool? organic,
    Object? campaign = _Undefined,
    Object? platform = _Undefined,
    List<int>? devices,
  }) {
    return FunnelRow(
      organic: organic ?? this.organic,
      campaign: campaign is String? ? campaign : this.campaign,
      platform: platform is _ij3iar7l.DevicePlatform?
          ? platform
          : this.platform,
      devices: devices ?? this.devices.map((e0) => e0).toList(),
    );
  }
}
