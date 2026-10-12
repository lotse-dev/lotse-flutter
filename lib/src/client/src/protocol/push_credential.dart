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
import 'apns_environment.dart' as _iy23tayo;
import 'push_provider.dart' as _i0unzms6;

/// Push provider credential of one app, encrypted at rest. One per app and
/// provider; uploading again replaces the stored payload.
abstract class PushCredential
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushCredential._({
    this.id,
    required this.appId,
    required this.provider,
    this.serviceAccountEmail,
    this.fcmProjectId,
    this.apnsKeyId,
    this.apnsTeamId,
    this.apnsEnvironment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory PushCredential({
    int? id,
    required int appId,
    required _i0unzms6.PushProvider provider,
    String? serviceAccountEmail,
    String? fcmProjectId,
    String? apnsKeyId,
    String? apnsTeamId,
    _iy23tayo.ApnsEnvironment? apnsEnvironment,
    DateTime? createdAt,
  }) = _PushCredentialImpl;

  factory PushCredential.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushCredential(
      id: jsonSerialization['id'] as int?,
      appId: jsonSerialization['appId'] as int,
      provider: _i0unzms6.PushProvider.fromJson(
        (jsonSerialization['provider'] as String),
      ),
      serviceAccountEmail: jsonSerialization['serviceAccountEmail'] as String?,
      fcmProjectId: jsonSerialization['fcmProjectId'] as String?,
      apnsKeyId: jsonSerialization['apnsKeyId'] as String?,
      apnsTeamId: jsonSerialization['apnsTeamId'] as String?,
      apnsEnvironment: jsonSerialization['apnsEnvironment'] == null
          ? null
          : _iy23tayo.ApnsEnvironment.fromJson(
              (jsonSerialization['apnsEnvironment'] as String),
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

  int appId;

  _i0unzms6.PushProvider provider;

  /// FCM: metadata the console shows instead of the payload.
  String? serviceAccountEmail;

  /// FCM: the Firebase project the service account belongs to.
  String? fcmProjectId;

  /// APNs: the Key ID of the p8 key, the `kid` of the provider token.
  String? apnsKeyId;

  /// APNs: the Apple Team ID the key belongs to, the `iss` of the token.
  String? apnsTeamId;

  /// APNs: which host the key sends to.
  _iy23tayo.ApnsEnvironment? apnsEnvironment;

  DateTime createdAt;

  /// Returns a shallow copy of this [PushCredential]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushCredential copyWith({
    int? id,
    int? appId,
    _i0unzms6.PushProvider? provider,
    String? serviceAccountEmail,
    String? fcmProjectId,
    String? apnsKeyId,
    String? apnsTeamId,
    _iy23tayo.ApnsEnvironment? apnsEnvironment,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushCredential',
      if (id != null) 'id': id,
      'appId': appId,
      'provider': provider.toJson(),
      if (serviceAccountEmail != null)
        'serviceAccountEmail': serviceAccountEmail,
      if (fcmProjectId != null) 'fcmProjectId': fcmProjectId,
      if (apnsKeyId != null) 'apnsKeyId': apnsKeyId,
      if (apnsTeamId != null) 'apnsTeamId': apnsTeamId,
      if (apnsEnvironment != null) 'apnsEnvironment': apnsEnvironment?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushCredential',
      if (id != null) 'id': id,
      'appId': appId,
      'provider': provider.toJson(),
      if (serviceAccountEmail != null)
        'serviceAccountEmail': serviceAccountEmail,
      if (fcmProjectId != null) 'fcmProjectId': fcmProjectId,
      if (apnsKeyId != null) 'apnsKeyId': apnsKeyId,
      if (apnsTeamId != null) 'apnsTeamId': apnsTeamId,
      if (apnsEnvironment != null) 'apnsEnvironment': apnsEnvironment?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushCredentialImpl extends PushCredential {
  _PushCredentialImpl({
    int? id,
    required int appId,
    required _i0unzms6.PushProvider provider,
    String? serviceAccountEmail,
    String? fcmProjectId,
    String? apnsKeyId,
    String? apnsTeamId,
    _iy23tayo.ApnsEnvironment? apnsEnvironment,
    DateTime? createdAt,
  }) : super._(
         id: id,
         appId: appId,
         provider: provider,
         serviceAccountEmail: serviceAccountEmail,
         fcmProjectId: fcmProjectId,
         apnsKeyId: apnsKeyId,
         apnsTeamId: apnsTeamId,
         apnsEnvironment: apnsEnvironment,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PushCredential]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushCredential copyWith({
    Object? id = _Undefined,
    int? appId,
    _i0unzms6.PushProvider? provider,
    Object? serviceAccountEmail = _Undefined,
    Object? fcmProjectId = _Undefined,
    Object? apnsKeyId = _Undefined,
    Object? apnsTeamId = _Undefined,
    Object? apnsEnvironment = _Undefined,
    DateTime? createdAt,
  }) {
    return PushCredential(
      id: id is int? ? id : this.id,
      appId: appId ?? this.appId,
      provider: provider ?? this.provider,
      serviceAccountEmail: serviceAccountEmail is String?
          ? serviceAccountEmail
          : this.serviceAccountEmail,
      fcmProjectId: fcmProjectId is String? ? fcmProjectId : this.fcmProjectId,
      apnsKeyId: apnsKeyId is String? ? apnsKeyId : this.apnsKeyId,
      apnsTeamId: apnsTeamId is String? ? apnsTeamId : this.apnsTeamId,
      apnsEnvironment: apnsEnvironment is _iy23tayo.ApnsEnvironment?
          ? apnsEnvironment
          : this.apnsEnvironment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
