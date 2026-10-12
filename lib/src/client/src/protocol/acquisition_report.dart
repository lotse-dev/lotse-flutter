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
import 'acquisition_row.dart' as _i03ibdtb;

/// The acquisition report of one project for installs in the time range
/// [from, to), see AnalyticsEndpoint.acquisition.
abstract class AcquisitionReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AcquisitionReport._({
    required this.from,
    required this.to,
    required this.measuredAt,
    this.goalEvent,
    required this.rows,
    required this.eventNames,
  });

  factory AcquisitionReport({
    required DateTime from,
    required DateTime to,
    required DateTime measuredAt,
    String? goalEvent,
    required List<_i03ibdtb.AcquisitionRow> rows,
    required List<String> eventNames,
  }) = _AcquisitionReportImpl;

  factory AcquisitionReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return AcquisitionReport(
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
      goalEvent: jsonSerialization['goalEvent'] as String?,
      rows: _ist2d7e6.Protocol().deserialize<List<_i03ibdtb.AcquisitionRow>>(
        jsonSerialization['rows'],
      ),
      eventNames: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['eventNames'],
      ),
    );
  }

  DateTime from;

  DateTime to;

  /// The time the report was made. An install has matured when its first
  /// acquisitionWindowDays days lie before this time.
  DateTime measuredAt;

  /// The event name counted as goal, null when none was asked for.
  String? goalEvent;

  /// One row per origin, most installs first, organic last.
  List<_i03ibdtb.AcquisitionRow> rows;

  /// Names of the events devices sent in the range, most frequent first, at
  /// most acquisitionEventNameLimit. Suggestions for the goal event.
  List<String> eventNames;

  /// Returns a shallow copy of this [AcquisitionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AcquisitionReport copyWith({
    DateTime? from,
    DateTime? to,
    DateTime? measuredAt,
    String? goalEvent,
    List<_i03ibdtb.AcquisitionRow>? rows,
    List<String>? eventNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AcquisitionReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'measuredAt': measuredAt.toJson(),
      if (goalEvent != null) 'goalEvent': goalEvent,
      'rows': rows.toJson(valueToJson: (v) => v.toJson()),
      'eventNames': eventNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AcquisitionReport',
      'from': from.toJson(),
      'to': to.toJson(),
      'measuredAt': measuredAt.toJson(),
      if (goalEvent != null) 'goalEvent': goalEvent,
      'rows': rows.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'eventNames': eventNames.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AcquisitionReportImpl extends AcquisitionReport {
  _AcquisitionReportImpl({
    required DateTime from,
    required DateTime to,
    required DateTime measuredAt,
    String? goalEvent,
    required List<_i03ibdtb.AcquisitionRow> rows,
    required List<String> eventNames,
  }) : super._(
         from: from,
         to: to,
         measuredAt: measuredAt,
         goalEvent: goalEvent,
         rows: rows,
         eventNames: eventNames,
       );

  /// Returns a shallow copy of this [AcquisitionReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AcquisitionReport copyWith({
    DateTime? from,
    DateTime? to,
    DateTime? measuredAt,
    Object? goalEvent = _Undefined,
    List<_i03ibdtb.AcquisitionRow>? rows,
    List<String>? eventNames,
  }) {
    return AcquisitionReport(
      from: from ?? this.from,
      to: to ?? this.to,
      measuredAt: measuredAt ?? this.measuredAt,
      goalEvent: goalEvent is String? ? goalEvent : this.goalEvent,
      rows: rows ?? this.rows.map((e0) => e0.copyWith()).toList(),
      eventNames: eventNames ?? this.eventNames.map((e0) => e0).toList(),
    );
  }
}
