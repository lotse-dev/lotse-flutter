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
import 'survey_kind.dart' as _i7m36ch5;
import 'survey_status.dart' as _iw9o61c2;

/// One question to the devices of a segment, shown as a card inside the app,
/// see FEEDBACK.md, section "Umfragen und NPS". The device fetches it like an
/// in-app message; the answer is a row of survey_response and the event
/// survey_answered.
abstract class Survey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Survey._({
    this.id,
    required this.projectId,
    required this.kind,
    required this.question,
    this.choices,
    required this.askComment,
    this.commentPrompt,
    this.segment,
    required this.status,
    this.startedAt,
    this.endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Survey({
    int? id,
    required int projectId,
    required _i7m36ch5.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
    Map<String, dynamic>? segment,
    required _iw9o61c2.SurveyStatus status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SurveyImpl;

  factory Survey.fromJson(Map<String, dynamic> jsonSerialization) {
    return Survey(
      id: jsonSerialization['id'] as int?,
      projectId: jsonSerialization['projectId'] as int,
      kind: _i7m36ch5.SurveyKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      question: jsonSerialization['question'] as String,
      choices: jsonSerialization['choices'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<List<String>>(
              jsonSerialization['choices'],
            ),
      askComment: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['askComment'],
      ),
      commentPrompt: jsonSerialization['commentPrompt'] as String?,
      segment: jsonSerialization['segment'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<Map<String, dynamic>>(
              jsonSerialization['segment'],
            ),
      status: _iw9o61c2.SurveyStatus.fromJson(
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

  _i7m36ch5.SurveyKind kind;

  /// Trimmed, 1 to 200 characters.
  String question;

  /// The answers of a choice survey, 2 to 5, each trimmed, 1 to 60
  /// characters, distinct. Null for nps.
  List<String>? choices;

  /// Whether an nps survey asks for a comment after the score. Always false
  /// for choice.
  bool askComment;

  /// Prompt above the comment field, at most 120 characters. Null for the
  /// SDK's own text, and always null without askComment.
  String? commentPrompt;

  /// Audience predicate, see ARCHITECTURE.md, section "Segmente". Stored
  /// validated; null means every device of the project.
  Map<String, dynamic>? segment;

  _iw9o61c2.SurveyStatus status;

  /// When the survey became active. Its report counts from here.
  DateTime? startedAt;

  DateTime? endedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Survey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Survey copyWith({
    int? id,
    int? projectId,
    _i7m36ch5.SurveyKind? kind,
    String? question,
    List<String>? choices,
    bool? askComment,
    String? commentPrompt,
    Map<String, dynamic>? segment,
    _iw9o61c2.SurveyStatus? status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Survey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'kind': kind.toJson(),
      'question': question,
      if (choices != null) 'choices': choices?.toJson(),
      'askComment': askComment,
      if (commentPrompt != null) 'commentPrompt': commentPrompt,
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
      '__className__': 'Survey',
      if (id != null) 'id': id,
      'projectId': projectId,
      'kind': kind.toJson(),
      'question': question,
      if (choices != null) 'choices': choices?.toJson(),
      'askComment': askComment,
      if (commentPrompt != null) 'commentPrompt': commentPrompt,
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

class _SurveyImpl extends Survey {
  _SurveyImpl({
    int? id,
    required int projectId,
    required _i7m36ch5.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
    Map<String, dynamic>? segment,
    required _iw9o61c2.SurveyStatus status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         projectId: projectId,
         kind: kind,
         question: question,
         choices: choices,
         askComment: askComment,
         commentPrompt: commentPrompt,
         segment: segment,
         status: status,
         startedAt: startedAt,
         endedAt: endedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Survey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Survey copyWith({
    Object? id = _Undefined,
    int? projectId,
    _i7m36ch5.SurveyKind? kind,
    String? question,
    Object? choices = _Undefined,
    bool? askComment,
    Object? commentPrompt = _Undefined,
    Object? segment = _Undefined,
    _iw9o61c2.SurveyStatus? status,
    Object? startedAt = _Undefined,
    Object? endedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Survey(
      id: id is int? ? id : this.id,
      projectId: projectId ?? this.projectId,
      kind: kind ?? this.kind,
      question: question ?? this.question,
      choices: choices is List<String>?
          ? choices
          : this.choices?.map((e0) => e0).toList(),
      askComment: askComment ?? this.askComment,
      commentPrompt: commentPrompt is String?
          ? commentPrompt
          : this.commentPrompt,
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
