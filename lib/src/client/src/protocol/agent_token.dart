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
import 'agent_token_level.dart' as _iv7slllc;

/// A token for an AI agent of the customer, bound to one project. The token
/// is shown once on creation and only stored as a hash. It is valid while it
/// is neither revoked nor expired and its creator is still owner or member
/// of the project, see `auth/agent_token_auth.dart`.
abstract class AgentToken
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AgentToken._({
    this.id,
    required this.projectId,
    required this.name,
    required this.prefix,
    required this.level,
    required this.createdByUserId,
    DateTime? createdAt,
    required this.expiresAt,
    this.lastUsedAt,
    this.revokedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory AgentToken({
    int? id,
    required int projectId,
    required String name,
    required String prefix,
    required _iv7slllc.AgentTokenLevel level,
    required _isc.UuidValue createdByUserId,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  }) = _AgentTokenImpl;

  factory AgentToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return AgentToken(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      name: jsonSerialization['name'] as String,
      prefix: jsonSerialization['prefix'] as String,
      level: _iv7slllc.AgentTokenLevel.fromJson(
        (jsonSerialization['level'] as String),
      ),
      createdByUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['createdByUserId'],
      ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiresAt'],
      ),
      lastUsedAt: jsonSerialization['lastUsedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastUsedAt'],
            ),
      revokedAt: jsonSerialization['revokedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['revokedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// Free text, e.g. "Claude Code Markus".
  String name;

  /// The first 8 characters after lt_at_, to recognise the token in a list.
  String prefix;

  _iv7slllc.AgentTokenLevel level;

  /// Console user who created the token. Leaving the project, or being
  /// removed from it, revokes the token.
  _isc.UuidValue createdByUserId;

  DateTime createdAt;

  /// Mandatory: 30, 90 or 365 days after creation.
  DateTime expiresAt;

  /// Written at most once a minute.
  DateTime? lastUsedAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [AgentToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AgentToken copyWith({
    int? id,
    int? projectId,
    String? name,
    String? prefix,
    _iv7slllc.AgentTokenLevel? level,
    _isc.UuidValue? createdByUserId,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AgentToken',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'prefix': prefix,
      'level': level.toJson(),
      'createdByUserId': createdByUserId.toJson(),
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AgentToken',
      if (id != null) 'id': id,
      'projectId': projectId,
      'name': name,
      'prefix': prefix,
      'level': level.toJson(),
      'createdByUserId': createdByUserId.toJson(),
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
      if (lastUsedAt != null) 'lastUsedAt': lastUsedAt?.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AgentTokenImpl extends AgentToken {
  _AgentTokenImpl({
    int? id,
    required int projectId,
    required String name,
    required String prefix,
    required _iv7slllc.AgentTokenLevel level,
    required _isc.UuidValue createdByUserId,
    DateTime? createdAt,
    required DateTime expiresAt,
    DateTime? lastUsedAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         name: name,
         prefix: prefix,
         level: level,
         createdByUserId: createdByUserId,
         createdAt: createdAt,
         expiresAt: expiresAt,
         lastUsedAt: lastUsedAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [AgentToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AgentToken copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? name,
    String? prefix,
    _iv7slllc.AgentTokenLevel? level,
    _isc.UuidValue? createdByUserId,
    DateTime? createdAt,
    DateTime? expiresAt,
    Object? lastUsedAt = _Undefined,
    Object? revokedAt = _Undefined,
  }) {
    return AgentToken(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      prefix: prefix ?? this.prefix,
      level: level ?? this.level,
      createdByUserId: createdByUserId ?? this.createdByUserId,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      lastUsedAt: lastUsedAt is DateTime? ? lastUsedAt : this.lastUsedAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
