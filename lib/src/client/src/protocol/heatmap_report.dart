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
import 'device_platform.dart' as _ij3iar7l;
import 'heatmap_background_info.dart' as _immlrb5m;
import 'heatmap_cell.dart' as _i2wopt0u;
import 'heatmap_width_class.dart' as _ibbfwb4e;

/// Taps of one screen, platform and width class counted in cells over its
/// background, see `AnalyticsEndpoint.heatmap`. Raw taps never leave the
/// server.
abstract class HeatmapReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  HeatmapReport._({
    required this.screen,
    required this.platform,
    required this.widthClass,
    this.appVersion,
    required this.days,
    required this.cellSize,
    required this.width,
    required this.height,
    required this.taps,
    required this.rageTaps,
    required this.outside,
    required this.cells,
    this.background,
    required this.backgroundOfOtherVersion,
    required this.appVersions,
  });

  factory HeatmapReport({
    required String screen,
    required _ij3iar7l.DevicePlatform platform,
    required _ibbfwb4e.HeatmapWidthClass widthClass,
    String? appVersion,
    required int days,
    required int cellSize,
    required int width,
    required int height,
    required int taps,
    required int rageTaps,
    required int outside,
    required List<_i2wopt0u.HeatmapCell> cells,
    _immlrb5m.HeatmapBackgroundInfo? background,
    required bool backgroundOfOtherVersion,
    required List<String> appVersions,
  }) = _HeatmapReportImpl;

  factory HeatmapReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return HeatmapReport(
      screen: jsonSerialization['screen'] as String,
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      widthClass: _ibbfwb4e.HeatmapWidthClass.fromJson(
        (jsonSerialization['widthClass'] as String),
      ),
      appVersion: jsonSerialization['appVersion'] as String?,
      days: jsonSerialization['days'] as int,
      cellSize: jsonSerialization['cellSize'] as int,
      width: jsonSerialization['width'] as int,
      height: jsonSerialization['height'] as int,
      taps: jsonSerialization['taps'] as int,
      rageTaps: jsonSerialization['rageTaps'] as int,
      outside: jsonSerialization['outside'] as int,
      cells: _ist2d7e6.Protocol().deserialize<List<_i2wopt0u.HeatmapCell>>(
        jsonSerialization['cells'],
      ),
      background: jsonSerialization['background'] == null
          ? null
          : _ist2d7e6.Protocol().deserialize<_immlrb5m.HeatmapBackgroundInfo>(
              jsonSerialization['background'],
            ),
      backgroundOfOtherVersion: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['backgroundOfOtherVersion'],
      ),
      appVersions: _ist2d7e6.Protocol().deserialize<List<String>>(
        jsonSerialization['appVersions'],
      ),
    );
  }

  String screen;

  _ij3iar7l.DevicePlatform platform;

  _ibbfwb4e.HeatmapWidthClass widthClass;

  /// Null for all versions.
  String? appVersion;

  int days;

  /// Edge of a cell in logical pixels.
  int cellSize;

  /// Size of the plane the cells lie on: the background, or without one
  /// the extent of the taps.
  int width;

  int height;

  int taps;

  int rageTaps;

  /// Taps that fall outside the background, e.g. far down a list the
  /// background does not show. Counted, not drawn.
  int outside;

  /// The fullest cells first, at most `maxHeatmapCells`.
  List<_i2wopt0u.HeatmapCell> cells;

  _immlrb5m.HeatmapBackgroundInfo? background;

  /// The background is the newest of another version, because the chosen
  /// one has none.
  bool backgroundOfOtherVersion;

  /// App versions with taps in the range, newest first.
  List<String> appVersions;

  /// Returns a shallow copy of this [HeatmapReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  HeatmapReport copyWith({
    String? screen,
    _ij3iar7l.DevicePlatform? platform,
    _ibbfwb4e.HeatmapWidthClass? widthClass,
    String? appVersion,
    int? days,
    int? cellSize,
    int? width,
    int? height,
    int? taps,
    int? rageTaps,
    int? outside,
    List<_i2wopt0u.HeatmapCell>? cells,
    _immlrb5m.HeatmapBackgroundInfo? background,
    bool? backgroundOfOtherVersion,
    List<String>? appVersions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HeatmapReport',
      'screen': screen,
      'platform': platform.toJson(),
      'widthClass': widthClass.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      'days': days,
      'cellSize': cellSize,
      'width': width,
      'height': height,
      'taps': taps,
      'rageTaps': rageTaps,
      'outside': outside,
      'cells': cells.toJson(valueToJson: (v) => v.toJson()),
      if (background != null) 'background': background?.toJson(),
      'backgroundOfOtherVersion': backgroundOfOtherVersion,
      'appVersions': appVersions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'HeatmapReport',
      'screen': screen,
      'platform': platform.toJson(),
      'widthClass': widthClass.toJson(),
      if (appVersion != null) 'appVersion': appVersion,
      'days': days,
      'cellSize': cellSize,
      'width': width,
      'height': height,
      'taps': taps,
      'rageTaps': rageTaps,
      'outside': outside,
      'cells': cells.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (background != null) 'background': background?.toJsonForProtocol(),
      'backgroundOfOtherVersion': backgroundOfOtherVersion,
      'appVersions': appVersions.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HeatmapReportImpl extends HeatmapReport {
  _HeatmapReportImpl({
    required String screen,
    required _ij3iar7l.DevicePlatform platform,
    required _ibbfwb4e.HeatmapWidthClass widthClass,
    String? appVersion,
    required int days,
    required int cellSize,
    required int width,
    required int height,
    required int taps,
    required int rageTaps,
    required int outside,
    required List<_i2wopt0u.HeatmapCell> cells,
    _immlrb5m.HeatmapBackgroundInfo? background,
    required bool backgroundOfOtherVersion,
    required List<String> appVersions,
  }) : super._(
         screen: screen,
         platform: platform,
         widthClass: widthClass,
         appVersion: appVersion,
         days: days,
         cellSize: cellSize,
         width: width,
         height: height,
         taps: taps,
         rageTaps: rageTaps,
         outside: outside,
         cells: cells,
         background: background,
         backgroundOfOtherVersion: backgroundOfOtherVersion,
         appVersions: appVersions,
       );

  /// Returns a shallow copy of this [HeatmapReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  HeatmapReport copyWith({
    String? screen,
    _ij3iar7l.DevicePlatform? platform,
    _ibbfwb4e.HeatmapWidthClass? widthClass,
    Object? appVersion = _Undefined,
    int? days,
    int? cellSize,
    int? width,
    int? height,
    int? taps,
    int? rageTaps,
    int? outside,
    List<_i2wopt0u.HeatmapCell>? cells,
    Object? background = _Undefined,
    bool? backgroundOfOtherVersion,
    List<String>? appVersions,
  }) {
    return HeatmapReport(
      screen: screen ?? this.screen,
      platform: platform ?? this.platform,
      widthClass: widthClass ?? this.widthClass,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      days: days ?? this.days,
      cellSize: cellSize ?? this.cellSize,
      width: width ?? this.width,
      height: height ?? this.height,
      taps: taps ?? this.taps,
      rageTaps: rageTaps ?? this.rageTaps,
      outside: outside ?? this.outside,
      cells: cells ?? this.cells.map((e0) => e0.copyWith()).toList(),
      background: background is _immlrb5m.HeatmapBackgroundInfo?
          ? background
          : this.background?.copyWith(),
      backgroundOfOtherVersion:
          backgroundOfOtherVersion ?? this.backgroundOfOtherVersion,
      appVersions: appVersions ?? this.appVersions.map((e0) => e0).toList(),
    );
  }
}
