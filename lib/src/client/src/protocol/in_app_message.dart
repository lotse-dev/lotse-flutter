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
import 'in_app_message_status.dart' as _ihkv7mfu;
import 'in_app_message_style.dart' as _iv76hups;

/// A card or banner the SDK shows inside the app to the devices of a
/// segment, see ARCHITECTURE.md, section "In-App-Nachrichten". The device
/// fetches the active messages on start; the server checks the segment for
/// that device at that moment. Views, taps and dismissals are events.
abstract class InAppMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  InAppMessage._({
    this.id,
    required this.projectId,
    required this.title,
    required this.body,
    required this.style,
    this.linkId,
    this.buttonLabel,
    this.segment,
    required this.status,
    this.startedAt,
    this.endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory InAppMessage({
    int? id,
    required int projectId,
    required String title,
    required String body,
    required _iv76hups.InAppMessageStyle style,
    int? linkId,
    String? buttonLabel,
    Map<String, dynamic>? segment,
    required _ihkv7mfu.InAppMessageStatus status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _InAppMessageImpl;

  factory InAppMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return InAppMessage(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      title: jsonSerialization['title'] as String,
      body: jsonSerialization['body'] as String,
      style: _iv76hups.InAppMessageStyle.fromJson(
        (jsonSerialization['style'] as String),
      ),
      linkId: jsonSerialization['linkId'] as int?,
      buttonLabel: jsonSerialization['buttonLabel'] as String?,
      segment: jsonSerialization['segment'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, dynamic>>(
              jsonSerialization['segment'],
            ),
      status: _ihkv7mfu.InAppMessageStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// Trimmed, 1 to 80 characters.
  String title;

  /// Trimmed, 1 to 500 characters.
  String body;

  _iv76hups.InAppMessageStyle style;

  /// Link whose target path a tap opens, the same deep link as a push.
  /// Without it a tap only closes the message.
  int? linkId;

  /// Label of the button of a card, 1 to 30 characters. Null for the
  /// SDK's "Open".
  String? buttonLabel;

  /// Audience predicate, see ARCHITECTURE.md, section "Segmente". Stored
  /// validated; null means every device of the project.
  Map<String, dynamic>? segment;

  _ihkv7mfu.InAppMessageStatus status;

  /// When the message became active. Its report counts events from here.
  DateTime? startedAt;

  DateTime? endedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [InAppMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  InAppMessage copyWith({
    int? id,
    int? projectId,
    String? title,
    String? body,
    _iv76hups.InAppMessageStyle? style,
    int? linkId,
    String? buttonLabel,
    Map<String, dynamic>? segment,
    _ihkv7mfu.InAppMessageStatus? status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'InAppMessage',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'body': body,
      'style': style.toJson(),
      if (linkId != null) 'linkId': linkId,
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) => _ist2d7e6.Protocol().dynamicFieldToJson(v),
        ),
      'status': status.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'InAppMessage',
      if (id != null) 'id': id,
      'projectId': projectId,
      'title': title,
      'body': body,
      'style': style.toJson(),
      if (linkId != null) 'linkId': linkId,
      if (buttonLabel != null) 'buttonLabel': buttonLabel,
      if (segment != null)
        'segment': segment?.toJson(
          valueToJson: (v) =>
              _ist2d7e6.Protocol().dynamicFieldToJson(v, forProtocol: true),
        ),
      'status': status.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InAppMessageImpl extends InAppMessage {
  _InAppMessageImpl({
    int? id,
    required int projectId,
    required String title,
    required String body,
    required _iv76hups.InAppMessageStyle style,
    int? linkId,
    String? buttonLabel,
    Map<String, dynamic>? segment,
    required _ihkv7mfu.InAppMessageStatus status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         title: title,
         body: body,
         style: style,
         linkId: linkId,
         buttonLabel: buttonLabel,
         segment: segment,
         status: status,
         startedAt: startedAt,
         endedAt: endedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [InAppMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  InAppMessage copyWith({
    Object? id = _Undefined,
    int? projectId,
    String? title,
    String? body,
    _iv76hups.InAppMessageStyle? style,
    Object? linkId = _Undefined,
    Object? buttonLabel = _Undefined,
    Object? segment = _Undefined,
    _ihkv7mfu.InAppMessageStatus? status,
    Object? startedAt = _Undefined,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InAppMessage(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      body: body ?? this.body,
      style: style ?? this.style,
      linkId: linkId is int? ? linkId : this.linkId,
      buttonLabel: buttonLabel is String? ? buttonLabel : this.buttonLabel,
      segment: segment is Map<String, dynamic>?
          ? segment
          : this.segment?.map((key0, value0) => MapEntry(key0, value0)),
      status: status ?? this.status,
      startedAt: startedAt is DateTime? ? startedAt : this.startedAt,
      endedAt: endedAt is DateTime? ? endedAt : this.endedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
