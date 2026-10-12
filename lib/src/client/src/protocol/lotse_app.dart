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

/// An app binary of a project on one platform. Drives assetlinks.json and AASA.
abstract class LotseApp
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LotseApp._({
    this.id,
    required this.projectId,
    required this.platform,
    required this.bundleId,
    this.teamId,
    this.appStoreId,
    required this.sha256Fingerprints,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory LotseApp({
    int? id,
    required int projectId,
    required _ij3iar7l.DevicePlatform platform,
    required String bundleId,
    String? teamId,
    String? appStoreId,
    required List<String> sha256Fingerprints,
    DateTime? createdAt,
  }) = _LotseAppImpl;

  factory LotseApp.fromJson(Map<String, dynamic> jsonSerialization) {
    return LotseApp(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      bundleId: jsonSerialization['bundleId'] as String,
      teamId: jsonSerialization['teamId'] as String?,
      appStoreId: jsonSerialization['appStoreId'] as String?,
      sha256Fingerprints: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['sha256Fingerprints'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  _ij3iar7l.DevicePlatform platform;

  /// Android package name or iOS bundle identifier.
  String bundleId;

  /// Apple Team ID, needed for apple-app-site-association.
  String? teamId;

  /// App Store ID, used for the iOS store fallback.
  String? appStoreId;

  /// SHA-256 signing certificate fingerprints, needed for assetlinks.json.
  List<String> sha256Fingerprints;

  DateTime createdAt;

  /// Returns a shallow copy of this [LotseApp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseApp copyWith({
    int? id,
    int? projectId,
    _ij3iar7l.DevicePlatform? platform,
    String? bundleId,
    String? teamId,
    String? appStoreId,
    List<String>? sha256Fingerprints,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseApp',
      if (id != null) 'id': id,
      'projectId': projectId,
      'platform': platform.toJson(),
      'bundleId': bundleId,
      if (teamId != null) 'teamId': teamId,
      if (appStoreId != null) 'appStoreId': appStoreId,
      'sha256Fingerprints': sha256Fingerprints.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseApp',
      if (id != null) 'id': id,
      'projectId': projectId,
      'platform': platform.toJson(),
      'bundleId': bundleId,
      if (teamId != null) 'teamId': teamId,
      if (appStoreId != null) 'appStoreId': appStoreId,
      'sha256Fingerprints': sha256Fingerprints.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LotseAppImpl extends LotseApp {
  _LotseAppImpl({
    int? id,
    required int projectId,
    required _ij3iar7l.DevicePlatform platform,
    required String bundleId,
    String? teamId,
    String? appStoreId,
    required List<String> sha256Fingerprints,
    DateTime? createdAt,
  }) : super._(
         id: id,
         projectId: projectId,
         platform: platform,
         bundleId: bundleId,
         teamId: teamId,
         appStoreId: appStoreId,
         sha256Fingerprints: sha256Fingerprints,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [LotseApp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseApp copyWith({
    Object? id = _Undefined,
    int? projectId,
    _ij3iar7l.DevicePlatform? platform,
    String? bundleId,
    Object? teamId = _Undefined,
    Object? appStoreId = _Undefined,
    List<String>? sha256Fingerprints,
    DateTime? createdAt,
  }) {
    return LotseApp(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      platform: platform ?? this.platform,
      bundleId: bundleId ?? this.bundleId,
      teamId: teamId is String? ? teamId : this.teamId,
      appStoreId: appStoreId is String? ? appStoreId : this.appStoreId,
      sha256Fingerprints:
          sha256Fingerprints ??
          this.sha256Fingerprints.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
