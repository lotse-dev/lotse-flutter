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
import 'feedback_category.dart' as _iju423hp;
import 'feedback_status.dart' as _ipjm5lus;

/// A feedback message as the device that sent it sees it. Carries nothing the
/// console added around it.
abstract class MyFeedback
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyFeedback._({
    required this.id,
    required this.category,
    required this.message,
    required this.status,
    required this.createdAt,
    this.lastMessageAt,
    required this.unreadCount,
  });

  factory MyFeedback({
    required int id,
    required _iju423hp.FeedbackCategory category,
    required String message,
    required _ipjm5lus.FeedbackStatus status,
    required DateTime createdAt,
    DateTime? lastMessageAt,
    required int unreadCount,
  }) = _MyFeedbackImpl;

  factory MyFeedback.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyFeedback(
      id: jsonSerialization['id'] as int,
      category: _iju423hp.FeedbackCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      message: jsonSerialization['message'] as String,
      status: _ipjm5lus.FeedbackStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt'],
            ),
      unreadCount: jsonSerialization['unreadCount'] as int,
    );
  }

  int id;

  _iju423hp.FeedbackCategory category;

  String message;

  _ipjm5lus.FeedbackStatus status;

  DateTime createdAt;

  /// Null while the conversation has no reply.
  DateTime? lastMessageAt;

  /// Team replies the device has not read yet.
  int unreadCount;

  /// Returns a shallow copy of this [MyFeedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyFeedback copyWith({
    int? id,
    _iju423hp.FeedbackCategory? category,
    String? message,
    _ipjm5lus.FeedbackStatus? status,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    int? unreadCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyFeedback',
      'id': id,
      'category': category.toJson(),
      'message': message,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyFeedback',
      'id': id,
      'category': category.toJson(),
      'message': message,
      'status': status.toJson(),
      'createdAt': createdAt.toJson(),
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'unreadCount': unreadCount,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MyFeedbackImpl extends MyFeedback {
  _MyFeedbackImpl({
    required int id,
    required _iju423hp.FeedbackCategory category,
    required String message,
    required _ipjm5lus.FeedbackStatus status,
    required DateTime createdAt,
    DateTime? lastMessageAt,
    required int unreadCount,
  }) : super._(
         id: id,
         category: category,
         message: message,
         status: status,
         createdAt: createdAt,
         lastMessageAt: lastMessageAt,
         unreadCount: unreadCount,
       );

  /// Returns a shallow copy of this [MyFeedback]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyFeedback copyWith({
    int? id,
    _iju423hp.FeedbackCategory? category,
    String? message,
    _ipjm5lus.FeedbackStatus? status,
    DateTime? createdAt,
    Object? lastMessageAt = _Undefined,
    int? unreadCount,
  }) {
    return MyFeedback(
      id: id ?? this.id,
      category: category ?? this.category,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt is DateTime?
          ? lastMessageAt
          : this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
