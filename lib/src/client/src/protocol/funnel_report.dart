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
import 'funnel_row.dart' as _i4ciuq8e;
import 'funnel_split.dart' as _i3dwtlfw;
import 'funnel_step.dart' as _ilifyhbs;

/// An ordered funnel of one project, see AnalyticsEndpoint.funnel. A device
/// enters with its first event of step 1 in the last withinDays days and
/// reaches each further step with the first matching event after the
/// previous one, within conversionDays of entering.
abstract class FunnelReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FunnelReport._({
    required this.steps,
    required this.withinDays,
    required this.conversionDays,
    required this.measuredAt,
    this.split,
    required this.devices,
    required this.rows,
    required this.eventNames,
  });

  factory FunnelReport({
    required List<_ilifyhbs.FunnelStep> steps,
    required int withinDays,
    required int conversionDays,
    required DateTime measuredAt,
    _i3dwtlfw.FunnelSplit? split,
    required List<int> devices,
    required List<_i4ciuq8e.FunnelRow> rows,
    required List<String> eventNames,
  }) = _FunnelReportImpl;

  factory FunnelReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return FunnelReport(
      steps: _ist2d7e6.Protocol().deserialize<List<_ilifyhbs.FunnelStep>>(
        jsonSerialization['steps'],
      ),
      withinDays: jsonSerialization['withinDays'] as int,
      conversionDays: jsonSerialization['conversionDays'] as int,
      measuredAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['measuredAt'],
      ),
      split: jsonSerialization['split'] == null
          ? null
          : _i3dwtlfw.FunnelSplit.fromJson(
              (jsonSerialization['split'] as String),
            ),
      devices: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['devices'],
      ),
      rows: _ist2d7e6.Protocol().deserialize<List<_i4ciuq8e.FunnelRow>>(
        jsonSerialization['rows'],
      ),
      eventNames: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['eventNames'],
      ),
    );
  }

  List<_ilifyhbs.FunnelStep> steps;

  int withinDays;

  int conversionDays;

  /// The time the funnel was computed; withinDays counts back from it.
  DateTime measuredAt;

  /// Null when the funnel is not split; then rows holds one row.
  _i3dwtlfw.FunnelSplit? split;

  /// Devices that reached each step, all rows together.
  List<int> devices;

  /// One row per part, most devices at step 1 first.
  List<_i4ciuq8e.FunnelRow> rows;

  /// Names of the events devices sent in the range, most frequent first.
  /// Suggestions for the steps.
  List<String> eventNames;

  /// Returns a shallow copy of this [FunnelReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FunnelReport copyWith({
    List<_ilifyhbs.FunnelStep>? steps,
    int? withinDays,
    int? conversionDays,
    DateTime? measuredAt,
    _i3dwtlfw.FunnelSplit? split,
    List<int>? devices,
    List<_i4ciuq8e.FunnelRow>? rows,
    List<String>? eventNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FunnelReport',
      'steps': steps.toJson(valueToJson: (v) => v.toJson()),
      'withinDays': withinDays,
      'conversionDays': conversionDays,
      'measuredAt': measuredAt.toJson(),
      if (split != null) 'split': split?.toJson(),
      'devices': devices.toJson(),
      'rows': rows.toJson(valueToJson: (v) => v.toJson()),
      'eventNames': eventNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FunnelReport',
      'steps': steps.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'withinDays': withinDays,
      'conversionDays': conversionDays,
      'measuredAt': measuredAt.toJson(),
      if (split != null) 'split': split?.toJson(),
      'devices': devices.toJson(),
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

class _FunnelReportImpl extends FunnelReport {
  _FunnelReportImpl({
    required List<_ilifyhbs.FunnelStep> steps,
    required int withinDays,
    required int conversionDays,
    required DateTime measuredAt,
    _i3dwtlfw.FunnelSplit? split,
    required List<int> devices,
    required List<_i4ciuq8e.FunnelRow> rows,
    required List<String> eventNames,
  }) : super._(
         steps: steps,
         withinDays: withinDays,
         conversionDays: conversionDays,
         measuredAt: measuredAt,
         split: split,
         devices: devices,
         rows: rows,
         eventNames: eventNames,
       );

  /// Returns a shallow copy of this [FunnelReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FunnelReport copyWith({
    List<_ilifyhbs.FunnelStep>? steps,
    int? withinDays,
    int? conversionDays,
    DateTime? measuredAt,
    Object? split = _Undefined,
    List<int>? devices,
    List<_i4ciuq8e.FunnelRow>? rows,
    List<String>? eventNames,
  }) {
    return FunnelReport(
      steps: steps ?? this.steps.map((e0) => e0.copyWith()).toList(),
      withinDays: withinDays ?? this.withinDays,
      conversionDays: conversionDays ?? this.conversionDays,
      measuredAt: measuredAt ?? this.measuredAt,
      split: split is _i3dwtlfw.FunnelSplit? ? split : this.split,
      devices: devices ?? this.devices.map((e0) => e0).toList(),
      rows: rows ?? this.rows.map((e0) => e0.copyWith()).toList(),
      eventNames: eventNames ?? this.eventNames.map((e0) => e0).toList(),
    );
  }
}
