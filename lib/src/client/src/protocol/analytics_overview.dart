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
import 'analytics_count.dart' as _i1ktyzpb;
import 'platform_count.dart' as _iclib0po;

/// Key figures of one project in the time range [from, to), see
/// AnalyticsEndpoint.overview.
abstract class AnalyticsOverview
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AnalyticsOverview._({
    required this.from,
    required this.to,
    required this.activeDevices,
    required this.installs,
    required this.sessions,
    required this.topEvents,
    required this.topScreens,
    required this.platforms,
    required this.appVersions,
  });

  factory AnalyticsOverview({
    required DateTime from,
    required DateTime to,
    required int activeDevices,
    required int installs,
    required int sessions,
    required List<_i1ktyzpb.AnalyticsCount> topEvents,
    required List<_i1ktyzpb.AnalyticsCount> topScreens,
    required List<_iclib0po.PlatformCount> platforms,
    required List<_i1ktyzpb.AnalyticsCount> appVersions,
  }) = _AnalyticsOverviewImpl;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> jsonSerialization) {
    return AnalyticsOverview(
      from: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['from']),
      to: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['to']),
      activeDevices: jsonSerialization['activeDevices'] as int,
      installs: jsonSerialization['installs'] as int,
      sessions: jsonSerialization['sessions'] as int,
      topEvents: _ist2d7e6.Protocol()
          .deserialize<List<_i1ktyzpb.AnalyticsCount>>(
            jsonSerialization['topEvents'],
          ),
      topScreens: _ist2d7e6.Protocol()
          .deserialize<List<_i1ktyzpb.AnalyticsCount>>(
            jsonSerialization['topScreens'],
          ),
      platforms: _ist2d7e6.Protocol()
          .deserialize<List<_iclib0po.PlatformCount>>(
            jsonSerialization['platforms'],
          ),
      appVersions: _ist2d7e6.Protocol()
          .deserialize<List<_i1ktyzpb.AnalyticsCount>>(
            jsonSerialization['appVersions'],
          ),
    );
  }

  DateTime from;

  DateTime to;

  /// Devices with at least one event in the range.
  int activeDevices;

  /// Devices first seen in the range.
  int installs;

  /// session_start events in the range; the SDK writes one per app start.
  int sessions;

  /// Event names by count, most first, at most overviewTopLimit.
  List<_i1ktyzpb.AnalyticsCount> topEvents;

  /// The screen prop of screen_view events by count, most first, at most
  /// overviewTopLimit.
  List<_i1ktyzpb.AnalyticsCount> topScreens;

  /// Active devices per platform, most first. Platforms without active
  /// devices are left out.
  List<_iclib0po.PlatformCount> platforms;

  /// Active devices per current app version, most first, at most
  /// overviewTopLimit. A device only stores its latest version.
  List<_i1ktyzpb.AnalyticsCount> appVersions;

  /// Returns a shallow copy of this [AnalyticsOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AnalyticsOverview copyWith({
    DateTime? from,
    DateTime? to,
    int? activeDevices,
    int? installs,
    int? sessions,
    List<_i1ktyzpb.AnalyticsCount>? topEvents,
    List<_i1ktyzpb.AnalyticsCount>? topScreens,
    List<_iclib0po.PlatformCount>? platforms,
    List<_i1ktyzpb.AnalyticsCount>? appVersions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AnalyticsOverview',
      'from': from.toJson(),
      'to': to.toJson(),
      'activeDevices': activeDevices,
      'installs': installs,
      'sessions': sessions,
      'topEvents': topEvents.toJson(valueToJson: (v) => v.toJson()),
      'topScreens': topScreens.toJson(valueToJson: (v) => v.toJson()),
      'platforms': platforms.toJson(valueToJson: (v) => v.toJson()),
      'appVersions': appVersions.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AnalyticsOverview',
      'from': from.toJson(),
      'to': to.toJson(),
      'activeDevices': activeDevices,
      'installs': installs,
      'sessions': sessions,
      'topEvents': topEvents.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'topScreens': topScreens.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'platforms': platforms.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'appVersions': appVersions.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AnalyticsOverviewImpl extends AnalyticsOverview {
  _AnalyticsOverviewImpl({
    required DateTime from,
    required DateTime to,
    required int activeDevices,
    required int installs,
    required int sessions,
    required List<_i1ktyzpb.AnalyticsCount> topEvents,
    required List<_i1ktyzpb.AnalyticsCount> topScreens,
    required List<_iclib0po.PlatformCount> platforms,
    required List<_i1ktyzpb.AnalyticsCount> appVersions,
  }) : super._(
         from: from,
         to: to,
         activeDevices: activeDevices,
         installs: installs,
         sessions: sessions,
         topEvents: topEvents,
         topScreens: topScreens,
         platforms: platforms,
         appVersions: appVersions,
       );

  /// Returns a shallow copy of this [AnalyticsOverview]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AnalyticsOverview copyWith({
    DateTime? from,
    DateTime? to,
    int? activeDevices,
    int? installs,
    int? sessions,
    List<_i1ktyzpb.AnalyticsCount>? topEvents,
    List<_i1ktyzpb.AnalyticsCount>? topScreens,
    List<_iclib0po.PlatformCount>? platforms,
    List<_i1ktyzpb.AnalyticsCount>? appVersions,
  }) {
    return AnalyticsOverview(
      from: from ?? this.from,
      to: to ?? this.to,
      activeDevices: activeDevices ?? this.activeDevices,
      installs: installs ?? this.installs,
      sessions: sessions ?? this.sessions,
      topEvents:
          topEvents ?? this.topEvents.map((e0) => e0.copyWith()).toList(),
      topScreens:
          topScreens ?? this.topScreens.map((e0) => e0.copyWith()).toList(),
      platforms:
          platforms ?? this.platforms.map((e0) => e0.copyWith()).toList(),
      appVersions:
          appVersions ?? this.appVersions.map((e0) => e0.copyWith()).toList(),
    );
  }
}
