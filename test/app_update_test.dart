import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences preferences;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  test('when the app starts for the first time then no update is reported, '
      'the version is remembered', () async {
    expect(await checkAppUpdate(preferences, '1.0.0+1'), isNull);
    expect(await checkAppUpdate(preferences, '1.0.0+1'), isNull);
  });

  test('when the version changes then the update is reported once', () async {
    await checkAppUpdate(preferences, '1.0.0+1');

    final update = await checkAppUpdate(preferences, '1.1.0+2');
    expect(update?.from, '1.0.0+1');
    expect(update?.to, '1.1.0+2');
    expect(await checkAppUpdate(preferences, '1.1.0+2'), isNull);
  });

  test(
    'when only the build number changes then that is an update too',
    () async {
      await checkAppUpdate(preferences, '1.0.0+1');
      expect(await checkAppUpdate(preferences, '1.0.0+2'), isNotNull);
    },
  );
}
