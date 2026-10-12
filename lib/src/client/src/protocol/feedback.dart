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
import 'feedback_category.dart' as _iju423hp;
import 'feedback_message_author.dart' as _imklq58l;
import 'feedback_status.dart' as _ipjm5lus;

/// A message a user sent from inside the app. It is also written to the event
/// stream as `feedback_submitted`, so segments and timelines see it.
abstract class Feedback
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Feedback._({
    this.id,
    required this.projectId,
    this.deviceId,
    required this.category,
    required this.message,
    _ipjm5lus.FeedbackStatus? status,
    this.contactEmail,
    this.appVersion,
    this.lastScreen,
    this.metadata,
    this.sessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.lastMessageAt,
    _imklq58l.FeedbackMessageAuthor? lastMessageAuthor,
    int? unreadByTeam,
    int? unreadByUser,
  }) : status = status ?? _ipjm5lus.FeedbackStatus.open,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       lastMessageAuthor =
           lastMessageAuthor ?? _imklq58l.FeedbackMessageAuthor.user,
       unreadByTeam = unreadByTeam ?? 0,
       unreadByUser = unreadByUser ?? 0;

  factory Feedback({
    int? id,
    required int projectId,
    int? deviceId,
    required _iju423hp.FeedbackCategory category,
    required String message,
    _ipjm5lus.FeedbackStatus? status,
    String? contactEmail,
    String? appVersion,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastMessageAt,
    _imklq58l.FeedbackMessageAuthor? lastMessageAuthor,
    int? unreadByTeam,
    int? unreadByUser,
  }) = _FeedbackImpl;

  factory Feedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return Feedback(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      deviceId: jsonSerialization['deviceId'] as int?,
      category: _iju423hp.FeedbackCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      message: jsonSerialization['message'] as String,
      status: jsonSerialization['status'] == null
          ? null
          : _ipjm5lus.FeedbackStatus.fromJson(
              (jsonSerialization['status'] as String),
            ),
      contactEmail: jsonSerialization['contactEmail'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      lastScreen: jsonSerialization['lastScreen'] as String?,
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      sessionId: jsonSerialization['sessionId'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt'],
            ),
      lastMessageAuthor: jsonSerialization['lastMessageAuthor'] == null
          ? null
          : _imklq58l.FeedbackMessageAuthor.fromJson(
              (jsonSerialization['lastMessageAuthor'] as String),
            ),
      unreadByTeam: jsonSerialization['unreadByTeam'] as int?,
      unreadByUser: jsonSerialization['unreadByUser'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int projectId;

  /// Like an event, feedback outlives its device.
  int? deviceId;

  _iju423hp.FeedbackCategory category;

  String message;

  _ipjm5lus.FeedbackStatus status;

  /// Only set when the app switched the e-mail field on and the user filled it.
  String? contactEmail;

  /// App version when the message was sent. The device row moves on with
  /// every update, this does not.
  String? appVersion;

  String? lastScreen;

  /// Set by the host app, same shape as event props.
  Map<String, String>? metadata;

  String? sessionId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Time of the newest reply. Null while the conversation has none.
  DateTime? lastMessageAt;

  /// Who wrote last. The message that opens the conversation is the user's,
  /// so a new row waits for a reply. Kept here so the inbox can filter by it
  /// without looking into feedback_message.
  _imklq58l.FeedbackMessageAuthor lastMessageAuthor;

  /// Replies of the user the team has not read yet.
  int unreadByTeam;

  /// Replies of the team the user has not read yet.
  int unreadByUser;

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Feedback copyWith({
    int? id,
    int? projectId,
    int? deviceId,
    _iju423hp.FeedbackCategory? category,
    String? message,
    _ipjm5lus.FeedbackStatus? status,
    String? contactEmail,
    String? appVersion,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastMessageAt,
    _imklq58l.FeedbackMessageAuthor? lastMessageAuthor,
    int? unreadByTeam,
    int? unreadByUser,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Feedback',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (deviceId != null) 'deviceId': deviceId,
      'category': category.toJson(),
      'message': message,
      'status': status.toJson(),
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (appVersion != null) 'appVersion': appVersion,
      if (lastScreen != null) 'lastScreen': lastScreen,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'lastMessageAuthor': lastMessageAuthor.toJson(),
      'unreadByTeam': unreadByTeam,
      'unreadByUser': unreadByUser,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Feedback',
      if (id != null) 'id': id,
      'projectId': projectId,
      if (deviceId != null) 'deviceId': deviceId,
      'category': category.toJson(),
      'message': message,
      'status': status.toJson(),
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (appVersion != null) 'appVersion': appVersion,
      if (lastScreen != null) 'lastScreen': lastScreen,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'lastMessageAuthor': lastMessageAuthor.toJson(),
      'unreadByTeam': unreadByTeam,
      'unreadByUser': unreadByUser,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackImpl extends Feedback {
  _FeedbackImpl({
    int? id,
    required int projectId,
    int? deviceId,
    required _iju423hp.FeedbackCategory category,
    required String message,
    _ipjm5lus.FeedbackStatus? status,
    String? contactEmail,
    String? appVersion,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastMessageAt,
    _imklq58l.FeedbackMessageAuthor? lastMessageAuthor,
    int? unreadByTeam,
    int? unreadByUser,
  }) : super._(
         id: id,
         projectId: projectId,
         deviceId: deviceId,
         category: category,
         message: message,
         status: status,
         contactEmail: contactEmail,
         appVersion: appVersion,
         lastScreen: lastScreen,
         metadata: metadata,
         sessionId: sessionId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         lastMessageAt: lastMessageAt,
         lastMessageAuthor: lastMessageAuthor,
         unreadByTeam: unreadByTeam,
         unreadByUser: unreadByUser,
       );

  /// Returns a shallow copy of this [Feedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Feedback copyWith({
    Object? id = _Undefined,
    int? projectId,
    Object? deviceId = _Undefined,
    _iju423hp.FeedbackCategory? category,
    String? message,
    _ipjm5lus.FeedbackStatus? status,
    Object? contactEmail = _Undefined,
    Object? appVersion = _Undefined,
    Object? lastScreen = _Undefined,
    Object? metadata = _Undefined,
    Object? sessionId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? lastMessageAt = _Undefined,
    _imklq58l.FeedbackMessageAuthor? lastMessageAuthor,
    int? unreadByTeam,
    int? unreadByUser,
  }) {
    return Feedback(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      category: category ?? this.category,
      message: message ?? this.message,
      status: status ?? this.status,
      contactEmail: contactEmail is String? ? contactEmail : this.contactEmail,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      lastScreen: lastScreen is String? ? lastScreen : this.lastScreen,
      metadata: metadata is Map<String, String>?
          ? metadata
          : this.metadata?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      sessionId: sessionId is String? ? sessionId : this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastMessageAt: lastMessageAt is DateTime?
          ? lastMessageAt
          : this.lastMessageAt,
      lastMessageAuthor: lastMessageAuthor ?? this.lastMessageAuthor,
      unreadByTeam: unreadByTeam ?? this.unreadByTeam,
      unreadByUser: unreadByUser ?? this.unreadByUser,
    );
  }
}
