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

/// One reply as the device sees it.
abstract class MyFeedbackMessage
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MyFeedbackMessage._({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
  });

  factory MyFeedbackMessage({
    required int id,
    required _imklq58l.FeedbackMessageAuthor author,
    required String body,
    required DateTime createdAt,
  }) = _MyFeedbackMessageImpl;

  factory MyFeedbackMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyFeedbackMessage(
      id: jsonSerialization['id'] as int,
      author: _imklq58l.FeedbackMessageAuthor.fromJson(
        (jsonSerialization['author'] as String),
      ),
      body: jsonSerialization['body'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  int id;

  _imklq58l.FeedbackMessageAuthor author;

  String body;

  DateTime createdAt;

  /// Returns a shallow copy of this [MyFeedbackMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MyFeedbackMessage copyWith({
    int? id,
    _imklq58l.FeedbackMessageAuthor? author,
    String? body,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MyFeedbackMessage',
      'id': id,
      'author': author.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MyFeedbackMessage',
      'id': id,
      'author': author.toJson(),
      'body': body,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _MyFeedbackMessageImpl extends MyFeedbackMessage {
  _MyFeedbackMessageImpl({
    required int id,
    required _imklq58l.FeedbackMessageAuthor author,
    required String body,
    required DateTime createdAt,
  }) : super._(
         id: id,
         author: author,
         body: body,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [MyFeedbackMessage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MyFeedbackMessage copyWith({
    int? id,
    _imklq58l.FeedbackMessageAuthor? author,
    String? body,
    DateTime? createdAt,
  }) {
    return MyFeedbackMessage(
      id: id ?? this.id,
      author: author ?? this.author,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
