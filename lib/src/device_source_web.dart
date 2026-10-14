import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

import 'device_info.dart' show browserVersion;

// The web side of `device_source.dart`. It talks to the platform interfaces
// directly: the main libraries of package_info_plus and device_info_plus
// import `dart:io` for Linux and Windows, which keeps an app from compiling to
// WebAssembly. Their web implementations still answer, registered by the app's
// plugin registrant.

/// Name, version and build number of the running app, from `version.json`.
Future<({String packageName, String version, String buildNumber})>
readAppInfo() async {
  final info = await PackageInfoPlatform.instance.getAll();
  return (
    packageName: info.packageName,
    version: info.version,
    buildNumber: info.buildNumber,
  );
}

/// The browser and its major version, e.g. `Chrome 153`.
Future<String> readOsVersion(String platform) async {
  final data = (await DeviceInfoPlatform.instance.deviceInfo()).data;
  final userAgent = data['userAgent'];
  return browserVersion(userAgent is String ? userAgent : '');
}
