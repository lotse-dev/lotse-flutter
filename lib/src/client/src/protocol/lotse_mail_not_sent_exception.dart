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

/// Thrown when a mail the caller waits for, like an invitation, could not be
/// handed to the relay. Carries no address and no detail of the relay's reply.
abstract class LotseMailNotSentException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseMailNotSentException._({required this.message});

  factory LotseMailNotSentException({required String message}) =
      _LotseMailNotSentExceptionImpl;

  factory LotseMailNotSentException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseMailNotSentException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [LotseMailNotSentException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseMailNotSentException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {'__className__': 'LotseMailNotSentException', 'message': message};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'__className__': 'LotseMailNotSentException', 'message': message};
  }

  @override
  String toString() {
    return 'LotseMailNotSentException(message: $message)';
  }
}

class _LotseMailNotSentExceptionImpl extends LotseMailNotSentException {
  _LotseMailNotSentExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [LotseMailNotSentException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseMailNotSentException copyWith({String? message}) {
    return LotseMailNotSentException(message: message ?? this.message);
  }
}
