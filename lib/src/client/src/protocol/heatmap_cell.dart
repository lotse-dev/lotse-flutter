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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// One cell of a heatmap: the taps whose position fell into the square of
/// `HeatmapReport.cellSize` logical pixels starting at x, y.
abstract class HeatmapCell
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeatmapCell._({
    required this.x,
    required this.y,
    required this.taps,
    required this.rageTaps,
  });

  factory HeatmapCell({
    required int x,
    required int y,
    required int taps,
    required int rageTaps,
  }) = _HeatmapCellImpl;

  factory HeatmapCell.fromJson(Map<String, dynamic> jsonSerialization) {
    return HeatmapCell(
      x: jsonSerialization['x'] as int,
      y: jsonSerialization['y'] as int,
      taps: jsonSerialization['taps'] as int,
      rageTaps: jsonSerialization['rageTaps'] as int,
    );
  }

  int x;

  int y;

  int taps;

  int rageTaps;

  /// Returns a shallow copy of this [HeatmapCell]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeatmapCell copyWith({int? x, int? y, int? taps, int? rageTaps});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeatmapCell',
      'x': x,
      'y': y,
      'taps': taps,
      'rageTaps': rageTaps,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeatmapCell',
      'x': x,
      'y': y,
      'taps': taps,
      'rageTaps': rageTaps,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HeatmapCellImpl extends HeatmapCell {
  _HeatmapCellImpl({
    required int x,
    required int y,
    required int taps,
    required int rageTaps,
  }) : super._(x: x, y: y, taps: taps, rageTaps: rageTaps);

  /// Returns a shallow copy of this [HeatmapCell]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeatmapCell copyWith({int? x, int? y, int? taps, int? rageTaps}) {
    return HeatmapCell(
      x: x ?? this.x,
      y: y ?? this.y,
      taps: taps ?? this.taps,
      rageTaps: rageTaps ?? this.rageTaps,
    );
  }
}
