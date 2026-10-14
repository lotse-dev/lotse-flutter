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
import 'device_platform.dart' as _ij3iar7l;

/// Active devices of one platform in AnalyticsOverview.
abstract class PlatformCount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlatformCount._({required this.platform, required this.count});

  factory PlatformCount({
    required _ij3iar7l.DevicePlatform platform,
    required int count,
  }) = _PlatformCountImpl;

  factory PlatformCount.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlatformCount(
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      count: jsonSerialization['count'] as int,
    );
  }

  _ij3iar7l.DevicePlatform platform;

  int count;

  /// Returns a shallow copy of this [PlatformCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlatformCount copyWith({_ij3iar7l.DevicePlatform? platform, int? count});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlatformCount',
      'platform': platform.toJson(),
      'count': count,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlatformCount',
      'platform': platform.toJson(),
      'count': count,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PlatformCountImpl extends PlatformCount {
  _PlatformCountImpl({
    required _ij3iar7l.DevicePlatform platform,
    required int count,
  }) : super._(platform: platform, count: count);

  /// Returns a shallow copy of this [PlatformCount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlatformCount copyWith({_ij3iar7l.DevicePlatform? platform, int? count}) {
    return PlatformCount(
      platform: platform ?? this.platform,
      count: count ?? this.count,
    );
  }
}
