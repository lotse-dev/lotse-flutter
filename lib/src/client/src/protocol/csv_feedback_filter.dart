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
import 'device_platform.dart' as _ij3iar7l;
import 'feedback_category.dart' as _iju423hp;
import 'feedback_status.dart' as _ipjm5lus;

/// The filters of the feedback inbox for its CSV export, as in
/// ProjectEndpoint.listFeedback.
abstract class CsvFeedbackFilter
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CsvFeedbackFilter._({
    this.status,
    this.category,
    this.platform,
    this.appVersion,
    this.campaign,
    this.waitingForReply,
  });

  factory CsvFeedbackFilter({
    _ipjm5lus.FeedbackStatus? status,
    _iju423hp.FeedbackCategory? category,
    _ij3iar7l.DevicePlatform? platform,
    String? appVersion,
    String? campaign,
    bool? waitingForReply,
  }) = _CsvFeedbackFilterImpl;

  factory CsvFeedbackFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CsvFeedbackFilter(
      status: jsonSerialization['status'] == null
          ? null
          : _ipjm5lus.FeedbackStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      category: jsonSerialization['category'] == null
          ? null
          : _iju423hp.FeedbackCategory.fromJson(
              (jsonSerialization['category'] as String),
            ),
      platform: jsonSerialization['platform'] == null
          ? null
          : _ij3iar7l.DevicePlatform.fromJson(
              (jsonSerialization['platform'] as String),
            ),
      appVersion: jsonSerialization['appVersion'] as String?,
      campaign: jsonSerialization['campaign'] as String?,
      waitingForReply: jsonSerialization['waitingForReply'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['waitingForReply'],
            ),
    );
  }

  _ipjm5lus.FeedbackStatus? status;

  _iju423hp.FeedbackCategory? category;

  _ij3iar7l.DevicePlatform? platform;

  String? appVersion;

  String? campaign;

  bool? waitingForReply;

  /// Returns a shallow copy of this [CsvFeedbackFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CsvFeedbackFilter copyWith({
    _ipjm5lus.FeedbackStatus? status,
    _iju423hp.FeedbackCategory? category,
    _ij3iar7l.DevicePlatform? platform,
    String? appVersion,
    String? campaign,
    bool? waitingForReply,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CsvFeedbackFilter',
      if (status != null) 'status': status?.toJson(),
      if (category != null) 'category': category?.toJson(),
      if (platform != null) 'platform': platform?.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      if (campaign != null) 'campaign': campaign,
      if (waitingForReply != null) 'waitingForReply': waitingForReply,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CsvFeedbackFilter',
      if (status != null) 'status': status?.toJson(),
      if (category != null) 'category': category?.toJson(),
      if (platform != null) 'platform': platform?.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      if (campaign != null) 'campaign': campaign,
      if (waitingForReply != null) 'waitingForReply': waitingForReply,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CsvFeedbackFilterImpl extends CsvFeedbackFilter {
  _CsvFeedbackFilterImpl({
    _ipjm5lus.FeedbackStatus? status,
    _iju423hp.FeedbackCategory? category,
    _ij3iar7l.DevicePlatform? platform,
    String? appVersion,
    String? campaign,
    bool? waitingForReply,
  }) : super._(
         status: status,
         category: category,
         platform: platform,
         appVersion: appVersion,
         campaign: campaign,
         waitingForReply: waitingForReply,
       );

  /// Returns a shallow copy of this [CsvFeedbackFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CsvFeedbackFilter copyWith({
    Object? status = _Undefined,
    Object? category = _Undefined,
    Object? platform = _Undefined,
    Object? appVersion = _Undefined,
    Object? campaign = _Undefined,
    Object? waitingForReply = _Undefined,
  }) {
    return CsvFeedbackFilter(
      status: status is _ipjm5lus.FeedbackStatus? ? status : this.status,
      category: category is _iju423hp.FeedbackCategory?
          ? category
          : this.category,
      platform: platform is _ij3iar7l.DevicePlatform?
          ? platform
          : this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      campaign: campaign is String? ? campaign : this.campaign,
      waitingForReply: waitingForReply is bool?
          ? waitingForReply
          : this.waitingForReply,
    );
  }
}
