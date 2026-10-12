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

/// One key pair of a project. The public key ships in app binaries, the secret
/// is shown once on creation and only stored as a hash.
abstract class ApiKey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ApiKey._({
    this.id,
    required this.projectId,
    required this.publicKey,
    required this.label,
    DateTime? createdAt,
    this.revokedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ApiKey({
    int? id,
    required int projectId,
    required String publicKey,
    required String label,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) = _ApiKeyImpl;

  factory ApiKey.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiKey(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      publicKey: jsonSerialization['publicKey'] as String,
      label: jsonSerialization['label'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
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

  /// Format: lt_pk_ + 32 random characters.
  String publicKey;

  String label;

  DateTime createdAt;

  DateTime? revokedAt;

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApiKey copyWith({
    int? id,
    int? projectId,
    String? publicKey,
    String? label,
    DateTime? createdAt,
    DateTime? revokedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'publicKey': publicKey,
      'label': label,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiKey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'publicKey': publicKey,
      'label': label,
      'createdAt': createdAt.toJson(),
      if (revokedAt != null) 'revokedAt': revokedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ApiKeyImpl extends ApiKey {
  _ApiKeyImpl({
    int? id,
    required int projectId,
    required String publicKey,
    required String label,
    DateTime? createdAt,
    DateTime? revokedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         publicKey: publicKey,
         label: label,
         createdAt: createdAt,
         revokedAt: revokedAt,
       );

  /// Returns a shallow copy of this [ApiKey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApiKey copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? publicKey,
    String? label,
    DateTime? createdAt,
    Object? revokedAt = _Undefined,
  }) {
    return ApiKey(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      publicKey: publicKey ?? this.publicKey,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
      revokedAt: revokedAt is DateTime? ? revokedAt : this.revokedAt,
    );
  }
}
