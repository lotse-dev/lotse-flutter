import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Name, version and build number of the running app.
Future<({String packageName, String version, String buildNumber})>
readAppInfo() async {
  final info = await PackageInfo.fromPlatform();
  return (
    packageName: info.packageName,
    version: info.version,
    buildNumber: info.buildNumber,
  );
}

/// The OS version on Android and iOS, the first version field desktop
/// platforms happen to report, `unknown` otherwise. The web has its own in
/// `device_source_web.dart`.
Future<String> readOsVersion(String platform) async {
  final deviceInfo = DeviceInfoPlugin();
  switch (platform) {
    case 'android':
      return (await deviceInfo.androidInfo).version.release;
    case 'ios':
      return (await deviceInfo.iosInfo).systemVersion;
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
