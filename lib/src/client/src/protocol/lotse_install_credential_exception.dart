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

/// Thrown when a call needs the secret install credential and the one that
/// came along is missing, wrong or revoked, and when an install that already
/// has or had a credential asks for another one. Knowing the public install
/// id is not enough.
abstract class LotseInstallCredentialException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseInstallCredentialException._({required this.message});

  factory LotseInstallCredentialException({required String message}) =
      _LotseInstallCredentialExceptionImpl;

  factory LotseInstallCredentialException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseInstallCredentialException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [LotseInstallCredentialException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseInstallCredentialException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseInstallCredentialException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseInstallCredentialException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'LotseInstallCredentialException(message: $message)';
  }
}

class _LotseInstallCredentialExceptionImpl
    extends LotseInstallCredentialException {
  _LotseInstallCredentialExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [LotseInstallCredentialException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseInstallCredentialException copyWith({String? message}) {
    return LotseInstallCredentialException(message: message ?? this.message);
  }
}
