import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/push_channel.dart';

void main() {
  late List<AndroidNotificationChannel> created;

  Future<void> record(AndroidNotificationChannel channel) async =>
      created.add(channel);

  setUp(() => created = []);
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  group('Given Android', () {
    setUp(() => debugDefaultTargetPlatformOverride = TargetPlatform.android);

    test('when creating the channel then the server channel id with high '
        'importance', () async {
      await createLotsePushChannel(create: record);

      expect(created, hasLength(1));
      expect(created.single.id, 'lotse_push');
      expect(created.single.importance, Importance.high);
      expect(created.single.enableVibration, isTrue);
    });

    test('when the plugin fails then no error reaches the app', () async {
      await expectLater(
        createLotsePushChannel(
          create: (_) async => throw StateError('no plugin'),
        ),
        completes,
      );
    });
  });

  test('Given iOS when creating the channel then nothing happens', () async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await createLotsePushChannel(create: record);

    expect(created, isEmpty);
  });
}
