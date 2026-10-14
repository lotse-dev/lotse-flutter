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

/// One person with access to a project, as the console lists them: the owner
/// first, then the members.
abstract class ProjectMemberInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectMemberInfo._({
    required this.userId,
    required this.email,
    required this.owner,
    required this.since,
  });

  factory ProjectMemberInfo({
    required _isc.UuidValue userId,
    required String email,
    required bool owner,
    required DateTime since,
  }) = _ProjectMemberInfoImpl;

  factory ProjectMemberInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectMemberInfo(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      email: jsonSerialization['email'] as String,
      owner: _isc.BoolJsonExtension.fromJson(jsonSerialization['owner']),
      since: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['since']),
    );
  }

  _isc.UuidValue userId;

  /// E-mail address of the account. Empty when the account has none.
  String email;

  bool owner;

  /// When the project was created (owner) or the invitation accepted.
  DateTime since;

  /// Returns a shallow copy of this [ProjectMemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectMemberInfo copyWith({
    _isc.UuidValue? userId,
    String? email,
    bool? owner,
    DateTime? since,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectMemberInfo',
      'userId': userId.toJson(),
      'email': email,
      'owner': owner,
      'since': since.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectMemberInfo',
      'userId': userId.toJson(),
      'email': email,
      'owner': owner,
      'since': since.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProjectMemberInfoImpl extends ProjectMemberInfo {
  _ProjectMemberInfoImpl({
    required _isc.UuidValue userId,
    required String email,
    required bool owner,
    required DateTime since,
  }) : super._(userId: userId, email: email, owner: owner, since: since);

  /// Returns a shallow copy of this [ProjectMemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectMemberInfo copyWith({
    _isc.UuidValue? userId,
    String? email,
    bool? owner,
    DateTime? since,
  }) {
    return ProjectMemberInfo(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      owner: owner ?? this.owner,
      since: since ?? this.since,
    );
  }
}
