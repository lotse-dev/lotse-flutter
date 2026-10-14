import 'package:flutter/foundation.dart';

import 'device_source.dart'
    if (dart.library.js_interop) 'device_source_web.dart';

/// What the SDK reports about the device it runs on.
typedef DeviceDetails = ({
  String platform,
  String osVersion,
  String locale,
  String? appVersion,
  String? appBundleId,
});

/// Maps a Flutter platform to the name of a Lotse device platform.
///
/// Pure, so it can be tested without platform channels.
String platformName(TargetPlatform platform, {required bool isWeb}) {
  if (isWeb) return 'web';
  return switch (platform) {
    TargetPlatform.android => 'android',
    TargetPlatform.iOS => 'ios',
    _ => 'other',
  };
}

/// Collects everything the server needs to know about this install.
Future<DeviceDetails> collectDeviceDetails() async {
  final platform = platformName(defaultTargetPlatform, isWeb: kIsWeb);
  final app = await readAppInfo();
  return (
    platform: platform,
    osVersion: await readOsVersion(platform),
    locale: PlatformDispatcher.instance.locale.toString(),
    appVersion: appVersionOf(app.version, app.buildNumber),
    appBundleId: appBundleIdOf(platform, app.packageName),
  );
}

/// The Android package name or iOS bundle id the server picks the push
/// credential by. Null elsewhere: the web has no push and no bundle id.
String? appBundleIdOf(String platform, String packageName) =>
    (platform == 'android' || platform == 'ios') && packageName.isNotEmpty
    ? packageName
    : null;

/// The version the SDK reports: `version+buildNumber`, e.g. `1.4.0+12`.
/// Segments on `appVersion` compare against exactly this text.
String appVersionOf(String version, String buildNumber) =>
    '$version+$buildNumber';

/// The browser and its major version from [userAgent], e.g. `Chrome 153`,
/// which is what `osVersion` means on the web. `unknown` if neither is found.
///
/// The order matters: Edge, Opera and Samsung Internet also claim `Chrome/`,
/// Chrome on iOS claims `Safari/`. Pure, so it can be tested without a
/// browser.
String browserVersion(String userAgent) {
  const tokens = [
    ('Edge', 'Edg/'),
    ('Edge', 'EdgA/'),
    ('Edge', 'EdgiOS/'),
    ('Opera', 'OPR/'),
    ('Samsung Internet', 'SamsungBrowser/'),
    ('Firefox', 'Firefox/'),
    ('Firefox', 'FxiOS/'),
    ('Chrome', 'CriOS/'),
    ('Chrome', 'Chrome/'),
    ('Safari', 'Version/'),
  ];
  for (final (name, token) in tokens) {
    final at = userAgent.indexOf(token);
    if (at < 0) continue;
    final major = RegExp(r'\d+').matchAsPrefix(userAgent, at + token.length);
    if (major != null) return '$name ${major[0]}';
  }
  return 'unknown';
}

/// [appVersionOf] the running app.
Future<String> currentAppVersion() async {
  final app = await readAppInfo();
  return appVersionOf(app.version, app.buildNumber);
}
