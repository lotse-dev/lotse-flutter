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

/// Thrown when creating one more of [resource] would exceed a fixed quota,
/// see lib/src/projects/quotas.dart.
abstract class LotseQuotaExceededException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  LotseQuotaExceededException._({
    required this.resource,
    required this.limit,
    required this.message,
  });

  factory LotseQuotaExceededException({
    required String resource,
    required int limit,
    required String message,
  }) = _LotseQuotaExceededExceptionImpl;

  factory LotseQuotaExceededException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return LotseQuotaExceededException(
      resource: jsonSerialization['resource'] as String,
      limit: jsonSerialization['limit'] as int,
      message: jsonSerialization['message'] as String,
    );
  }

  /// What ran out, e.g. "links per project".
  String resource;

  int limit;

  String message;

  /// Returns a shallow copy of this [LotseQuotaExceededException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  LotseQuotaExceededException copyWith({
    String? resource,
    int? limit,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LotseQuotaExceededException',
      'resource': resource,
      'limit': limit,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LotseQuotaExceededException',
      'resource': resource,
      'limit': limit,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'LotseQuotaExceededException(resource: $resource, limit: $limit, message: $message)';
  }
}

class _LotseQuotaExceededExceptionImpl extends LotseQuotaExceededException {
  _LotseQuotaExceededExceptionImpl({
    required String resource,
    required int limit,
    required String message,
  }) : super._(
         resource: resource,
         limit: limit,
         message: message,
       );

  /// Returns a shallow copy of this [LotseQuotaExceededException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  LotseQuotaExceededException copyWith({
    String? resource,
    int? limit,
    String? message,
  }) {
    return LotseQuotaExceededException(
      resource: resource ?? this.resource,
      limit: limit ?? this.limit,
      message: message ?? this.message,
    );
  }
}
