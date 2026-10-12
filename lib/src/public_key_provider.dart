import 'package:lotse/src/client/lotse_client.dart';

/// Sends the project's public key as a Bearer token on every request.
class PublicKeyProvider implements ClientAuthKeyProvider {
  /// Creates a provider for [publicKey].
  const PublicKeyProvider(this.publicKey);

  /// The public key of the project, as found in the console.
  final String publicKey;

  @override
  Future<String?> get authHeaderValue async =>
      wrapAsBearerAuthHeaderValue(publicKey);
}
