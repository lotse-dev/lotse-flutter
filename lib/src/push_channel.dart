import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'lotse_log.dart';

/// Android notification channel Lotse pushes are posted to.
///
/// Must match `FcmClient.androidChannelId` on the server.
const lotsePushChannelId = 'lotse_push';

/// High importance, so a push pops up and vibrates. Android fixes the
/// importance when the channel is first created; a change here needs a new id.
const lotsePushChannel = AndroidNotificationChannel(
  lotsePushChannelId,
  'Notifications',
  importance: Importance.high,
);

/// Creates [lotsePushChannel] on Android, so a push arriving while the app is
/// closed lands in it instead of the FCM default channel.
///
/// Does nothing on other platforms. Failures are logged, never thrown; without
/// the channel, pushes still arrive in the default channel. [create] replaces
/// the plugin call in tests.
Future<void> createLotsePushChannel({
  Future<void> Function(AndroidNotificationChannel channel)? create,
}) async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
  try {
    await (create ?? _createWithPlugin)(lotsePushChannel);
  } catch (error) {
    lotseLog('could not create the push channel', error);
  }
}

Future<void> _createWithPlugin(AndroidNotificationChannel channel) async {
  await FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);
}
