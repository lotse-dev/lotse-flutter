import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// What the SDK reports about the device it runs on.
typedef DeviceDetails = ({
  String platform,
  String osVersion,
  String locale,
  String? appVersion,
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
  final packageInfo = await PackageInfo.fromPlatform();
  return (
    platform: platform,
    osVersion: await _osVersion(platform),
    locale: PlatformDispatcher.instance.locale.toString(),
    appVersion: appVersionOf(packageInfo),
  );
}

/// The version the SDK reports: `version+buildNumber`, e.g. `1.4.0+12`.
/// Segments on `appVersion` compare against exactly this text.
String appVersionOf(PackageInfo info) => '${info.version}+${info.buildNumber}';

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
Future<String> currentAppVersion() async =>
    appVersionOf(await PackageInfo.fromPlatform());

Future<String> _osVersion(String platform) async {
  final deviceInfo = DeviceInfoPlugin();
  switch (platform) {
    case 'android':
      return (await deviceInfo.androidInfo).version.release;
    case 'ios':
      return (await deviceInfo.iosInfo).systemVersion;
    case 'web':
      return browserVersion((await deviceInfo.webBrowserInfo).userAgent ?? '');
    default:
      // Desktop has no single version field, so take the first one the
      // platform happens to report.
      final data = (await deviceInfo.deviceInfo).data;
      for (final key in const [
        'osRelease',
        'displayVersion',
        'versionId',
        'appVersion',
      ]) {
        final value = data[key];
        if (value is String && value.isNotEmpty) return value;
      }
      return 'unknown';
  }
}
