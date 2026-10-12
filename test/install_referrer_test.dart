import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences preferences;

  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('reading does not mark the referrer as reported', () async {
    // No plugin in tests: the read fails and returns null.
    expect(await readInstallReferrerOnce(preferences), isNull);
    expect(preferences.getBool('lotse.referrerReported'), isNull);
  });

  test('after marking it reported the referrer is not read again', () async {
    await markInstallReferrerReported(preferences);

    expect(preferences.getBool('lotse.referrerReported'), isTrue);
    expect(await readInstallReferrerOnce(preferences), isNull);
  });
}
