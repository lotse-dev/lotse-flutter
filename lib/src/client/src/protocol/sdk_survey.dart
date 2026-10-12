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

/// A survey as the device gets it from `SdkEndpoint.pendingSurvey`: only
/// what the card shows, nothing about segment or status.
abstract class SdkSurvey
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SdkSurvey._({
    required this.id,
    required this.kind,
    required this.question,
    this.choices,
    required this.askComment,
    this.commentPrompt,
  });

  factory SdkSurvey({
    required int id,
    required _i7m36ch5.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
  }) = _SdkSurveyImpl;

  factory SdkSurvey.fromJson(Map<String, dynamic> jsonSerialization) {
    return SdkSurvey(
      id: jsonSerialization['id'] as int,
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
    );
  }

  int id;

  _i7m36ch5.SurveyKind kind;

  String question;

  /// The answers of a choice survey, in order; the device answers with the
  /// index. Null for nps.
  List<String>? choices;

  bool askComment;

  /// Null for the SDK's own text.
  String? commentPrompt;

  /// Returns a shallow copy of this [SdkSurvey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SdkSurvey copyWith({
    int? id,
    _i7m36ch5.SurveyKind? kind,
    String? question,
    List<String>? choices,
    bool? askComment,
    String? commentPrompt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SdkSurvey',
      'id': id,
      'kind': kind.toJson(),
      'question': question,
      if (choices != null) 'choices': choices?.toJson(),
      'askComment': askComment,
      if (commentPrompt != null) 'commentPrompt': commentPrompt,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SdkSurvey',
      'id': id,
      'kind': kind.toJson(),
      'question': question,
      if (choices != null) 'choices': choices?.toJson(),
      'askComment': askComment,
      if (commentPrompt != null) 'commentPrompt': commentPrompt,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SdkSurveyImpl extends SdkSurvey {
  _SdkSurveyImpl({
    required int id,
    required _i7m36ch5.SurveyKind kind,
    required String question,
    List<String>? choices,
    required bool askComment,
    String? commentPrompt,
  }) : super._(
         id: id,
         kind: kind,
         question: question,
         choices: choices,
         askComment: askComment,
         commentPrompt: commentPrompt,
       );

  /// Returns a shallow copy of this [SdkSurvey]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SdkSurvey copyWith({
    int? id,
    _i7m36ch5.SurveyKind? kind,
    String? question,
    Object? choices = _Undefined,
    bool? askComment,
    Object? commentPrompt = _Undefined,
  }) {
    return SdkSurvey(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      question: question ?? this.question,
      choices: choices is List<String>?
          ? choices
          : this.choices?.map((e0) => e0).toList(),
      askComment: askComment ?? this.askComment,
      commentPrompt: commentPrompt is String?
          ? commentPrompt
          : this.commentPrompt,
    );
  }
}
