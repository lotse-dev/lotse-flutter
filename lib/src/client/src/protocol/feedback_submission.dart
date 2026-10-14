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

/// One feedback message as sent by the SDK.
abstract class FeedbackSubmission
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackSubmission._({
    required this.category,
    required this.message,
    this.contactEmail,
    this.lastScreen,
    this.metadata,
    this.sessionId,
  });

  factory FeedbackSubmission({
    required _iju423hp.FeedbackCategory category,
    required String message,
    String? contactEmail,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
  }) = _FeedbackSubmissionImpl;

  factory FeedbackSubmission.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackSubmission(
      category: _iju423hp.FeedbackCategory.fromJson(
        (jsonSerialization['category'] as String),
      ),
      message: jsonSerialization['message'] as String,
      contactEmail: jsonSerialization['contactEmail'] as String?,
      lastScreen: jsonSerialization['lastScreen'] as String?,
      metadata: jsonSerialization['metadata'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, String>>(
              jsonSerialization['metadata'],
            ),
      sessionId: jsonSerialization['sessionId'] as String?,
    );
  }

  _iju423hp.FeedbackCategory category;

  String message;

  String? contactEmail;

  String? lastScreen;

  Map<String, String>? metadata;

  String? sessionId;

  /// Returns a shallow copy of this [FeedbackSubmission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackSubmission copyWith({
    _iju423hp.FeedbackCategory? category,
    String? message,
    String? contactEmail,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackSubmission',
      'category': category.toJson(),
      'message': message,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (lastScreen != null) 'lastScreen': lastScreen,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackSubmission',
      'category': category.toJson(),
      'message': message,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (lastScreen != null) 'lastScreen': lastScreen,
      if (metadata != null) 'metadata': metadata?.toJson(),
      if (sessionId != null) 'sessionId': sessionId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackSubmissionImpl extends FeedbackSubmission {
  _FeedbackSubmissionImpl({
    required _iju423hp.FeedbackCategory category,
    required String message,
    String? contactEmail,
    String? lastScreen,
    Map<String, String>? metadata,
    String? sessionId,
  }) : super._(
         category: category,
         message: message,
         contactEmail: contactEmail,
         lastScreen: lastScreen,
         metadata: metadata,
         sessionId: sessionId,
       );

  /// Returns a shallow copy of this [FeedbackSubmission]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackSubmission copyWith({
    _iju423hp.FeedbackCategory? category,
    String? message,
    Object? contactEmail = _Undefined,
    Object? lastScreen = _Undefined,
    Object? metadata = _Undefined,
    Object? sessionId = _Undefined,
  }) {
    return FeedbackSubmission(
      category: category ?? this.category,
      message: message ?? this.message,
      contactEmail: contactEmail is String? ? contactEmail : this.contactEmail,
      lastScreen: lastScreen is String? ? lastScreen : this.lastScreen,
      metadata: metadata is Map<String, String>?
          ? metadata
          : this.metadata?.map((key0, value0) => MapEntry(key0, value0)),
      sessionId: sessionId is String? ? sessionId : this.sessionId,
    );
  }
}
