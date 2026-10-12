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
import 'explorer_query.dart' as _is6a98og;
import 'explorer_series.dart' as _ia8ec5jy;

/// One event over time in the range [from, to), see
/// AnalyticsEndpoint.explore.
abstract class ExplorerReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExplorerReport._({
    required this.from,
    required this.to,
    required this.query,
    required this.dayStarts,
    required this.total,
    required this.series,
    required this.eventNames,
    required this.propKeys,
  });

  factory ExplorerReport({
    required DateTime from,
    required DateTime to,
    required _is6a98og.ExplorerQuery query,
    required List<DateTime> dayStarts,
    required _ia8ec5jy.ExplorerSeries total,
    required List<_ia8ec5jy.ExplorerSeries> series,
    required List<String> eventNames,
    required List<String> propKeys,
  }) = _ExplorerReportImpl;

  factory ExplorerReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExplorerReport(
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      query: _ist2d7e6.Protocol().deserialize<_is6a98og.ExplorerQuery>(
        jsonSerialization['query'],
      ),
      dayStarts: _ist2d7e6.Protocol().deserialize<List<DateTime>>(
        jsonSerialization['dayStarts'],
      ),
      total: _ist2d7e6.Protocol().deserialize<_ia8ec5jy.ExplorerSeries>(
        jsonSerialization['total'],
      ),
      series: _ist2d7e6.Protocol().deserialize<List<_ia8ec5jy.ExplorerSeries>>(
        jsonSerialization['series'],
      ),
      eventNames: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['eventNames'],
      ),
      propKeys: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['propKeys'],
      ),
    );
  }

  DateTime from;

  DateTime to;

  /// The query as counted: names trimmed.
  _is6a98og.ExplorerQuery query;

  /// Start of every day: from plus multiples of 24 hours.
  List<DateTime> dayStarts;

  /// All events of the query.
  _ia8ec5jy.ExplorerSeries total;

  /// Split into at most explorerMaxSeries (8) series, most events first, and a
  /// series of kind other for the rest. Empty without split.
  List<_ia8ec5jy.ExplorerSeries> series;

  /// Names of the events devices sent in the range, most frequent first.
  List<String> eventNames;

  /// Prop keys of the event in the range, most frequent first:
  /// suggestions for filter and split.
  List<String> propKeys;

  /// Returns a shallow copy of this [ExplorerReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExplorerReport copyWith({
    DateTime? from,
    DateTime? to,
    _is6a98og.ExplorerQuery? query,
    List<DateTime>? dayStarts,
    _ia8ec5jy.ExplorerSeries? total,
    List<_ia8ec5jy.ExplorerSeries>? series,
    List<String>? eventNames,
    List<String>? propKeys,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExplorerReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'query': query.toJson(),
      'dayStarts': dayStarts.toJson(valueToJson: (v) => v.toJson()),
      'total': total.toJson(),
      'series': series.toJson(valueToJson: (v) => v.toJson()),
      'eventNames': eventNames.toJson(),
      'propKeys': propKeys.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExplorerReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'query': query.toJsonForProtocol(),
      'dayStarts': dayStarts.toJson(valueToJson: (v) => v.toJson()),
      'total': total.toJsonForProtocol(),
      'series': series.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'eventNames': eventNames.toJson(),
      'propKeys': propKeys.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ExplorerReportImpl extends ExplorerReport {
  _ExplorerReportImpl({
    required DateTime from,
    required DateTime to,
    required _is6a98og.ExplorerQuery query,
    required List<DateTime> dayStarts,
    required _ia8ec5jy.ExplorerSeries total,
    required List<_ia8ec5jy.ExplorerSeries> series,
    required List<String> eventNames,
    required List<String> propKeys,
  }) : super._(
         from: from,
         to: to,
         query: query,
         dayStarts: dayStarts,
         total: total,
         series: series,
         eventNames: eventNames,
         propKeys: propKeys,
       );

  /// Returns a shallow copy of this [ExplorerReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExplorerReport copyWith({
    DateTime? from,
    DateTime? to,
    _is6a98og.ExplorerQuery? query,
    List<DateTime>? dayStarts,
    _ia8ec5jy.ExplorerSeries? total,
    List<_ia8ec5jy.ExplorerSeries>? series,
    List<String>? eventNames,
    List<String>? propKeys,
  }) {
    return ExplorerReport(
      from: from ?? this.from,
      to: to ?? this.to,
      query: query ?? this.query.copyWith(),
      dayStarts: dayStarts ?? this.dayStarts.map((e0) => e0).toList(),
      total: total ?? this.total.copyWith(),
      series: series ?? this.series.map((e0) => e0.copyWith()).toList(),
      eventNames: eventNames ?? this.eventNames.map((e0) => e0).toList(),
      propKeys: propKeys ?? this.propKeys.map((e0) => e0).toList(),
    );
  }
}
