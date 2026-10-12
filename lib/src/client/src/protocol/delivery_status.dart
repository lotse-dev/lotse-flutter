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

/// Outcome of one push to one device.
enum DeliveryStatus implements _isc.SerializableModel {
  pending,

  /// Claimed by a worker run, not answered by the provider yet.
  sending,
  sent,
  failed,

  /// The provider rejected the token. Never retried.
  invalidToken;

  static DeliveryStatus fromJson(String name) {
    switch (name) {
      case 'pending':
        return DeliveryStatus.pending;
      case 'sending':
        return DeliveryStatus.sending;
      case 'sent':
        return DeliveryStatus.sent;
      case 'failed':
        return DeliveryStatus.failed;
      case 'invalidToken':
        return DeliveryStatus.invalidToken;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "DeliveryStatus"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
