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

/// An open invitation as the owner sees it. Never carries the token or its
/// hash.
abstract class ProjectInvitationInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectInvitationInfo._({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.expiresAt,
  });

  factory ProjectInvitationInfo({
    required int id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _ProjectInvitationInfoImpl;

  factory ProjectInvitationInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectInvitationInfo(
      id: jsonSerialization['id'] as int,
      email: jsonSerialization['email'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
    );
  }

  int id;

  String email;

  DateTime createdAt;

  DateTime expiresAt;

  /// Returns a shallow copy of this [ProjectInvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectInvitationInfo copyWith({
    int? id,
    String? email,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectInvitationInfo',
      'id': id,
      'email': email,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectInvitationInfo',
      'id': id,
      'email': email,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProjectInvitationInfoImpl extends ProjectInvitationInfo {
  _ProjectInvitationInfoImpl({
    required int id,
    required String email,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) : super._(
         id: id,
         email: email,
         createdAt: createdAt,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [ProjectInvitationInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectInvitationInfo copyWith({
    int? id,
    String? email,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return ProjectInvitationInfo(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
