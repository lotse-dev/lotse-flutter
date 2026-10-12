import 'package:flutter_test/flutter_test.dart';
import 'package:lotse/src/public_key_provider.dart';

void main() {
  test('sends the public key as a bearer token', () async {
    const provider = PublicKeyProvider('lt_pk_0123456789');
    expect(await provider.authHeaderValue, 'Bearer lt_pk_0123456789');
  });
}
