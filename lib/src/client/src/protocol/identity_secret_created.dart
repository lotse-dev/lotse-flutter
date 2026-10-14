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
import 'identity_verification_status.dart' as _il6qcl22;

/// Returned once when an identity secret is generated. The secret is never
/// shown again.
abstract class IdentitySecretCreated
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IdentitySecretCreated._({required this.secret, required this.status});

  factory IdentitySecretCreated({
    required String secret,
    required _il6qcl22.IdentityVerificationStatus status,
  }) = _IdentitySecretCreatedImpl;

  factory IdentitySecretCreated.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return IdentitySecretCreated(
      secret: jsonSerialization['secret'] as String,
      status: _ist2d7e6.Protocol()
          .deserialize<_il6qcl22.IdentityVerificationStatus>(
            jsonSerialization['status'],
          ),
    );
  }

  String secret;

  _il6qcl22.IdentityVerificationStatus status;

  /// Returns a shallow copy of this [IdentitySecretCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IdentitySecretCreated copyWith({
    String? secret,
    _il6qcl22.IdentityVerificationStatus? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IdentitySecretCreated',
      'secret': secret,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IdentitySecretCreated',
      'secret': secret,
      'status': status.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _IdentitySecretCreatedImpl extends IdentitySecretCreated {
  _IdentitySecretCreatedImpl({
    required String secret,
    required _il6qcl22.IdentityVerificationStatus status,
  }) : super._(secret: secret, status: status);

  /// Returns a shallow copy of this [IdentitySecretCreated]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IdentitySecretCreated copyWith({
    String? secret,
    _il6qcl22.IdentityVerificationStatus? status,
  }) {
    return IdentitySecretCreated(
      secret: secret ?? this.secret,
      status: status ?? this.status.copyWith(),
    );
  }
}
