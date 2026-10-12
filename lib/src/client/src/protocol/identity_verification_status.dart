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

/// What the console sees of the identity verification of a project: whether
/// there is a secret, since when, and whether identify requires a valid user
/// hash. Never the secret itself.
abstract class IdentityVerificationStatus
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IdentityVerificationStatus._({
    required this.hasSecret,
    this.secretCreatedAt,
    required this.verificationRequired,
  });

  factory IdentityVerificationStatus({
    required bool hasSecret,
    DateTime? secretCreatedAt,
    required bool verificationRequired,
  }) = _IdentityVerificationStatusImpl;

  factory IdentityVerificationStatus.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IdentityVerificationStatus(
      hasSecret: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['hasSecret'],
      ),
      secretCreatedAt: jsonSerialization['secretCreatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['secretCreatedAt'],
            ),
      verificationRequired: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['verificationRequired'],
      ),
    );
  }

  bool hasSecret;

  /// When the current secret was generated; null without a secret.
  DateTime? secretCreatedAt;

  /// Whether identify refuses a call without a valid user hash. Never true
  /// without a secret.
  bool verificationRequired;

  /// Returns a shallow copy of this [IdentityVerificationStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IdentityVerificationStatus copyWith({
    bool? hasSecret,
    DateTime? secretCreatedAt,
    bool? verificationRequired,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdentityVerificationStatus',
      'hasSecret': hasSecret,
      if (secretCreatedAt != null) 'secretCreatedAt': secretCreatedAt?.toJson(),
      'verificationRequired': verificationRequired,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdentityVerificationStatus',
      'hasSecret': hasSecret,
      if (secretCreatedAt != null) 'secretCreatedAt': secretCreatedAt?.toJson(),
      'verificationRequired': verificationRequired,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IdentityVerificationStatusImpl extends IdentityVerificationStatus {
  _IdentityVerificationStatusImpl({
    required bool hasSecret,
    DateTime? secretCreatedAt,
    required bool verificationRequired,
  }) : super._(
         hasSecret: hasSecret,
         secretCreatedAt: secretCreatedAt,
         verificationRequired: verificationRequired,
       );

  /// Returns a shallow copy of this [IdentityVerificationStatus]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IdentityVerificationStatus copyWith({
    bool? hasSecret,
    Object? secretCreatedAt = _Undefined,
    bool? verificationRequired,
  }) {
    return IdentityVerificationStatus(
      hasSecret: hasSecret ?? this.hasSecret,
      secretCreatedAt: secretCreatedAt is DateTime?
          ? secretCreatedAt
          : this.secretCreatedAt,
      verificationRequired: verificationRequired ?? this.verificationRequired,
    );
  }
}
