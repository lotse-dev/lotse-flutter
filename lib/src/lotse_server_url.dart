/// Which server URLs the SDK talks to, and which it refuses before the first
/// request leaves the device.
///
/// The public project key is meant to be public, the install credential and
/// the conversations behind it are not. A remote target over plain `http`
/// would hand both to anyone on the path, so the SDK refuses it. Development
/// against a server on the same machine is the one exception, and it has to be
/// asked for.
library;

/// Refuses a server URL the SDK will not talk to.
///
/// The message names the rule that was broken, never the URL: it may carry
/// embedded credentials or a token in its path.
class LotseServerUrlError extends ArgumentError {
  /// Creates the error for [reason].
  LotseServerUrlError(String reason)
    : super.value('<hidden>', 'serverUrl', reason);
}

/// Hosts a development build may reach over plain `http`.
///
/// The loopback names and addresses of the device itself, plus the addresses
/// under which the Android emulator and Genymotion reach the host machine that
/// runs them. Everything else, including a server in the same LAN, is a remote
/// target and needs TLS.
bool isLotseLoopbackHost(String host) {
  final name = host.toLowerCase();
  if (name == 'localhost' || name.endsWith('.localhost')) return true;
  // The Android emulator maps these to the loopback of the host machine.
  if (name == '10.0.2.2' || name == '10.0.3.2') return true;
  if (name == '::1' || name == '[::1]') return true;
  final octets = name.split('.');
  if (octets.length != 4) return false;
  final numbers = [for (final octet in octets) int.tryParse(octet)];
  if (numbers.any((number) => number == null || number < 0 || number > 255)) {
    return false;
  }
  // 127.0.0.0/8 is loopback as a whole.
  return numbers.first == 127;
}

/// Checks [serverUrl] and returns it in the form the client is given.
///
/// Accepts `https://host[:port][/base/path/]`. A base path is kept, a missing
/// trailing slash is added. Rejected are: anything that is not a URL, a scheme
/// other than `http` or `https`, a missing host, credentials embedded in the
/// URL (`https://user:secret@host/`), a query or a fragment, and `http` for
/// any remote host.
///
/// [allowInsecureLocalhost] is the development exception: with it, and only in
/// a build that is not a release build ([isReleaseBuild]), `http` is accepted
/// for the hosts of [isLotseLoopbackHost]. It never opens plain text to a
/// remote host, and it does nothing in a released app.
///
/// Throws [LotseServerUrlError], which quotes no part of the URL.
Uri checkLotseServerUrl(
  String serverUrl, {
  bool allowInsecureLocalhost = false,
  required bool isReleaseBuild,
}) {
  final trimmed = serverUrl.trim();
  if (trimmed.isEmpty) {
    throw LotseServerUrlError('a server URL is required');
  }
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.isAbsolute || uri.host.isEmpty) {
    throw LotseServerUrlError(
      'must be an absolute URL, e.g. https://api.example.com/',
    );
  }
  final scheme = uri.scheme.toLowerCase();
  if (scheme != 'https' && scheme != 'http') {
    throw LotseServerUrlError('must use https');
  }
  if (uri.userInfo.isNotEmpty) {
    throw LotseServerUrlError('must not carry credentials in the URL');
  }
  if (uri.hasQuery || uri.hasFragment) {
    throw LotseServerUrlError('must not carry a query or a fragment');
  }
  if (scheme == 'http') {
    final local = isLotseLoopbackHost(uri.host);
    if (!local) {
      throw LotseServerUrlError('must use https for a remote server');
    }
    if (!allowInsecureLocalhost) {
      throw LotseServerUrlError(
        'http needs allowInsecureLocalhost: true, for development only',
      );
    }
    if (isReleaseBuild) {
      throw LotseServerUrlError(
        'http is not available in a release build, not even for localhost',
      );
    }
  }
  final path = uri.path.endsWith('/') ? uri.path : '${uri.path}/';
  return Uri(
    scheme: scheme,
    host: uri.host.toLowerCase(),
    port: uri.hasPort ? uri.port : null,
    path: path,
  );
}

/// Names the target a stored identity belongs to: scheme, host, port and base
/// path of [serverUrl], which [checkLotseServerUrl] has already checked.
///
/// Two URLs that differ here are two servers as far as the SDK is concerned,
/// and an identity of one is never shown to the other.
String lotseServerOrigin(Uri serverUrl) => serverUrl.toString();
