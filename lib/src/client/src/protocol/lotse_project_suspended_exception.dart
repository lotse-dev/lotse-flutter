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

/// Thrown when the owner of a suspended project tries to change it or make
/// it act outside, e.g. create a link or send a campaign.
abstract class LotseProjectSuspendedException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseProjectSuspendedException._({required this.message});

  factory LotseProjectSuspendedException({required String message}) =
      _LotseProjectSuspendedExceptionImpl;

  factory LotseProjectSuspendedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseProjectSuspendedException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [LotseProjectSuspendedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseProjectSuspendedException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseProjectSuspendedException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseProjectSuspendedException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'LotseProjectSuspendedException(message: $message)';
  }
}

class _LotseProjectSuspendedExceptionImpl
    extends LotseProjectSuspendedException {
  _LotseProjectSuspendedExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [LotseProjectSuspendedException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseProjectSuspendedException copyWith({String? message}) {
    return LotseProjectSuspendedException(message: message ?? this.message);
  }
}
