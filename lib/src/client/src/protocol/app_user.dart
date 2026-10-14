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

/// A user of the customer's app, as the app names it with Lotse.identify().
/// One row per project and external id; several devices can point at it.
/// The external id is what the app says, not something Lotse verified: it
/// is a trait for analytics and segments and opens nothing private.
abstract class AppUser
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppUser._({
    this.id,
    required this.projectId,
    required this.externalId,
    this.traits,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  }) : firstSeenAt = firstSeenAt ?? DateTime.now(),
       lastSeenAt = lastSeenAt ?? DateTime.now();

  factory AppUser({
    int? id,
    required int projectId,
    required String externalId,
    Map<String, String>? traits,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      externalId: jsonSerialization['externalId'] as String,
      traits: jsonSerialization['traits'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['traits'],
            ),
      firstSeenAt: jsonSerialization['firstSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstSeenAt'],
            ),
      lastSeenAt: jsonSerialization['lastSeenAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastSeenAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// The user id the app passes to Lotse.identify(). Set by the app, unique
  /// per project. Never logged.
  String externalId;

  /// The traits the app passed last, merged over earlier calls. Personal data
  /// of the app's users: never logged.
  Map<String, String>? traits;

  DateTime firstSeenAt;

  DateTime lastSeenAt;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUser copyWith({
    int? id,
    int? projectId,
    String? externalId,
    Map<String, String>? traits,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'projectId': projectId,
      'externalId': externalId,
      if (traits != null) 'traits': traits?.toJson(),
      'firstSeenAt': firstSeenAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      if (id != null) 'id': id,
      'projectId': projectId,
      'externalId': externalId,
      if (traits != null) 'traits': traits?.toJson(),
      'firstSeenAt': firstSeenAt.toJson(),
      'lastSeenAt': lastSeenAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    int? id,
    required int projectId,
    required String externalId,
    Map<String, String>? traits,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  }) : super._(
         id: id,
         projectId: projectId,
         externalId: externalId,
         traits: traits,
         firstSeenAt: firstSeenAt,
         lastSeenAt: lastSeenAt,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppUser copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? externalId,
    Object? traits = _Undefined,
    DateTime? firstSeenAt,
    DateTime? lastSeenAt,
  }) {
    return AppUser(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      externalId: externalId ?? this.externalId,
      traits: traits is Map<String, String>?
          ? traits
          : this.traits?.map((key0, value0) => MapEntry(key0, value0)),
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}
