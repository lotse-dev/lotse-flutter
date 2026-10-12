import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/lotse_server_url.dart';

/// Checks a URL the way a release build does: no development exception.
Uri _release(String url) => checkLotseServerUrl(url, isReleaseBuild: true);

/// Checks a URL the way a debug build does, with the development exception
/// asked for.
Uri _devWithException(String url) => checkLotseServerUrl(
  url,
  allowInsecureLocalhost: true,
  isReleaseBuild: false,
);

void main() {
  group('accepted targets', () {
    test('takes an https URL and adds the trailing slash', () {
      expect(
        _release('https://api.example.com').toString(),
        'https://api.example.com/',
      );
      expect(
        _release('https://api.example.com/').toString(),
        'https://api.example.com/',
      );
    });

    test('keeps a base path and a port', () {
      expect(
        _release('https://api.example.com:8443/lotse').toString(),
        'https://api.example.com:8443/lotse/',
      );
    });

    test('lowercases the host and trims the input', () {
      expect(
        _release('  https://API.Example.COM/  ').toString(),
        'https://api.example.com/',
      );
    });

    test('keeps a self-hosted host as configured', () {
      expect(
        _release('https://lotse.internal.acme.example/').toString(),
        'https://lotse.internal.acme.example/',
      );
    });
  });

  group('remote plain text', () {
    test('refuses http for a remote host, even in a debug build with the '
        'development exception', () {
      expect(
        () => _devWithException('http://api.example.com/'),
        throwsA(isA<LotseServerUrlError>()),
      );
    });

    test('refuses http for a host in the same LAN', () {
      expect(
        () => _devWithException('http://192.168.1.10:8080/'),
        throwsA(isA<LotseServerUrlError>()),
      );
    });

    test('refuses a host that only looks like loopback', () {
      for (final url in const [
        'http://127.0.0.1.example.com/',
        'http://10.0.2.20/',
        'http://localhost.example.com/',
        'http://0.0.0.0/',
      ]) {
        expect(
          () => _devWithException(url),
          throwsA(isA<LotseServerUrlError>()),
          reason: url,
        );
      }
    });
  });

  group('the development exception', () {
    test('needs to be asked for', () {
      expect(
        () => checkLotseServerUrl(
          'http://localhost:8080/',
          isReleaseBuild: false,
        ),
        throwsA(isA<LotseServerUrlError>()),
      );
    });

    test('does nothing in a release build', () {
      expect(
        () => checkLotseServerUrl(
          'http://localhost:8080/',
          allowInsecureLocalhost: true,
          isReleaseBuild: true,
        ),
        throwsA(isA<LotseServerUrlError>()),
      );
    });

    test('allows the device itself and the emulator host', () {
      for (final url in const [
        'http://localhost:8080/',
        'http://127.0.0.1:8080/',
        'http://127.1.2.3/',
        'http://10.0.2.2:8080/',
        'http://10.0.3.2:8080/',
        'http://[::1]:8080/',
      ]) {
        expect(_devWithException(url).scheme, 'http', reason: url);
      }
    });

    test('leaves https untouched', () {
      expect(_devWithException('https://api.example.com/').scheme, 'https');
    });
  });

  group('malformed targets', () {
    test('refuses an empty URL', () {
      expect(() => _release('   '), throwsA(isA<LotseServerUrlError>()));
    });

    test('refuses something that is not an absolute URL', () {
      for (final url in const [
        'api.example.com',
        '/lotse/',
        'https://',
        'mailto:support@example.com',
      ]) {
        expect(
          () => _release(url),
          throwsA(isA<LotseServerUrlError>()),
          reason: url,
        );
      }
    });

    test('refuses another scheme', () {
      for (final url in const [
        'ws://api.example.com/',
        'ftp://api.example.com/',
        'file:///tmp/lotse/',
      ]) {
        expect(
          () => _release(url),
          throwsA(isA<LotseServerUrlError>()),
          reason: url,
        );
      }
    });

    test('refuses credentials embedded in the URL', () {
      expect(
        () => _release('https://install:s3cr3t@api.example.com/'),
        throwsA(isA<LotseServerUrlError>()),
      );
    });

    test('refuses a query or a fragment', () {
      expect(
        () => _release('https://api.example.com/?key=abc'),
        throwsA(isA<LotseServerUrlError>()),
      );
      expect(
        () => _release('https://api.example.com/#abc'),
        throwsA(isA<LotseServerUrlError>()),
      );
    });
  });

  group('the error', () {
    test('quotes no part of the URL', () {
      const url = 'https://install:s3cr3t@api.example.com/team/abc?key=xyz';
      Object? thrown;
      try {
        _release(url);
      } catch (error) {
        thrown = error;
      }
      final message = thrown.toString();
      for (final part in const [
        's3cr3t',
        'install',
        'api.example.com',
        'abc',
        'xyz',
      ]) {
        expect(message, isNot(contains(part)), reason: part);
      }
    });

    test('of a remote http target quotes neither host nor path', () {
      Object? thrown;
      try {
        _release('http://api.example.com/team/secret-path/');
      } catch (error) {
        thrown = error;
      }
      expect(thrown.toString(), isNot(contains('api.example.com')));
      expect(thrown.toString(), isNot(contains('secret-path')));
      expect(thrown.toString(), contains('https'));
    });
  });

  group('isLotseLoopbackHost', () {
    test('knows the loopback names and addresses', () {
      expect(isLotseLoopbackHost('localhost'), isTrue);
      expect(isLotseLoopbackHost('LOCALHOST'), isTrue);
      expect(isLotseLoopbackHost('127.0.0.1'), isTrue);
      expect(isLotseLoopbackHost('127.255.255.254'), isTrue);
      expect(isLotseLoopbackHost('10.0.2.2'), isTrue);
    });

    test('knows what is not loopback', () {
      expect(isLotseLoopbackHost('api.example.com'), isFalse);
      expect(isLotseLoopbackHost('127.0.0.1.example.com'), isFalse);
      expect(isLotseLoopbackHost('128.0.0.1'), isFalse);
      expect(isLotseLoopbackHost('127.0.0.256'), isFalse);
      expect(isLotseLoopbackHost('192.168.0.1'), isFalse);
      expect(isLotseLoopbackHost(''), isFalse);
    });
  });

  group('lotseServerOrigin', () {
    test('tells two targets apart by scheme, host, port and base path', () {
      final origins = {
        for (final url in const [
          'https://api.example.com/',
          'https://api.example.com/lotse/',
          'https://api.example.com:8443/',
          'https://other.example.com/',
        ])
          lotseServerOrigin(_release(url)),
      };
      expect(origins, hasLength(4));
    });

    test('is the same for the same target written differently', () {
      expect(
        lotseServerOrigin(_release('https://API.example.com')),
        lotseServerOrigin(_release('  https://api.example.com/  ')),
      );
    });
  });
}
