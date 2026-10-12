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

/// A tenant. Every other table hangs off a project and every query filters by it.
abstract class Project
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Project._({
    this.id,
    required this.name,
    required this.handle,
    this.customDomain,
    required this.ownerUserId,
    this.suspendedAt,
    bool? supportChatEnabled,
    DateTime? createdAt,
  }) : supportChatEnabled = supportChatEnabled ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory Project({
    int? id,
    required String name,
    required String handle,
    String? customDomain,
    required _isc.UuidValue ownerUserId,
    DateTime? suspendedAt,
    bool? supportChatEnabled,
    DateTime? createdAt,
  }) = _ProjectImpl;

  factory Project.fromJson(Map<String, dynamic> jsonSerialization) {
    return Project(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      handle: jsonSerialization['handle'] as String,
      customDomain: jsonSerialization['customDomain'] as String?,
      ownerUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['ownerUserId'],
      ),
      suspendedAt: jsonSerialization['suspendedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['suspendedAt'],
            ),
      supportChatEnabled: jsonSerialization['supportChatEnabled'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['supportChatEnabled'],
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

  String name;

  /// DNS label of the project's link domain <handle>.<link base domain>.
  /// Immutable after creation: it is baked into app manifests and sent links.
  String handle;

  /// Customer-owned link domain. Reserved for after the MVP: not set and not
  /// read anywhere yet.
  String? customDomain;

  /// Auth user that owns the project (console user).
  _isc.UuidValue ownerUserId;

  /// Set by an operator per SQL to shut the project down: the link router
  /// and well-known routes answer 404, API keys stop authenticating, the push
  /// worker stops sending and the console can only read. See deploy/README.md.
  DateTime? suspendedAt;

  /// Whether users of the app may open a support chat, a conversation of the
  /// category question. Off until the owner switches it on in the console:
  /// a team that does not answer should not offer a chat.
  bool supportChatEnabled;

  DateTime createdAt;

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Project copyWith({
    int? id,
    String? name,
    String? handle,
    String? customDomain,
    _isc.UuidValue? ownerUserId,
    DateTime? suspendedAt,
    bool? supportChatEnabled,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Project',
      if (id != null) 'id': id,
      'name': name,
      'handle': handle,
      if (customDomain != null) 'customDomain': customDomain,
      'ownerUserId': ownerUserId.toJson(),
      if (suspendedAt != null) 'suspendedAt': suspendedAt?.toJson(),
      'supportChatEnabled': supportChatEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Project',
      if (id != null) 'id': id,
      'name': name,
      'handle': handle,
      if (customDomain != null) 'customDomain': customDomain,
      'ownerUserId': ownerUserId.toJson(),
      if (suspendedAt != null) 'suspendedAt': suspendedAt?.toJson(),
      'supportChatEnabled': supportChatEnabled,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectImpl extends Project {
  _ProjectImpl({
    int? id,
    required String name,
    required String handle,
    String? customDomain,
    required _isc.UuidValue ownerUserId,
    DateTime? suspendedAt,
    bool? supportChatEnabled,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         handle: handle,
         customDomain: customDomain,
         ownerUserId: ownerUserId,
         suspendedAt: suspendedAt,
         supportChatEnabled: supportChatEnabled,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Project]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Project copyWith({
    Object? id = _Undefined,
    String? name,
    String? handle,
    Object? customDomain = _Undefined,
    _isc.UuidValue? ownerUserId,
    Object? suspendedAt = _Undefined,
    bool? supportChatEnabled,
    DateTime? createdAt,
  }) {
    return Project(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      customDomain: customDomain is String? ? customDomain : this.customDomain,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      suspendedAt: suspendedAt is DateTime? ? suspendedAt : this.suspendedAt,
      supportChatEnabled: supportChatEnabled ?? this.supportChatEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
