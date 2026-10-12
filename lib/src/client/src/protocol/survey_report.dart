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

/// What one survey achieved, from `AnalyticsEndpoint.surveyReport`. Viewed
/// and dismissed count distinct devices of the project whose events carry
/// the id of the survey, from startedAt on; answered counts the answers,
/// one per device.
abstract class SurveyReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SurveyReport._({
    required this.surveyId,
    required this.kind,
    this.audience,
    required this.viewed,
    required this.answered,
    required this.dismissed,
    this.scores,
    this.choices,
    this.nps,
    required this.measuredAt,
  });

  factory SurveyReport({
    required int surveyId,
    required _i7m36ch5.SurveyKind kind,
    int? audience,
    required int viewed,
    required int answered,
    required int dismissed,
    List<int>? scores,
    List<int>? choices,
    int? nps,
    required DateTime measuredAt,
  }) = _SurveyReportImpl;

  factory SurveyReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return SurveyReport(
      surveyId: jsonSerialization['surveyId'] as int,
      kind: _i7m36ch5.SurveyKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      audience: jsonSerialization['audience'] as int?,
      viewed: jsonSerialization['viewed'] as int,
      answered: jsonSerialization['answered'] as int,
      dismissed: jsonSerialization['dismissed'] as int,
      scores: jsonSerialization['scores'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<List<int>>(
              jsonSerialization['scores'],
            ),
      choices: jsonSerialization['choices'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<List<int>>(
              jsonSerialization['choices'],
            ),
      nps: jsonSerialization['nps'] as int?,
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
    );
  }

  int surveyId;

  _i7m36ch5.SurveyKind kind;

  /// Devices the segment matches right now. Null for an ended survey.
  int? audience;

  /// Devices that tracked survey_view.
  int viewed;

  int answered;

  /// Devices that tracked survey_dismiss.
  int dismissed;

  /// nps: answers per score, 11 entries for 0 to 10. Null for choice.
  List<int>? scores;

  /// choice: answers per answer, in the order of the survey. Null for nps.
  List<int>? choices;

  /// nps: share of promoters minus share of detractors in percent, -100 to
  /// 100, rounded. Null for choice and without answers.
  int? nps;

  DateTime measuredAt;

  /// Returns a shallow copy of this [SurveyReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SurveyReport copyWith({
    int? surveyId,
    _i7m36ch5.SurveyKind? kind,
    int? audience,
    int? viewed,
    int? answered,
    int? dismissed,
    List<int>? scores,
    List<int>? choices,
    int? nps,
    DateTime? measuredAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SurveyReport',
      'surveyId': surveyId,
      'kind': kind.toJson(),
      if (audience != null) 'audience': audience,
      'viewed': viewed,
      'answered': answered,
      'dismissed': dismissed,
      if (scores != null) 'scores': scores?.toJson(),
      if (choices != null) 'choices': choices?.toJson(),
      if (nps != null) 'nps': nps,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SurveyReport',
      'surveyId': surveyId,
      'kind': kind.toJson(),
      if (audience != null) 'audience': audience,
      'viewed': viewed,
      'answered': answered,
      'dismissed': dismissed,
      if (scores != null) 'scores': scores?.toJson(),
      if (choices != null) 'choices': choices?.toJson(),
      if (nps != null) 'nps': nps,
      'measuredAt': measuredAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SurveyReportImpl extends SurveyReport {
  _SurveyReportImpl({
    required int surveyId,
    required _i7m36ch5.SurveyKind kind,
    int? audience,
    required int viewed,
    required int answered,
    required int dismissed,
    List<int>? scores,
    List<int>? choices,
    int? nps,
    required DateTime measuredAt,
  }) : super._(
         surveyId: surveyId,
         kind: kind,
         audience: audience,
         viewed: viewed,
         answered: answered,
         dismissed: dismissed,
         scores: scores,
         choices: choices,
         nps: nps,
         measuredAt: measuredAt,
       );

  /// Returns a shallow copy of this [SurveyReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SurveyReport copyWith({
    int? surveyId,
    _i7m36ch5.SurveyKind? kind,
    Object? audience = _Undefined,
    int? viewed,
    int? answered,
    int? dismissed,
    Object? scores = _Undefined,
    Object? choices = _Undefined,
    Object? nps = _Undefined,
    DateTime? measuredAt,
  }) {
    return SurveyReport(
      surveyId: surveyId ?? this.surveyId,
      kind: kind ?? this.kind,
      audience: audience is int? ? audience : this.audience,
      viewed: viewed ?? this.viewed,
      answered: answered ?? this.answered,
      dismissed: dismissed ?? this.dismissed,
      scores: scores is List<int>?
          ? scores
          : this.scores?.map((e0) => e0).toList(),
      choices: choices is List<int>?
          ? choices
          : this.choices?.map((e0) => e0).toList(),
      nps: nps is int? ? nps : this.nps,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }
}
