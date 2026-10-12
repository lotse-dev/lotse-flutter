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
import 'retention_cohort.dart' as _i20mhv3w;
import 'retention_split.dart' as _iuyop9cb;

/// Retention of one project for installs in the time range [from, to) by
/// install week, see AnalyticsEndpoint.retention. A device has returned on
/// day N when it sent a session_start in the window of day N after its
/// first start.
abstract class RetentionReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  RetentionReport._({
    required this.from,
    required this.to,
    required this.measuredAt,
    this.split,
    required this.days,
    required this.windowDays,
    required this.cohorts,
  });

  factory RetentionReport({
    required DateTime from,
    required DateTime to,
    required DateTime measuredAt,
    _iuyop9cb.RetentionSplit? split,
    required List<int> days,
    required List<int> windowDays,
    required List<_i20mhv3w.RetentionCohort> cohorts,
  }) = _RetentionReportImpl;

  factory RetentionReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return RetentionReport(
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
      split: jsonSerialization['split'] == null
          ? null
          : _iuyop9cb.RetentionSplit.fromJson(
              (jsonSerialization['split'] as String),
            ),
      days: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['days'],
      ),
      windowDays: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['windowDays'],
      ),
      cohorts: _ist2d7e6.Protocol()
          .deserialize<List<_i20mhv3w.RetentionCohort>>(
            jsonSerialization['cohorts'],
          ),
    );
  }

  DateTime from;

  DateTime to;

  /// The time the report was made. A window is over for an install once it
  /// lies before this time.
  DateTime measuredAt;

  /// Null when the cohorts are not split.
  _iuyop9cb.RetentionSplit? split;

  /// The days the report looks at, 1, 7 and 30. Day N counts a session_start
  /// in [N, N + windowDays) days after the install.
  List<int> days;

  /// Length of the window of each entry of days, in days: 1, 7 and 7.
  List<int> windowDays;

  /// One cohort per week of the range, oldest first, empty weeks included.
  List<_i20mhv3w.RetentionCohort> cohorts;

  /// Returns a shallow copy of this [RetentionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RetentionReport copyWith({
    DateTime? from,
    DateTime? to,
    DateTime? measuredAt,
    _iuyop9cb.RetentionSplit? split,
    List<int>? days,
    List<int>? windowDays,
    List<_i20mhv3w.RetentionCohort>? cohorts,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RetentionReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'measuredAt': measuredAt.toJson(),
      if (split != null) 'split': split?.toJson(),
      'days': days.toJson(),
      'windowDays': windowDays.toJson(),
      'cohorts': cohorts.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RetentionReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'measuredAt': measuredAt.toJson(),
      if (split != null) 'split': split?.toJson(),
      'days': days.toJson(),
      'windowDays': windowDays.toJson(),
      'cohorts': cohorts.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RetentionReportImpl extends RetentionReport {
  _RetentionReportImpl({
    required DateTime from,
    required DateTime to,
    required DateTime measuredAt,
    _iuyop9cb.RetentionSplit? split,
    required List<int> days,
    required List<int> windowDays,
    required List<_i20mhv3w.RetentionCohort> cohorts,
  }) : super._(
         from: from,
         to: to,
         measuredAt: measuredAt,
         split: split,
         days: days,
         windowDays: windowDays,
         cohorts: cohorts,
       );

  /// Returns a shallow copy of this [RetentionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RetentionReport copyWith({
    DateTime? from,
    DateTime? to,
    DateTime? measuredAt,
    Object? split = _Undefined,
    List<int>? days,
    List<int>? windowDays,
    List<_i20mhv3w.RetentionCohort>? cohorts,
  }) {
    return RetentionReport(
      from: from ?? this.from,
      to: to ?? this.to,
      measuredAt: measuredAt ?? this.measuredAt,
      split: split is _iuyop9cb.RetentionSplit? ? split : this.split,
      days: days ?? this.days.map((e0) => e0).toList(),
      windowDays: windowDays ?? this.windowDays.map((e0) => e0).toList(),
      cohorts: cohorts ?? this.cohorts.map((e0) => e0.copyWith()).toList(),
    );
  }
}
