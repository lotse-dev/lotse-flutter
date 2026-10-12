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

/// The background of a heatmap without its bytes; those come from
/// `ProjectEndpoint.getHeatmapBackground`.
abstract class HeatmapBackgroundInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeatmapBackgroundInfo._({
    required this.id,
    required this.appVersion,
    required this.width,
    required this.height,
    required this.scrollY,
    required this.createdAt,
  });

  factory HeatmapBackgroundInfo({
    required int id,
    required String appVersion,
    required int width,
    required int height,
    required int scrollY,
    required DateTime createdAt,
  }) = _HeatmapBackgroundInfoImpl;

  factory HeatmapBackgroundInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return HeatmapBackgroundInfo(
      id: jsonSerialization['id'] as int,
      appVersion: jsonSerialization['appVersion'] as String,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      scrollY: jsonSerialization['scrollY'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  /// Empty when the device reported no version.
  String appVersion;

  int width;

  int height;

  int scrollY;

  DateTime createdAt;

  /// Returns a shallow copy of this [HeatmapBackgroundInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeatmapBackgroundInfo copyWith({
    int? id,
    String? appVersion,
    int? width,
    int? height,
    int? scrollY,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeatmapBackgroundInfo',
      'id': id,
      'appVersion': appVersion,
      'width': width,
      'height': height,
      'scrollY': scrollY,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeatmapBackgroundInfo',
      'id': id,
      'appVersion': appVersion,
      'width': width,
      'height': height,
      'scrollY': scrollY,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HeatmapBackgroundInfoImpl extends HeatmapBackgroundInfo {
  _HeatmapBackgroundInfoImpl({
    required int id,
    required String appVersion,
    required int width,
    required int height,
    required int scrollY,
    required DateTime createdAt,
  }) : super._(
         id: id,
         appVersion: appVersion,
         width: width,
         height: height,
         scrollY: scrollY,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [HeatmapBackgroundInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeatmapBackgroundInfo copyWith({
    int? id,
    String? appVersion,
    int? width,
    int? height,
    int? scrollY,
    DateTime? createdAt,
  }) {
    return HeatmapBackgroundInfo(
      id: id ?? this.id,
      appVersion: appVersion ?? this.appVersion,
      width: width ?? this.width,
      height: height ?? this.height,
      scrollY: scrollY ?? this.scrollY,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
