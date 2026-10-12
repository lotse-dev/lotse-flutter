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
import 'feedback_message_author.dart' as _imklq58l;
import 'feedback_push_status.dart' as _ipimo89r;

/// One reply in the conversation of a feedback message. The message that
/// opened the conversation is `feedback.message` and has no row here.
abstract class FeedbackMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackMessage._({
    this.id,
    required this.feedbackId,
    required this.projectId,
    required this.author,
    required this.body,
    DateTime? createdAt,
    this.readAt,
    this.pushStatus,
    this.pushError,
  }) : createdAt = createdAt ?? DateTime.now();

  factory FeedbackMessage({
    int? id,
    required int feedbackId,
    required int projectId,
    required _imklq58l.FeedbackMessageAuthor author,
    required String body,
    DateTime? createdAt,
    DateTime? readAt,
    _ipimo89r.FeedbackPushStatus? pushStatus,
    String? pushError,
  }) = _FeedbackMessageImpl;

  factory FeedbackMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackMessage(
      id: jsonSerialization['id'] as int?,
      feedbackId: jsonSerialization['feedbackId'] as int,
      projectId: jsonSerialization['projectId'] as int,
      author: _imklq58l.FeedbackMessageAuthor.fromJson(
        (jsonSerialization['author'] as String),
      ),
      body: jsonSerialization['body'] as String,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      readAt: jsonSerialization['readAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['readAt']),
      pushStatus: jsonSerialization['pushStatus'] == null
          ? null
          : _ipimo89r.FeedbackPushStatus.fromJson(
              (jsonSerialization['pushStatus'] as String),
            ),
      pushError: jsonSerialization['pushError'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int feedbackId;

  /// Redundant on purpose, like on feedback_screenshot: the tenant filter
  /// hangs on the table itself.
  int projectId;

  _imklq58l.FeedbackMessageAuthor author;

  String body;

  DateTime createdAt;

  /// When the other side read the message.
  DateTime? readAt;

  /// Only on team replies: outcome of the push to the device.
  _ipimo89r.FeedbackPushStatus? pushStatus;

  /// Why the push failed. Never carries a token or a credential.
  String? pushError;

  /// Returns a shallow copy of this [FeedbackMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackMessage copyWith({
    int? id,
    int? feedbackId,
    int? projectId,
    _imklq58l.FeedbackMessageAuthor? author,
    String? body,
    DateTime? createdAt,
    DateTime? readAt,
    _ipimo89r.FeedbackPushStatus? pushStatus,
    String? pushError,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackMessage',
      if (id != null) 'id': id,
      'feedbackId': feedbackId,
      'projectId': projectId,
      'author': author.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (pushStatus != null) 'pushStatus': pushStatus?.toJson(),
      if (pushError != null) 'pushError': pushError,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackMessage',
      if (id != null) 'id': id,
      'feedbackId': feedbackId,
      'projectId': projectId,
      'author': author.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
      if (readAt != null) 'readAt': readAt?.toJson(),
      if (pushStatus != null) 'pushStatus': pushStatus?.toJson(),
      if (pushError != null) 'pushError': pushError,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackMessageImpl extends FeedbackMessage {
  _FeedbackMessageImpl({
    int? id,
    required int feedbackId,
    required int projectId,
    required _imklq58l.FeedbackMessageAuthor author,
    required String body,
    DateTime? createdAt,
    DateTime? readAt,
    _ipimo89r.FeedbackPushStatus? pushStatus,
    String? pushError,
  }) : super._(
         id: id,
         feedbackId: feedbackId,
         projectId: projectId,
         author: author,
         body: body,
         createdAt: createdAt,
         readAt: readAt,
         pushStatus: pushStatus,
         pushError: pushError,
       );

  /// Returns a shallow copy of this [FeedbackMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackMessage copyWith({
    Object? id = _Undefined,
    int? feedbackId,
    int? projectId,
    _imklq58l.FeedbackMessageAuthor? author,
    String? body,
    DateTime? createdAt,
    Object? readAt = _Undefined,
    Object? pushStatus = _Undefined,
    Object? pushError = _Undefined,
  }) {
    return FeedbackMessage(
      id: id is int? ? id : this.id,
      feedbackId: feedbackId ?? this.feedbackId,
      projectId: projectId ?? this.projectId,
      author: author ?? this.author,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt is DateTime? ? readAt : this.readAt,
      pushStatus: pushStatus is _ipimo89r.FeedbackPushStatus?
          ? pushStatus
          : this.pushStatus,
      pushError: pushError is String? ? pushError : this.pushError,
    );
  }
}
