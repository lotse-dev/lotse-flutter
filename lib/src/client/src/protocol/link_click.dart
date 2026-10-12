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

/// One request to /l/<slug>. Written by the link router, matched to a device
/// by deferred matching later.
abstract class LinkClick
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  LinkClick._({
    this.id,
    required this.projectId,
    required this.linkId,
    required this.ts,
    this.userAgent,
    required this.platform,
    this.matchedDeviceId,
  });

  factory LinkClick({
    int? id,
    required int projectId,
    required int linkId,
    required DateTime ts,
    String? userAgent,
    required _ij3iar7l.DevicePlatform platform,
    int? matchedDeviceId,
  }) = _LinkClickImpl;

  factory LinkClick.fromJson(Map<String, dynamic> jsonSerialization) {
    return LinkClick(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      linkId: jsonSerialization['linkId'] as int,
      ts: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
      userAgent: jsonSerialization['userAgent'] as String?,
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      matchedDeviceId: jsonSerialization['matchedDeviceId'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Copied from the link so every query can filter by project directly.
  int projectId;

  int linkId;

  DateTime ts;

  /// Emptied (null) after linkClickPseudonymRetention.
  String? userAgent;

  _ij3iar7l.DevicePlatform platform;

  int? matchedDeviceId;

  /// Returns a shallow copy of this [LinkClick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LinkClick copyWith({
    int? id,
    int? projectId,
    int? linkId,
    DateTime? ts,
    String? userAgent,
    _ij3iar7l.DevicePlatform? platform,
    int? matchedDeviceId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LinkClick',
      if (id != null) 'id': id,
      'projectId': projectId,
      'linkId': linkId,
      'ts': ts.toJson(),
      if (userAgent != null) 'userAgent': userAgent,
      'platform': platform.toJson(),
      if (matchedDeviceId != null) 'matchedDeviceId': matchedDeviceId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LinkClick',
      if (id != null) 'id': id,
      'projectId': projectId,
      'linkId': linkId,
      'ts': ts.toJson(),
      if (userAgent != null) 'userAgent': userAgent,
      'platform': platform.toJson(),
      if (matchedDeviceId != null) 'matchedDeviceId': matchedDeviceId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LinkClickImpl extends LinkClick {
  _LinkClickImpl({
    int? id,
    required int projectId,
    required int linkId,
    required DateTime ts,
    String? userAgent,
    required _ij3iar7l.DevicePlatform platform,
    int? matchedDeviceId,
  }) : super._(
         id: id,
         projectId: projectId,
         linkId: linkId,
         ts: ts,
         userAgent: userAgent,
         platform: platform,
         matchedDeviceId: matchedDeviceId,
       );

  /// Returns a shallow copy of this [LinkClick]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LinkClick copyWith({
    Object? id = _Undefined,
    int? projectId,
    int? linkId,
    DateTime? ts,
    Object? userAgent = _Undefined,
    _ij3iar7l.DevicePlatform? platform,
    Object? matchedDeviceId = _Undefined,
  }) {
    return LinkClick(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      linkId: linkId ?? this.linkId,
      ts: ts ?? this.ts,
      userAgent: userAgent is String? ? userAgent : this.userAgent,
      platform: platform ?? this.platform,
      matchedDeviceId: matchedDeviceId is int?
          ? matchedDeviceId
          : this.matchedDeviceId,
    );
  }
}
