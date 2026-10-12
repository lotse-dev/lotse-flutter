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

/// Thrown when a value that must be unique is already taken, e.g. a link slug.
abstract class LotseConflictException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseConflictException._({required this.message});

  factory LotseConflictException({required String message}) =
      _LotseConflictExceptionImpl;

  factory LotseConflictException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseConflictException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [LotseConflictException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseConflictException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseConflictException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseConflictException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'LotseConflictException(message: $message)';
  }
}

class _LotseConflictExceptionImpl extends LotseConflictException {
  _LotseConflictExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [LotseConflictException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseConflictException copyWith({String? message}) {
    return LotseConflictException(message: message ?? this.message);
  }
}
