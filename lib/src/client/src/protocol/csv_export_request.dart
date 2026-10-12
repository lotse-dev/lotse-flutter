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
import 'csv_export_kind.dart' as _ihuvp8cb;
import 'csv_feedback_filter.dart' as _iog5sq87;
import 'explorer_query.dart' as _is6a98og;
import 'funnel_split.dart' as _i3dwtlfw;
import 'funnel_step.dart' as _ilifyhbs;
import 'retention_split.dart' as _iuyop9cb;
import 'survey_group.dart' as _illgmjmc;

/// One export of AnalyticsEndpoint.exportCsv: the kind and the parameters
/// of the table or report, as the console shows it. Each kind reads only
/// the fields it needs and refuses a request without them.
abstract class CsvExportRequest
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CsvExportRequest._({
    required this.kind,
    this.from,
    this.to,
    this.goalEvent,
    this.funnelSteps,
    this.withinDays,
    this.conversionDays,
    this.funnelSplit,
    this.retentionSplit,
    this.explorerQuery,
    this.deviceId,
    this.userId,
    this.search,
    this.linkId,
    this.campaignId,
    this.feedbackFilter,
    this.archived,
    this.surveyId,
    this.surveyGroup,
    this.surveyChoice,
    this.surveyWithComment,
    this.journeyId,
  });

  factory CsvExportRequest({
    required _ihuvp8cb.CsvExportKind kind,
    DateTime? from,
    DateTime? to,
    String? goalEvent,
    List<_ilifyhbs.FunnelStep>? funnelSteps,
    int? withinDays,
    int? conversionDays,
    _i3dwtlfw.FunnelSplit? funnelSplit,
    _iuyop9cb.RetentionSplit? retentionSplit,
    _is6a98og.ExplorerQuery? explorerQuery,
    int? deviceId,
    int? userId,
    String? search,
    int? linkId,
    int? campaignId,
    _iog5sq87.CsvFeedbackFilter? feedbackFilter,
    bool? archived,
    int? surveyId,
    _illgmjmc.SurveyGroup? surveyGroup,
    int? surveyChoice,
    bool? surveyWithComment,
    int? journeyId,
  }) = _CsvExportRequestImpl;

  factory CsvExportRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return CsvExportRequest(
      kind: _ihuvp8cb.CsvExportKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      from: jsonSerialization['from'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: jsonSerialization['to'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      goalEvent: jsonSerialization['goalEvent'] as String?,
      funnelSteps: jsonSerialization['funnelSteps'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<List<_ilifyhbs.FunnelStep>>(
              jsonSerialization['funnelSteps'],
            ),
      withinDays: jsonSerialization['withinDays'] as int?,
      conversionDays: jsonSerialization['conversionDays'] as int?,
      funnelSplit: jsonSerialization['funnelSplit'] == null
          ? null
          : _i3dwtlfw.FunnelSplit.fromJson(
              (jsonSerialization['funnelSplit'] as String),
            ),
      retentionSplit: jsonSerialization['retentionSplit'] == null
          ? null
          : _iuyop9cb.RetentionSplit.fromJson(
              (jsonSerialization['retentionSplit'] as String),
            ),
      explorerQuery: jsonSerialization['explorerQuery'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_is6a98og.ExplorerQuery>(
              jsonSerialization['explorerQuery'],
            ),
      deviceId: jsonSerialization['deviceId'] as int?,
      userId: jsonSerialization['userId'] as int?,
      search: jsonSerialization['search'] as String?,
      linkId: jsonSerialization['linkId'] as int?,
      campaignId: jsonSerialization['campaignId'] as int?,
      feedbackFilter: jsonSerialization['feedbackFilter'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_iog5sq87.CsvFeedbackFilter>(
              jsonSerialization['feedbackFilter'],
            ),
      archived: jsonSerialization['archived'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['archived']),
      surveyId: jsonSerialization['surveyId'] as int?,
      surveyGroup: jsonSerialization['surveyGroup'] == null
          ? null
          : _illgmjmc.SurveyGroup.fromJson(
              (jsonSerialization['surveyGroup'] as String),
            ),
      surveyChoice: jsonSerialization['surveyChoice'] as int?,
      surveyWithComment: jsonSerialization['surveyWithComment'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(
              jsonSerialization['surveyWithComment'],
            ),
      journeyId: jsonSerialization['journeyId'] as int?,
    );
  }

  _ihuvp8cb.CsvExportKind kind;

  /// Range of overview, acquisition, retention, explorer, events and the
  /// timelines, at most 90 days.
  DateTime? from;

  DateTime? to;

  /// Acquisition and campaign report.
  String? goalEvent;

  /// Funnel.
  List<_ilifyhbs.FunnelStep>? funnelSteps;

  int? withinDays;

  int? conversionDays;

  _i3dwtlfw.FunnelSplit? funnelSplit;

  /// Retention.
  _iuyop9cb.RetentionSplit? retentionSplit;

  /// Explorer.
  _is6a98og.ExplorerQuery? explorerQuery;

  /// Device timeline.
  int? deviceId;

  /// User timeline.
  int? userId;

  /// Users: prefix of the external id.
  String? search;

  /// Link clicks.
  int? linkId;

  /// Deliveries and campaign report.
  int? campaignId;

  /// Feedback inbox.
  _iog5sq87.CsvFeedbackFilter? feedbackFilter;

  /// Feature board: the archive instead of the board.
  bool? archived;

  /// Survey answers: the survey and the filters of its answer list, as in
  /// AnalyticsEndpoint.surveyResponses.
  int? surveyId;

  _illgmjmc.SurveyGroup? surveyGroup;

  int? surveyChoice;

  bool? surveyWithComment;

  /// Journey report.
  int? journeyId;

  /// Returns a shallow copy of this [CsvExportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CsvExportRequest copyWith({
    _ihuvp8cb.CsvExportKind? kind,
    DateTime? from,
    DateTime? to,
    String? goalEvent,
    List<_ilifyhbs.FunnelStep>? funnelSteps,
    int? withinDays,
    int? conversionDays,
    _i3dwtlfw.FunnelSplit? funnelSplit,
    _iuyop9cb.RetentionSplit? retentionSplit,
    _is6a98og.ExplorerQuery? explorerQuery,
    int? deviceId,
    int? userId,
    String? search,
    int? linkId,
    int? campaignId,
    _iog5sq87.CsvFeedbackFilter? feedbackFilter,
    bool? archived,
    int? surveyId,
    _illgmjmc.SurveyGroup? surveyGroup,
    int? surveyChoice,
    bool? surveyWithComment,
    int? journeyId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CsvExportRequest',
      'kind': kind.toJson(),
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
      if (goalEvent != null) 'goalEvent': goalEvent,
      if (funnelSteps != null)
        'funnelSteps': funnelSteps?.toJson(valueToJson: (v) => v.toJson()),
      if (withinDays != null) 'withinDays': withinDays,
      if (conversionDays != null) 'conversionDays': conversionDays,
      if (funnelSplit != null) 'funnelSplit': funnelSplit?.toJson(),
      if (retentionSplit != null) 'retentionSplit': retentionSplit?.toJson(),
      if (explorerQuery != null) 'explorerQuery': explorerQuery?.toJson(),
      if (deviceId != null) 'deviceId': deviceId,
      if (userId != null) 'userId': userId,
      if (search != null) 'search': search,
      if (linkId != null) 'linkId': linkId,
      if (campaignId != null) 'campaignId': campaignId,
      if (feedbackFilter != null) 'feedbackFilter': feedbackFilter?.toJson(),
      if (archived != null) 'archived': archived,
      if (surveyId != null) 'surveyId': surveyId,
      if (surveyGroup != null) 'surveyGroup': surveyGroup?.toJson(),
      if (surveyChoice != null) 'surveyChoice': surveyChoice,
      if (surveyWithComment != null) 'surveyWithComment': surveyWithComment,
      if (journeyId != null) 'journeyId': journeyId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CsvExportRequest',
      'kind': kind.toJson(),
      if (from != null) 'from': from?.toJson(),
      if (to != null) 'to': to?.toJson(),
      if (goalEvent != null) 'goalEvent': goalEvent,
      if (funnelSteps != null)
        'funnelSteps': funnelSteps?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      if (withinDays != null) 'withinDays': withinDays,
      if (conversionDays != null) 'conversionDays': conversionDays,
      if (funnelSplit != null) 'funnelSplit': funnelSplit?.toJson(),
      if (retentionSplit != null) 'retentionSplit': retentionSplit?.toJson(),
      if (explorerQuery != null)
        'explorerQuery': explorerQuery?.toJsonForProtocol(),
      if (deviceId != null) 'deviceId': deviceId,
      if (userId != null) 'userId': userId,
      if (search != null) 'search': search,
      if (linkId != null) 'linkId': linkId,
      if (campaignId != null) 'campaignId': campaignId,
      if (feedbackFilter != null)
        'feedbackFilter': feedbackFilter?.toJsonForProtocol(),
      if (archived != null) 'archived': archived,
      if (surveyId != null) 'surveyId': surveyId,
      if (surveyGroup != null) 'surveyGroup': surveyGroup?.toJson(),
      if (surveyChoice != null) 'surveyChoice': surveyChoice,
      if (surveyWithComment != null) 'surveyWithComment': surveyWithComment,
      if (journeyId != null) 'journeyId': journeyId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CsvExportRequestImpl extends CsvExportRequest {
  _CsvExportRequestImpl({
    required _ihuvp8cb.CsvExportKind kind,
    DateTime? from,
    DateTime? to,
    String? goalEvent,
    List<_ilifyhbs.FunnelStep>? funnelSteps,
    int? withinDays,
    int? conversionDays,
    _i3dwtlfw.FunnelSplit? funnelSplit,
    _iuyop9cb.RetentionSplit? retentionSplit,
    _is6a98og.ExplorerQuery? explorerQuery,
    int? deviceId,
    int? userId,
    String? search,
    int? linkId,
    int? campaignId,
    _iog5sq87.CsvFeedbackFilter? feedbackFilter,
    bool? archived,
    int? surveyId,
    _illgmjmc.SurveyGroup? surveyGroup,
    int? surveyChoice,
    bool? surveyWithComment,
    int? journeyId,
  }) : super._(
         kind: kind,
         from: from,
         to: to,
         goalEvent: goalEvent,
         funnelSteps: funnelSteps,
         withinDays: withinDays,
         conversionDays: conversionDays,
         funnelSplit: funnelSplit,
         retentionSplit: retentionSplit,
         explorerQuery: explorerQuery,
         deviceId: deviceId,
         userId: userId,
         search: search,
         linkId: linkId,
         campaignId: campaignId,
         feedbackFilter: feedbackFilter,
         archived: archived,
         surveyId: surveyId,
         surveyGroup: surveyGroup,
         surveyChoice: surveyChoice,
         surveyWithComment: surveyWithComment,
         journeyId: journeyId,
       );

  /// Returns a shallow copy of this [CsvExportRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CsvExportRequest copyWith({
    _ihuvp8cb.CsvExportKind? kind,
    Object? from = _Undefined,
    Object? to = _Undefined,
    Object? goalEvent = _Undefined,
    Object? funnelSteps = _Undefined,
    Object? withinDays = _Undefined,
    Object? conversionDays = _Undefined,
    Object? funnelSplit = _Undefined,
    Object? retentionSplit = _Undefined,
    Object? explorerQuery = _Undefined,
    Object? deviceId = _Undefined,
    Object? userId = _Undefined,
    Object? search = _Undefined,
    Object? linkId = _Undefined,
    Object? campaignId = _Undefined,
    Object? feedbackFilter = _Undefined,
    Object? archived = _Undefined,
    Object? surveyId = _Undefined,
    Object? surveyGroup = _Undefined,
    Object? surveyChoice = _Undefined,
    Object? surveyWithComment = _Undefined,
    Object? journeyId = _Undefined,
  }) {
    return CsvExportRequest(
      kind: kind ?? this.kind,
      from: from is DateTime? ? from : this.from,
      to: to is DateTime? ? to : this.to,
      goalEvent: goalEvent is String? ? goalEvent : this.goalEvent,
      funnelSteps: funnelSteps is List<_ilifyhbs.FunnelStep>?
          ? funnelSteps
          : this.funnelSteps?.map((e0) => e0.copyWith()).toList(),
      withinDays: withinDays is int? ? withinDays : this.withinDays,
      conversionDays: conversionDays is int?
          ? conversionDays
          : this.conversionDays,
      funnelSplit: funnelSplit is _i3dwtlfw.FunnelSplit?
          ? funnelSplit
          : this.funnelSplit,
      retentionSplit: retentionSplit is _iuyop9cb.RetentionSplit?
          ? retentionSplit
          : this.retentionSplit,
      explorerQuery: explorerQuery is _is6a98og.ExplorerQuery?
          ? explorerQuery
          : this.explorerQuery?.copyWith(),
      deviceId: deviceId is int? ? deviceId : this.deviceId,
      userId: userId is int? ? userId : this.userId,
      search: search is String? ? search : this.search,
      linkId: linkId is int? ? linkId : this.linkId,
      campaignId: campaignId is int? ? campaignId : this.campaignId,
      feedbackFilter: feedbackFilter is _iog5sq87.CsvFeedbackFilter?
          ? feedbackFilter
          : this.feedbackFilter?.copyWith(),
      archived: archived is bool? ? archived : this.archived,
      surveyId: surveyId is int? ? surveyId : this.surveyId,
      surveyGroup: surveyGroup is _illgmjmc.SurveyGroup?
          ? surveyGroup
          : this.surveyGroup,
      surveyChoice: surveyChoice is int? ? surveyChoice : this.surveyChoice,
      surveyWithComment: surveyWithComment is bool?
          ? surveyWithComment
          : this.surveyWithComment,
      journeyId: journeyId is int? ? journeyId : this.journeyId,
    );
  }
}
