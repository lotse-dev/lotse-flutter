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

/// Thrown when a device opens a support chat in a project that has the chat
/// switched off.
abstract class LotseSupportChatDisabledException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseSupportChatDisabledException._({required this.message});

  factory LotseSupportChatDisabledException({required String message}) =
      _LotseSupportChatDisabledExceptionImpl;

  factory LotseSupportChatDisabledException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseSupportChatDisabledException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [LotseSupportChatDisabledException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseSupportChatDisabledException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseSupportChatDisabledException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseSupportChatDisabledException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'LotseSupportChatDisabledException(message: $message)';
  }
}

class _LotseSupportChatDisabledExceptionImpl
    extends LotseSupportChatDisabledException {
  _LotseSupportChatDisabledExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [LotseSupportChatDisabledException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseSupportChatDisabledException copyWith({String? message}) {
    return LotseSupportChatDisabledException(message: message ?? this.message);
  }
}
