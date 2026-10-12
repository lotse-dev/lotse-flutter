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
import 'push_provider.dart' as _i0unzms6;

/// Provider registration token of one device.
abstract class PushToken
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PushToken._({
    this.id,
    required this.deviceId,
    required this.provider,
    DateTime? updatedAt,
    this.invalidAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  factory PushToken({
    int? id,
    required int deviceId,
    required _i0unzms6.PushProvider provider,
    DateTime? updatedAt,
    DateTime? invalidAt,
  }) = _PushTokenImpl;

  factory PushToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushToken(
      id: jsonSerialization['id'] as int?,
      deviceId: jsonSerialization['deviceId'] as int,
      provider: _i0unzms6.PushProvider.fromJson(
        (jsonSerialization['provider'] as String),
      ),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      invalidAt: jsonSerialization['invalidAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['invalidAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int deviceId;

  _i0unzms6.PushProvider provider;

  DateTime updatedAt;

  /// Set when the provider rejected the token, cleared when the device
  /// reports a token again.
  DateTime? invalidAt;

  /// Returns a shallow copy of this [PushToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PushToken copyWith({
    int? id,
    int? deviceId,
    _i0unzms6.PushProvider? provider,
    DateTime? updatedAt,
    DateTime? invalidAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PushToken',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'provider': provider.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (invalidAt != null) 'invalidAt': invalidAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PushToken',
      if (id != null) 'id': id,
      'deviceId': deviceId,
      'provider': provider.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (invalidAt != null) 'invalidAt': invalidAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushTokenImpl extends PushToken {
  _PushTokenImpl({
    int? id,
    required int deviceId,
    required _i0unzms6.PushProvider provider,
    DateTime? updatedAt,
    DateTime? invalidAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         provider: provider,
         updatedAt: updatedAt,
         invalidAt: invalidAt,
       );

  /// Returns a shallow copy of this [PushToken]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PushToken copyWith({
    Object? id = _Undefined,
    int? deviceId,
    _i0unzms6.PushProvider? provider,
    DateTime? updatedAt,
    Object? invalidAt = _Undefined,
  }) {
    return PushToken(
      id: id is int? ? id : this.id,
      deviceId: deviceId ?? this.deviceId,
      provider: provider ?? this.provider,
      updatedAt: updatedAt ?? this.updatedAt,
      invalidAt: invalidAt is DateTime? ? invalidAt : this.invalidAt,
    );
  }
}
