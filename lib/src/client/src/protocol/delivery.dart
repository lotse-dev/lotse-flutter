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
import 'delivery_status.dart' as _ib7m4h6q;

/// One push of one campaign to one device. The unique index is what makes it
/// one: a second `sendCampaign` of the same campaign cannot add a row for a
/// device that already has one.
abstract class Delivery
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Delivery._({
    this.id,
    required this.campaignId,
    required this.deviceId,
    required this.status,
    int? attempts,
    this.providerMessageId,
    this.error,
    DateTime? ts,
  }) : attempts = attempts ?? 0,
       ts = ts ?? DateTime.now();

  factory Delivery({
    int? id,
    required int campaignId,
    required int deviceId,
    required _ib7m4h6q.DeliveryStatus status,
    int? attempts,
    String? providerMessageId,
    String? error,
    DateTime? ts,
  }) = _DeliveryImpl;

  factory Delivery.fromJson(Map<String, dynamic> jsonSerialization) {
    return Delivery(
      id: jsonSerialization['id'] as int?,
      campaignId: jsonSerialization['campaignId'] as int,
      deviceId: jsonSerialization['deviceId'] as int,
      status: _ib7m4h6q.DeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      attempts: jsonSerialization['attempts'] as int?,
      providerMessageId: jsonSerialization['providerMessageId'] as String?,
      error: jsonSerialization['error'] as String?,
      ts: jsonSerialization['ts'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int campaignId;

  int deviceId;

  _ib7m4h6q.DeliveryStatus status;

  int attempts;

  /// Message name the provider returned, kept for support questions.
  String? providerMessageId;

  String? error;

  DateTime ts;

  /// Returns a shallow copy of this [Delivery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Delivery copyWith({
    int? id,
    int? campaignId,
    int? deviceId,
    _ib7m4h6q.DeliveryStatus? status,
    int? attempts,
    String? providerMessageId,
    String? error,
    DateTime? ts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Delivery',
      if (id != null) 'id': id,
      'campaignId': campaignId,
      'deviceId': deviceId,
      'status': status.toJson(),
      'attempts': attempts,
      if (providerMessageId != null) 'providerMessageId': providerMessageId,
      if (error != null) 'error': error,
      'ts': ts.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Delivery',
      if (id != null) 'id': id,
      'campaignId': campaignId,
      'deviceId': deviceId,
      'status': status.toJson(),
      'attempts': attempts,
      if (providerMessageId != null) 'providerMessageId': providerMessageId,
      if (error != null) 'error': error,
      'ts': ts.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeliveryImpl extends Delivery {
  _DeliveryImpl({
    int? id,
    required int campaignId,
    required int deviceId,
    required _ib7m4h6q.DeliveryStatus status,
    int? attempts,
    String? providerMessageId,
    String? error,
    DateTime? ts,
  }) : super._(
         id: id,
         campaignId: campaignId,
         deviceId: deviceId,
         status: status,
         attempts: attempts,
         providerMessageId: providerMessageId,
         error: error,
         ts: ts,
       );

  /// Returns a shallow copy of this [Delivery]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Delivery copyWith({
    Object? id = _Undefined,
    int? campaignId,
    int? deviceId,
    _ib7m4h6q.DeliveryStatus? status,
    int? attempts,
    Object? providerMessageId = _Undefined,
    Object? error = _Undefined,
    DateTime? ts,
  }) {
    return Delivery(
      id: id is int? ? id : this.id,
      campaignId: campaignId ?? this.campaignId,
      deviceId: deviceId ?? this.deviceId,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      providerMessageId: providerMessageId is String?
          ? providerMessageId
          : this.providerMessageId,
      error: error is String? ? error : this.error,
      ts: ts ?? this.ts,
    );
  }
}
