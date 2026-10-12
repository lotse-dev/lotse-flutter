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

/// What one in-app message achieved, from
/// `AnalyticsEndpoint.inAppMessageReport`. Every figure counts distinct
/// devices of the project whose events carry the id of the message, from
/// startedAt on.
abstract class InAppMessageReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InAppMessageReport._({
    required this.messageId,
    this.audience,
    required this.viewed,
    required this.tapped,
    required this.dismissed,
    required this.measuredAt,
  });

  factory InAppMessageReport({
    required int messageId,
    int? audience,
    required int viewed,
    required int tapped,
    required int dismissed,
    required DateTime measuredAt,
  }) = _InAppMessageReportImpl;

  factory InAppMessageReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return InAppMessageReport(
      messageId: jsonSerialization['messageId'] as int,
      audience: jsonSerialization['audience'] as int?,
      viewed: jsonSerialization['viewed'] as int,
      tapped: jsonSerialization['tapped'] as int,
      dismissed: jsonSerialization['dismissed'] as int,
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
    );
  }

  int messageId;

  /// Devices the segment matches right now. Null for an ended message.
  int? audience;

  /// Devices that tracked in_app_view.
  int viewed;

  /// Devices that tracked in_app_tap.
  int tapped;

  /// Devices that tracked in_app_dismiss.
  int dismissed;

  DateTime measuredAt;

  /// Returns a shallow copy of this [InAppMessageReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InAppMessageReport copyWith({
    int? messageId,
    int? audience,
    int? viewed,
    int? tapped,
    int? dismissed,
    DateTime? measuredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppMessageReport',
      'messageId': messageId,
      if (audience != null) 'audience': audience,
      'viewed': viewed,
      'tapped': tapped,
      'dismissed': dismissed,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InAppMessageReport',
      'messageId': messageId,
      if (audience != null) 'audience': audience,
      'viewed': viewed,
      'tapped': tapped,
      'dismissed': dismissed,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InAppMessageReportImpl extends InAppMessageReport {
  _InAppMessageReportImpl({
    required int messageId,
    int? audience,
    required int viewed,
    required int tapped,
    required int dismissed,
    required DateTime measuredAt,
  }) : super._(
         messageId: messageId,
         audience: audience,
         viewed: viewed,
         tapped: tapped,
         dismissed: dismissed,
         measuredAt: measuredAt,
       );

  /// Returns a shallow copy of this [InAppMessageReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InAppMessageReport copyWith({
    int? messageId,
    Object? audience = _Undefined,
    int? viewed,
    int? tapped,
    int? dismissed,
    DateTime? measuredAt,
  }) {
    return InAppMessageReport(
      messageId: messageId ?? this.messageId,
      audience: audience is int? ? audience : this.audience,
      viewed: viewed ?? this.viewed,
      tapped: tapped ?? this.tapped,
      dismissed: dismissed ?? this.dismissed,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }
}
