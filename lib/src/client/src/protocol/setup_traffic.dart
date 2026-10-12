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

/// Link traffic of the last days as evidence, see SetupDiagnosis.
abstract class SetupTraffic
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SetupTraffic._({
    required this.days,
    required this.androidClicks,
    required this.inAppBrowserClicks,
    required this.linkOpens,
  });

  factory SetupTraffic({
    required int days,
    required int androidClicks,
    required int inAppBrowserClicks,
    required int linkOpens,
  }) = _SetupTrafficImpl;

  factory SetupTraffic.fromJson(Map<String, dynamic> jsonSerialization) {
    return SetupTraffic(
      days: jsonSerialization['days'] as int,
      androidClicks: jsonSerialization['androidClicks'] as int,
      inAppBrowserClicks: jsonSerialization['inAppBrowserClicks'] as int,
      linkOpens: jsonSerialization['linkOpens'] as int,
    );
  }

  int days;

  /// Clicks from Android that reached the server, i.e. opened in a browser.
  int androidClicks;

  /// Of those, clicks from in-app browsers (Instagram, Facebook, TikTok …),
  /// where App Links never open the app.
  int inAppBrowserClicks;

  /// `link_open` events: an App Link opened the app and the SDK resolved it.
  int linkOpens;

  /// Returns a shallow copy of this [SetupTraffic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SetupTraffic copyWith({
    int? days,
    int? androidClicks,
    int? inAppBrowserClicks,
    int? linkOpens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetupTraffic',
      'days': days,
      'androidClicks': androidClicks,
      'inAppBrowserClicks': inAppBrowserClicks,
      'linkOpens': linkOpens,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetupTraffic',
      'days': days,
      'androidClicks': androidClicks,
      'inAppBrowserClicks': inAppBrowserClicks,
      'linkOpens': linkOpens,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SetupTrafficImpl extends SetupTraffic {
  _SetupTrafficImpl({
    required int days,
    required int androidClicks,
    required int inAppBrowserClicks,
    required int linkOpens,
  }) : super._(
         days: days,
         androidClicks: androidClicks,
         inAppBrowserClicks: inAppBrowserClicks,
         linkOpens: linkOpens,
       );

  /// Returns a shallow copy of this [SetupTraffic]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SetupTraffic copyWith({
    int? days,
    int? androidClicks,
    int? inAppBrowserClicks,
    int? linkOpens,
  }) {
    return SetupTraffic(
      days: days ?? this.days,
      androidClicks: androidClicks ?? this.androidClicks,
      inAppBrowserClicks: inAppBrowserClicks ?? this.inAppBrowserClicks,
      linkOpens: linkOpens ?? this.linkOpens,
    );
  }
}
