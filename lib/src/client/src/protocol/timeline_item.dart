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
import 'package:lotse/src/client/src/protocol/protocol.dart' as _ist2d7e6;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'timeline_item_kind.dart' as _i9cf7i61;

/// One entry of a Timeline.
abstract class TimelineItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TimelineItem._({
    required this.kind,
    required this.ts,
    required this.deviceId,
    required this.title,
    this.props,
    this.status,
    this.appVersion,
    this.feedbackId,
    this.campaignId,
    this.linkId,
  });

  factory TimelineItem({
    required _i9cf7i61.TimelineItemKind kind,
    required DateTime ts,
    required int deviceId,
    required String title,
    Map<String, String>? props,
    String? status,
    String? appVersion,
    int? feedbackId,
    int? campaignId,
    int? linkId,
  }) = _TimelineItemImpl;

  factory TimelineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return TimelineItem(
      kind: _i9cf7i61.TimelineItemKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      ts: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['ts']),
      deviceId: jsonSerialization['deviceId'] as int,
      title: jsonSerialization['title'] as String,
      props: jsonSerialization['props'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['props'],
            ),
      status: jsonSerialization['status'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      feedbackId: jsonSerialization['feedbackId'] as int?,
      campaignId: jsonSerialization['campaignId'] as int?,
      linkId: jsonSerialization['linkId'] as int?,
    );
  }

  _i9cf7i61.TimelineItemKind kind;

  DateTime ts;

  int deviceId;

  /// Event name, campaign title, feedback category, link slug; the
  /// platform for an install.
  String title;

  /// Event props; campaign, source and medium of a clicked link. At most
  /// the first 140 characters of a feedback text under "message".
  Map<String, String>? props;

  /// Feedback status, delivery status, attribution source.
  String? status;

  /// Event: event.appVersion. Install: the device's current version.
  String? appVersion;

  int? feedbackId;

  int? campaignId;

  int? linkId;

  /// Returns a shallow copy of this [TimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TimelineItem copyWith({
    _i9cf7i61.TimelineItemKind? kind,
    DateTime? ts,
    int? deviceId,
    String? title,
    Map<String, String>? props,
    String? status,
    String? appVersion,
    int? feedbackId,
    int? campaignId,
    int? linkId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TimelineItem',
      'kind': kind.toJson(),
      'ts': ts.toJson(),
      'deviceId': deviceId,
      'title': title,
      if (props != null) 'props': props?.toJson(),
      if (status != null) 'status': status,
      if (appVersion != null) 'appVersion': appVersion,
      if (feedbackId != null) 'feedbackId': feedbackId,
      if (campaignId != null) 'campaignId': campaignId,
      if (linkId != null) 'linkId': linkId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TimelineItem',
      'kind': kind.toJson(),
      'ts': ts.toJson(),
      'deviceId': deviceId,
      'title': title,
      if (props != null) 'props': props?.toJson(),
      if (status != null) 'status': status,
      if (appVersion != null) 'appVersion': appVersion,
      if (feedbackId != null) 'feedbackId': feedbackId,
      if (campaignId != null) 'campaignId': campaignId,
      if (linkId != null) 'linkId': linkId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TimelineItemImpl extends TimelineItem {
  _TimelineItemImpl({
    required _i9cf7i61.TimelineItemKind kind,
    required DateTime ts,
    required int deviceId,
    required String title,
    Map<String, String>? props,
    String? status,
    String? appVersion,
    int? feedbackId,
    int? campaignId,
    int? linkId,
  }) : super._(
         kind: kind,
         ts: ts,
         deviceId: deviceId,
         title: title,
         props: props,
         status: status,
         appVersion: appVersion,
         feedbackId: feedbackId,
         campaignId: campaignId,
         linkId: linkId,
       );

  /// Returns a shallow copy of this [TimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TimelineItem copyWith({
    _i9cf7i61.TimelineItemKind? kind,
    DateTime? ts,
    int? deviceId,
    String? title,
    Object? props = _Undefined,
    Object? status = _Undefined,
    Object? appVersion = _Undefined,
    Object? feedbackId = _Undefined,
    Object? campaignId = _Undefined,
    Object? linkId = _Undefined,
  }) {
    return TimelineItem(
      kind: kind ?? this.kind,
      ts: ts ?? this.ts,
      deviceId: deviceId ?? this.deviceId,
      title: title ?? this.title,
      props: props is Map<String, String>?
          ? props
          : this.props?.map((key0, value0) => MapEntry(key0, value0)),
      status: status is String? ? status : this.status,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      feedbackId: feedbackId is int? ? feedbackId : this.feedbackId,
      campaignId: campaignId is int? ? campaignId : this.campaignId,
      linkId: linkId is int? ? linkId : this.linkId,
    );
  }
}
