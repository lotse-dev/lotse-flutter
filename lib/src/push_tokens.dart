import 'package:flutter/foundation.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;

/// One push token of this device and the transport it belongs to.
typedef LotsePushToken = ({String token, generated.PushProvider provider});

/// The tokens the server may send to: the FCM token everywhere and, on iOS,
/// the APNs device token as well. The server sends over APNs when the project
/// has an APNs key and falls back to FCM otherwise.
///
/// A token that cannot be fetched is left out, so a missing APNs token does
/// not cost the FCM one. [fcmToken] and [apnsToken] are the plugin calls,
/// replaced in tests.
Future<List<LotsePushToken>> lotsePushTokens({
  required Future<String?> Function() fcmToken,
  required Future<String?> Function() apnsToken,
}) async {
  final tokens = <LotsePushToken>[];
  Future<void> add(
    generated.PushProvider provider,
    Future<String?> Function() fetch,
  ) async {
    try {
      final token = await fetch();
      if (token != null && token.isNotEmpty) {
        tokens.add((token: token, provider: provider));
      }
    } catch (error) {
      // Only the kind: the message could quote a token.
      debugPrint('Lotse: no ${provider.name} push token: ${error.runtimeType}');
    }
  }

  // APNs first: on iOS the FCM token only exists once the APNs token does.
  // When it is not there yet, `onTokenRefresh` reports both later.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
    await add(generated.PushProvider.apns, apnsToken);
  }
  await add(generated.PushProvider.fcm, fcmToken);
  return tokens;
}
