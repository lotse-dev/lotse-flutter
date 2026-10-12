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
import 'explorer_series_kind.dart' as _i39vvocg;

/// One line of the event explorer, see ExplorerReport.
abstract class ExplorerSeries
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ExplorerSeries._({
    required this.kind,
    this.value,
    required this.events,
    required this.devices,
    required this.totalEvents,
    required this.totalDevices,
  });

  factory ExplorerSeries({
    required _i39vvocg.ExplorerSeriesKind kind,
    String? value,
    required List<int> events,
    required List<int> devices,
    required int totalEvents,
    required int totalDevices,
  }) = _ExplorerSeriesImpl;

  factory ExplorerSeries.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExplorerSeries(
      kind: _i39vvocg.ExplorerSeriesKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      value: jsonSerialization['value'] as String?,
      events: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['events'],
      ),
      devices: _ist2d7e6.Protocol().deserialize<List<int>>(
        jsonSerialization['devices'],
      ),
      totalEvents: jsonSerialization['totalEvents'] as int,
      totalDevices: jsonSerialization['totalDevices'] as int,
    );
  }

  _i39vvocg.ExplorerSeriesKind kind;

  /// The value for ExplorerSeriesKind.value, the platform by name for a
  /// split by platform. Null otherwise.
  String? value;

  /// Events per day, one entry per ExplorerReport.dayStarts.
  List<int> events;

  /// Distinct devices per day.
  List<int> devices;

  int totalEvents;

  /// Distinct devices over the whole range, not the sum of the days.
  int totalDevices;

  /// Returns a shallow copy of this [ExplorerSeries]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ExplorerSeries copyWith({
    _i39vvocg.ExplorerSeriesKind? kind,
    String? value,
    List<int>? events,
    List<int>? devices,
    int? totalEvents,
    int? totalDevices,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExplorerSeries',
      'kind': kind.toJson(),
      if (value != null) 'value': value,
      'events': events.toJson(),
      'devices': devices.toJson(),
      'totalEvents': totalEvents,
      'totalDevices': totalDevices,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ExplorerSeries',
      'kind': kind.toJson(),
      if (value != null) 'value': value,
      'events': events.toJson(),
      'devices': devices.toJson(),
      'totalEvents': totalEvents,
      'totalDevices': totalDevices,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExplorerSeriesImpl extends ExplorerSeries {
  _ExplorerSeriesImpl({
    required _i39vvocg.ExplorerSeriesKind kind,
    String? value,
    required List<int> events,
    required List<int> devices,
    required int totalEvents,
    required int totalDevices,
  }) : super._(
         kind: kind,
         value: value,
         events: events,
         devices: devices,
         totalEvents: totalEvents,
         totalDevices: totalDevices,
       );

  /// Returns a shallow copy of this [ExplorerSeries]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ExplorerSeries copyWith({
    _i39vvocg.ExplorerSeriesKind? kind,
    Object? value = _Undefined,
    List<int>? events,
    List<int>? devices,
    int? totalEvents,
    int? totalDevices,
  }) {
    return ExplorerSeries(
      kind: kind ?? this.kind,
      value: value is String? ? value : this.value,
      events: events ?? this.events.map((e0) => e0).toList(),
      devices: devices ?? this.devices.map((e0) => e0).toList(),
      totalEvents: totalEvents ?? this.totalEvents,
      totalDevices: totalDevices ?? this.totalDevices,
    );
  }
}
