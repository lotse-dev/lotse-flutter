import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/device_info.dart';

void main() {
  test('maps Flutter platforms to Lotse platform names', () {
    expect(platformName(TargetPlatform.android, isWeb: false), 'android');
    expect(platformName(TargetPlatform.iOS, isWeb: false), 'ios');
    expect(platformName(TargetPlatform.macOS, isWeb: false), 'other');
    expect(platformName(TargetPlatform.linux, isWeb: false), 'other');
  });

  test('web wins over the target platform', () {
    expect(platformName(TargetPlatform.android, isWeb: true), 'web');
  });

  group('browserVersion', () {
    const agents = {
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
              '(KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36':
          'Chrome 140',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
              '(KHTML, like Gecko) HeadlessChrome/153.0.0.0 Safari/537.36':
          'Chrome 153',
      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like '
              'Gecko) Chrome/140.0.0.0 Mobile Safari/537.36':
          'Chrome 140',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, '
              'like Gecko) Chrome/140.0.0.0 Safari/537.36 Edg/140.0.3485.54':
          'Edge 140',
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, '
              'like Gecko) Chrome/139.0.0.0 Safari/537.36 OPR/123.0.0.0':
          'Opera 123',
      'Mozilla/5.0 (Linux; Android 14; SM-S918B) AppleWebKit/537.36 (KHTML, '
              'like Gecko) SamsungBrowser/28.0 Chrome/130.0.0.0 Mobile '
              'Safari/537.36':
          'Samsung Internet 28',
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:143.0) Gecko/20100101 '
              'Firefox/143.0':
          'Firefox 143',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/'
              '605.1.15 (KHTML, like Gecko) Version/18.6 Mobile/15E148 '
              'Safari/604.1':
          'Safari 18',
      'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6 like Mac OS X) AppleWebKit/'
              '605.1.15 (KHTML, like Gecko) CriOS/140.0.7339.122 Mobile/15E148 '
              'Safari/604.1':
          'Chrome 140',
      'curl/8.7.1': 'unknown',
      '': 'unknown',
    };
    for (final MapEntry(key: agent, value: expected) in agents.entries) {
      test('$expected from ${agent.isEmpty ? 'nothing' : agent}', () {
        expect(browserVersion(agent), expected);
      });
    }
  });
}
