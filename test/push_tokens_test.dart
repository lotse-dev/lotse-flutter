import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/client/lotse_client.dart' as generated;
import 'package:lotse/src/push_tokens.dart';

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  Future<String?> fcm() async => 'fcm-token';
  Future<String?> apns() async => 'apns-token';

  test('Given Android when the tokens are fetched then only the FCM token '
      'is reported', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(await lotsePushTokens(fcmToken: fcm, apnsToken: apns), [
      (token: 'fcm-token', provider: generated.PushProvider.fcm),
    ]);
  });

  group('Given iOS', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.iOS);

    test(
      'when the tokens are fetched then FCM and APNs are reported',
      () async {
        expect(await lotsePushTokens(fcmToken: fcm, apnsToken: apns), [
          (token: 'apns-token', provider: generated.PushProvider.apns),
          (token: 'fcm-token', provider: generated.PushProvider.fcm),
        ]);
      },
    );

    test('when one token fails or is missing then the other is still '
        'reported', () async {
      expect(
        await lotsePushTokens(
          fcmToken: () async => throw StateError('apns-token-not-set'),
          apnsToken: apns,
        ),
        [(token: 'apns-token', provider: generated.PushProvider.apns)],
      );
      expect(
        await lotsePushTokens(fcmToken: fcm, apnsToken: () async => null),
        [(token: 'fcm-token', provider: generated.PushProvider.fcm)],
      );
    });
  });
}
