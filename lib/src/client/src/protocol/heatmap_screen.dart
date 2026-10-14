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

/// A screen with heatmap taps, see `AnalyticsEndpoint.heatmapScreens`.
abstract class HeatmapScreen
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeatmapScreen._({
    required this.screen,
    required this.taps,
    required this.rageTaps,
  });

  factory HeatmapScreen({
    required String screen,
    required int taps,
    required int rageTaps,
  }) = _HeatmapScreenImpl;

  factory HeatmapScreen.fromJson(Map<String, dynamic> jsonSerialization) {
    return HeatmapScreen(
      screen: jsonSerialization['screen'] as String,
      taps: jsonSerialization['taps'] as int,
      rageTaps: jsonSerialization['rageTaps'] as int,
    );
  }

  String screen;

  int taps;

  int rageTaps;

  /// Returns a shallow copy of this [HeatmapScreen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeatmapScreen copyWith({String? screen, int? taps, int? rageTaps});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeatmapScreen',
      'screen': screen,
      'taps': taps,
      'rageTaps': rageTaps,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeatmapScreen',
      'screen': screen,
      'taps': taps,
      'rageTaps': rageTaps,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HeatmapScreenImpl extends HeatmapScreen {
  _HeatmapScreenImpl({
    required String screen,
    required int taps,
    required int rageTaps,
  }) : super._(screen: screen, taps: taps, rageTaps: rageTaps);

  /// Returns a shallow copy of this [HeatmapScreen]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeatmapScreen copyWith({String? screen, int? taps, int? rageTaps}) {
    return HeatmapScreen(
      screen: screen ?? this.screen,
      taps: taps ?? this.taps,
      rageTaps: rageTaps ?? this.rageTaps,
    );
  }
}
