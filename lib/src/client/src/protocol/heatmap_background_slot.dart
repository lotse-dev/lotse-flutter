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
import 'heatmap_width_class.dart' as _ibbfwb4e;

/// A heatmap background the server lacks for the device that sent taps, see
/// `SdkEndpoint.submitTaps`. Platform and app version are the device's own.
abstract class HeatmapBackgroundSlot
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeatmapBackgroundSlot._({
    required this.screen,
    required this.widthClass,
  });

  factory HeatmapBackgroundSlot({
    required String screen,
    required _ibbfwb4e.HeatmapWidthClass widthClass,
  }) = _HeatmapBackgroundSlotImpl;

  factory HeatmapBackgroundSlot.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return HeatmapBackgroundSlot(
      screen: jsonSerialization['screen'] as String,
      widthClass: _ibbfwb4e.HeatmapWidthClass.fromJson(
        (jsonSerialization['widthClass'] as String),
      ),
    );
  }

  String screen;

  _ibbfwb4e.HeatmapWidthClass widthClass;

  /// Returns a shallow copy of this [HeatmapBackgroundSlot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeatmapBackgroundSlot copyWith({
    String? screen,
    _ibbfwb4e.HeatmapWidthClass? widthClass,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeatmapBackgroundSlot',
      'screen': screen,
      'widthClass': widthClass.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeatmapBackgroundSlot',
      'screen': screen,
      'widthClass': widthClass.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _HeatmapBackgroundSlotImpl extends HeatmapBackgroundSlot {
  _HeatmapBackgroundSlotImpl({
    required String screen,
    required _ibbfwb4e.HeatmapWidthClass widthClass,
  }) : super._(
         screen: screen,
         widthClass: widthClass,
       );

  /// Returns a shallow copy of this [HeatmapBackgroundSlot]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeatmapBackgroundSlot copyWith({
    String? screen,
    _ibbfwb4e.HeatmapWidthClass? widthClass,
  }) {
    return HeatmapBackgroundSlot(
      screen: screen ?? this.screen,
      widthClass: widthClass ?? this.widthClass,
    );
  }
}
