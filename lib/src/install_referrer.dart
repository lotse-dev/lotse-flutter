import 'package:flutter/foundation.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lotse_log.dart';

const _referrerReportedKey = 'lotse.referrerReported';

/// Reads the Play Install Referrer on Android until
/// [markInstallReferrerReported] ran.
///
/// Returns null after that, on other platforms and on any failure; the
/// referrer is a bonus, never a reason to fail the registration.
Future<String?> readInstallReferrerOnce(SharedPreferences preferences) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
  if (preferences.getBool(_referrerReportedKey) ?? false) return null;
  try {
    final details = await PlayInstallReferrer.installReferrer.timeout(
      const Duration(seconds: 5),
    );
    return details.installReferrer;
  } catch (error) {
    lotseLog('install referrer unavailable', error);
    return null;
  }
}

/// Stops further referrer reads. Call only after a registration that carried
/// a referrer succeeded, so a failed read or a failed first start sends it
/// again.
Future<void> markInstallReferrerReported(SharedPreferences preferences) async {
  try {
    await preferences.setBool(_referrerReportedKey, true);
  } catch (error) {
    lotseLog('could not persist the referrer flag', error);
  }
}
