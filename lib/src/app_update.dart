import 'package:shared_preferences/shared_preferences.dart';
import 'lotse_log.dart';

const _appVersionKey = 'lotse.appVersion';

/// Name of the event a changed app version writes.
const appUpdateEventName = 'app_update';

/// Compares [current] with the app version this install ran last and
/// remembers [current]. Returns the change when there was an earlier version
/// and it differs; null on the first start and when nothing changed.
///
/// The version is remembered per app install, not per identity, so a
/// [Lotse.reset] does not report an update.
Future<({String from, String to})?> checkAppUpdate(
  SharedPreferences preferences,
  String current,
) async {
  final previous = preferences.getString(_appVersionKey);
  if (previous == current) return null;
  try {
    await preferences.setString(_appVersionKey, current);
  } catch (error) {
    lotseLog('could not persist the app version', error);
  }
  return previous == null ? null : (from: previous, to: current);
}
