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
import 'device_platform.dart' as _ij3iar7l;

/// What the SDK reports when registering or re-registering a device.
abstract class DeviceRegistration
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceRegistration._({
    required this.installId,
    required this.platform,
    required this.osVersion,
    required this.locale,
    this.appVersion,
    this.installReferrer,
    this.appBundleId,
  });

  factory DeviceRegistration({
    required String installId,
    required _ij3iar7l.DevicePlatform platform,
    required String osVersion,
    required String locale,
    String? appVersion,
    String? installReferrer,
    String? appBundleId,
  }) = _DeviceRegistrationImpl;

  factory DeviceRegistration.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceRegistration(
      installId: jsonSerialization['installId'] as String,
      platform: _ij3iar7l.DevicePlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      osVersion: jsonSerialization['osVersion'] as String,
      locale: jsonSerialization['locale'] as String,
      appVersion: jsonSerialization['appVersion'] as String?,
      installReferrer: jsonSerialization['installReferrer'] as String?,
      appBundleId: jsonSerialization['appBundleId'] as String?,
    );
  }

  String installId;

  _ij3iar7l.DevicePlatform platform;

  String osVersion;

  String locale;

  String? appVersion;

  String? installReferrer;

  /// Android package name or iOS bundle identifier of the running app. Picks
  /// the push credential of the matching app. Null from SDKs before 0.1.2
  /// and on the web.
  String? appBundleId;

  /// Returns a shallow copy of this [DeviceRegistration]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceRegistration copyWith({
    String? installId,
    _ij3iar7l.DevicePlatform? platform,
    String? osVersion,
    String? locale,
    String? appVersion,
    String? installReferrer,
    String? appBundleId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceRegistration',
      'installId': installId,
      'platform': platform.toJson(),
      'osVersion': osVersion,
      'locale': locale,
      if (appVersion != null) 'appVersion': appVersion,
      if (installReferrer != null) 'installReferrer': installReferrer,
      if (appBundleId != null) 'appBundleId': appBundleId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceRegistration',
      'installId': installId,
      'platform': platform.toJson(),
      'osVersion': osVersion,
      'locale': locale,
      if (appVersion != null) 'appVersion': appVersion,
      if (installReferrer != null) 'installReferrer': installReferrer,
      if (appBundleId != null) 'appBundleId': appBundleId,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceRegistrationImpl extends DeviceRegistration {
  _DeviceRegistrationImpl({
    required String installId,
    required _ij3iar7l.DevicePlatform platform,
    required String osVersion,
    required String locale,
    String? appVersion,
    String? installReferrer,
    String? appBundleId,
  }) : super._(
         installId: installId,
         platform: platform,
         osVersion: osVersion,
         locale: locale,
         appVersion: appVersion,
         installReferrer: installReferrer,
         appBundleId: appBundleId,
       );

  /// Returns a shallow copy of this [DeviceRegistration]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceRegistration copyWith({
    String? installId,
    _ij3iar7l.DevicePlatform? platform,
    String? osVersion,
    String? locale,
    Object? appVersion = _Undefined,
    Object? installReferrer = _Undefined,
    Object? appBundleId = _Undefined,
  }) {
    return DeviceRegistration(
      installId: installId ?? this.installId,
      platform: platform ?? this.platform,
      osVersion: osVersion ?? this.osVersion,
      locale: locale ?? this.locale,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      installReferrer: installReferrer is String?
          ? installReferrer
          : this.installReferrer,
      appBundleId: appBundleId is String? ? appBundleId : this.appBundleId,
    );
  }
}
