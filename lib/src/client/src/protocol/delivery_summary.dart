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

/// Deliveries of one campaign, counted per status.
abstract class DeliverySummary
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeliverySummary._({
    required this.pending,
    required this.sending,
    required this.sent,
    required this.failed,
    required this.invalidToken,
  });

  factory DeliverySummary({
    required int pending,
    required int sending,
    required int sent,
    required int failed,
    required int invalidToken,
  }) = _DeliverySummaryImpl;

  factory DeliverySummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeliverySummary(
      pending: jsonSerialization['pending'] as int,
      sending: jsonSerialization['sending'] as int,
      sent: jsonSerialization['sent'] as int,
      failed: jsonSerialization['failed'] as int,
      invalidToken: jsonSerialization['invalidToken'] as int,
    );
  }

  int pending;

  int sending;

  int sent;

  int failed;

  int invalidToken;

  /// Returns a shallow copy of this [DeliverySummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeliverySummary copyWith({
    int? pending,
    int? sending,
    int? sent,
    int? failed,
    int? invalidToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeliverySummary',
      'pending': pending,
      'sending': sending,
      'sent': sent,
      'failed': failed,
      'invalidToken': invalidToken,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeliverySummary',
      'pending': pending,
      'sending': sending,
      'sent': sent,
      'failed': failed,
      'invalidToken': invalidToken,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DeliverySummaryImpl extends DeliverySummary {
  _DeliverySummaryImpl({
    required int pending,
    required int sending,
    required int sent,
    required int failed,
    required int invalidToken,
  }) : super._(
         pending: pending,
         sending: sending,
         sent: sent,
         failed: failed,
         invalidToken: invalidToken,
       );

  /// Returns a shallow copy of this [DeliverySummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeliverySummary copyWith({
    int? pending,
    int? sending,
    int? sent,
    int? failed,
    int? invalidToken,
  }) {
    return DeliverySummary(
      pending: pending ?? this.pending,
      sending: sending ?? this.sending,
      sent: sent ?? this.sent,
      failed: failed ?? this.failed,
      invalidToken: invalidToken ?? this.invalidToken,
    );
  }
}
