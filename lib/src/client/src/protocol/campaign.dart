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
import 'campaign_status.dart' as _iys7xjaz;

/// One push message sent to the devices of a project.
abstract class Campaign
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Campaign._({
    this.id,
    required this.projectId,
    required this.title,
    required this.body,
    this.linkId,
    this.segment,
    required this.status,
    this.scheduledAt,
    this.sendAt,
    this.sendError,
    this.sentAt,
    DateTime? createdAt,
    this.journeyId,
    this.journeyVariant,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Campaign({
    int? id,
    required int projectId,
    required String title,
    required String body,
    int? linkId,
    Map<String, dynamic>? segment,
    required _iys7xjaz.CampaignStatus status,
    DateTime? scheduledAt,
    DateTime? sendAt,
    String? sendError,
    DateTime? sentAt,
    DateTime? createdAt,
    int? journeyId,
    int? journeyVariant,
  }) = _CampaignImpl;

  factory Campaign.fromJson(Map<String, dynamic> jsonSerialization) {
    return Campaign(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      linkId: jsonSerialization['linkId'] as int?,
      segment: jsonSerialization['segment'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, dynamic>>(
              jsonSerialization['segment'],
            ),
      status: _iys7xjaz.CampaignStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      scheduledAt: jsonSerialization['scheduledAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['scheduledAt'],
            ),
      sendAt: jsonSerialization['sendAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sendAt']),
      sendError: jsonSerialization['sendError'] as String?,
      sentAt: jsonSerialization['sentAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['sentAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      journeyId: jsonSerialization['journeyId'] as int?,
      journeyVariant: jsonSerialization['journeyVariant'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  String title;

  String body;

  /// Link whose target path the push opens. Without it the push just opens
  /// the app.
  int? linkId;

  /// Audience predicate, see ARCHITECTURE.md, section "Segmente". Stored
  /// validated; null means every device of the project.
  Map<String, dynamic>? segment;

  _iys7xjaz.CampaignStatus status;

  /// When sendCampaign handed the campaign to the push worker. The daily
  /// send quota counts by it. Not the planned time, that is sendAt.
  DateTime? scheduledAt;

  /// Planned send time of a scheduled campaign, set by scheduleCampaign.
  DateTime? sendAt;

  /// Why a scheduled campaign did not go out at sendAt, for example the
  /// send quota. The server's message, never a credential.
  String? sendError;

  DateTime? sentAt;

  DateTime createdAt;

  /// Set when the campaign is a variant of a journey, see docs/JOURNEYS.md.
  /// Such a campaign stays in status `journey` and never shows up in the
  /// campaign list; it goes with its journey.
  int? journeyId;

  /// 0 for variant A, 1 for B. Set together with journeyId.
  int? journeyVariant;

  /// Returns a shallow copy of this [Campaign]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Campaign copyWith({
    int? id,
    int? projectId,
    String? title,
    String? body,
    int? linkId,
    Map<String, dynamic>? segment,
    _iys7xjaz.CampaignStatus? status,
    DateTime? scheduledAt,
    DateTime? sendAt,
    String? sendError,
    DateTime? sentAt,
    DateTime? createdAt,
    int? journeyId,
    int? journeyVariant,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Campaign',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'body': body,
      if (linkId != null) 'linkId': linkId,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) => _ist2d7e6.Protocol().dynamicFieldToJson(v),
        ),
      'status': status.toJson(),
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (sendAt != null) 'sendAt': sendAt?.toJson(),
      if (sendError != null) 'sendError': sendError,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (journeyId != null) 'journeyId': journeyId,
      if (journeyVariant != null) 'journeyVariant': journeyVariant,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Campaign',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'body': body,
      if (linkId != null) 'linkId': linkId,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) =>
              _ist2d7e6.Protocol().dynamicFieldToJson(v, forProtocol: true),
        ),
      'status': status.toJson(),
      if (scheduledAt != null) 'scheduledAt': scheduledAt?.toJson(),
      if (sendAt != null) 'sendAt': sendAt?.toJson(),
      if (sendError != null) 'sendError': sendError,
      if (sentAt != null) 'sentAt': sentAt?.toJson(),
      'createdAt': createdAt.toJson(),
      if (journeyId != null) 'journeyId': journeyId,
      if (journeyVariant != null) 'journeyVariant': journeyVariant,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CampaignImpl extends Campaign {
  _CampaignImpl({
    int? id,
    required int projectId,
    required String title,
    required String body,
    int? linkId,
    Map<String, dynamic>? segment,
    required _iys7xjaz.CampaignStatus status,
    DateTime? scheduledAt,
    DateTime? sendAt,
    String? sendError,
    DateTime? sentAt,
    DateTime? createdAt,
    int? journeyId,
    int? journeyVariant,
  }) : super._(
         id: id,
         projectId: projectId,
         title: title,
         body: body,
         linkId: linkId,
         segment: segment,
         status: status,
         scheduledAt: scheduledAt,
         sendAt: sendAt,
         sendError: sendError,
         sentAt: sentAt,
         createdAt: createdAt,
         journeyId: journeyId,
         journeyVariant: journeyVariant,
       );

  /// Returns a shallow copy of this [Campaign]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Campaign copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? title,
    String? body,
    Object? linkId = _Undefined,
    Object? segment = _Undefined,
    _iys7xjaz.CampaignStatus? status,
    Object? scheduledAt = _Undefined,
    Object? sendAt = _Undefined,
    Object? sendError = _Undefined,
    Object? sentAt = _Undefined,
    DateTime? createdAt,
    Object? journeyId = _Undefined,
    Object? journeyVariant = _Undefined,
  }) {
    return Campaign(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      body: body ?? this.body,
      linkId: linkId is int? ? linkId : this.linkId,
      segment: segment is Map<String, dynamic>?
          ? segment
          : this.segment?.map((key0, value0) => MapEntry(key0, value0)),
      status: status ?? this.status,
      scheduledAt: scheduledAt is DateTime? ? scheduledAt : this.scheduledAt,
      sendAt: sendAt is DateTime? ? sendAt : this.sendAt,
      sendError: sendError is String? ? sendError : this.sendError,
      sentAt: sentAt is DateTime? ? sentAt : this.sentAt,
      createdAt: createdAt ?? this.createdAt,
      journeyId: journeyId is int? ? journeyId : this.journeyId,
      journeyVariant: journeyVariant is int?
          ? journeyVariant
          : this.journeyVariant,
    );
  }
}
