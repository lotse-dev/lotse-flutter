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

/// One answer in the console, from `AnalyticsEndpoint.surveyResponses`.
abstract class SurveyResponseItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SurveyResponseItem._({
    required this.id,
    required this.deviceId,
    required this.platform,
    this.appVersion,
    this.campaign,
    this.score,
    this.choice,
    this.comment,
    required this.createdAt,
  });

  factory SurveyResponseItem({
    required int id,
    required int deviceId,
    required _ij3iar7l.DevicePlatform platform,
    String? appVersion,
    String? campaign,
    int? score,
    int? choice,
    String? comment,
    required DateTime createdAt,
  }) = _SurveyResponseItemImpl;

  factory SurveyResponseItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return SurveyResponseItem(
      id: jsonSerialization['id'] as int,
      deviceId: jsonSerialization['deviceId'] as int,
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      appVersion: jsonSerialization['appVersion'] as String?,
      campaign: jsonSerialization['campaign'] as String?,
      score: jsonSerialization['score'] as int?,
      choice: jsonSerialization['choice'] as int?,
      comment: jsonSerialization['comment'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  int deviceId;

  _ij3iar7l.DevicePlatform platform;

  String? appVersion;

  /// Campaign of the link the device is attributed to, null for organic.
  String? campaign;

  int? score;

  int? choice;

  String? comment;

  DateTime createdAt;

  /// Returns a shallow copy of this [SurveyResponseItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SurveyResponseItem copyWith({
    int? id,
    int? deviceId,
    _ij3iar7l.DevicePlatform? platform,
    String? appVersion,
    String? campaign,
    int? score,
    int? choice,
    String? comment,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SurveyResponseItem',
      'id': id,
      'deviceId': deviceId,
      'platform': platform.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      if (campaign != null) 'campaign': campaign,
      if (score != null) 'score': score,
      if (choice != null) 'choice': choice,
      if (comment != null) 'comment': comment,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SurveyResponseItem',
      'id': id,
      'deviceId': deviceId,
      'platform': platform.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      if (campaign != null) 'campaign': campaign,
      if (score != null) 'score': score,
      if (choice != null) 'choice': choice,
      if (comment != null) 'comment': comment,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SurveyResponseItemImpl extends SurveyResponseItem {
  _SurveyResponseItemImpl({
    required int id,
    required int deviceId,
    required _ij3iar7l.DevicePlatform platform,
    String? appVersion,
    String? campaign,
    int? score,
    int? choice,
    String? comment,
    required DateTime createdAt,
  }) : super._(
         id: id,
         deviceId: deviceId,
         platform: platform,
         appVersion: appVersion,
         campaign: campaign,
         score: score,
         choice: choice,
         comment: comment,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [SurveyResponseItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SurveyResponseItem copyWith({
    int? id,
    int? deviceId,
    _ij3iar7l.DevicePlatform? platform,
    Object? appVersion = _Undefined,
    Object? campaign = _Undefined,
    Object? score = _Undefined,
    Object? choice = _Undefined,
    Object? comment = _Undefined,
    DateTime? createdAt,
  }) {
    return SurveyResponseItem(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      campaign: campaign is String? ? campaign : this.campaign,
      score: score is int? ? score : this.score,
      choice: choice is int? ? choice : this.choice,
      comment: comment is String? ? comment : this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
