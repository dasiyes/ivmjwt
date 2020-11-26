import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';

/// Unit testing the JWK and JWKS classes
void initJwkJwks() {
  /// T1:
  /// kty is mandatory property and JWK cannot be created without it
  /// expected result: throw exception
  ///
  expect(
      () => IvmRS256JWK(''),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString() == 'Exception: Unacceptable value for the key type!')));

  /// T2:
  /// kty not in ['EC', 'RSA', 'oct']
  ///
  expect(
      () => IvmRS256JWK('SMTH'),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString() == 'Exception: Unacceptable value for the key type!')));

  /// T3:
  /// kty IS IN ['EC', 'RSA', 'oct']
  ///
  expect(IvmRS256JWK('RSA'), isA<IvmRS256JWK>());

  /// T4:
  /// A JWKS must have a "keys" attribute
  ///
  expect(
      () => IvmRS256JWKS({}),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString() ==
              'Exception: Invalid structure of the object with keys!')));

  /// T5:
  /// Init correct with "keys" attribute
  ///
  expect(IvmRS256JWKS({'keys': []}), isA<IvmRS256JWKS>());
}

void createJwkJwks() {
  /// T1:
  /// Create a new JWK from json
  ///
  final jwk = IvmRS256JWK.fromJson({
    'kty': 'RSA',
    'alg': 'RS256',
    'use': 'sig',
    'kid': 'IVM66',
    'n':
        'b4-mNzh4g22qyPPl41terrV5E9EIVoXW3h490HaBgd1LH9DrM-P_WfH_BkB1_QB8ZOB13rhT3I-A7LjubhWVx0Mwex-qenrcvgCOHgy1mifEy_L1yJ8dP5G8mJ39QVkX3uhOO1bIdDXvU7NHmpz_MQB7jJLuW-KfHtlWsoza5f7nVQrqOJdMMvzjnVwi3OfGR9wMaBZp-z_4FSSV1gs4l5zr-kKTrJa40jrU-WQ_0cKhOVDGkCwvxPvvygfWNRlv1ZMCC_9A88l-NLNoVDSLbP-DAUMj8jNTNfAPZ0w5-_tqPi9AU9lqN1nlzZNkYUXUEck_8o7YCTlay6WPNIYkoQ==',
    'e': 'AQAB'
  });
  expect(jwk, isA<IvmRS256JWK>());

  /// T2:
  /// Check the expected attributes values from the T1 above.
  ///
  expect(jwk.kty, 'RSA');
  expect(jwk.alg, 'RS256');
  expect(jwk.kid, 'IVM66');

  /// T3:
  /// test the function getRSAPublicKey
  ///
  expect(jwk.getRSAPublicKey(), isA<RSAPublicKey>());
  expect(jwk.getRSAPublicKey(), isNotNull);

  /// T4:
  /// create a new JWKS from JSON
  ///
  final jwks = IvmRS256JWKS.fromJson({
    'keys': [
      {'kty': 'RSA', 'alg': 'RS256', 'use': 'sig', 'kid': 'XXX66'},
      {'kty': 'EC', 'alg': 'HS256', 'use': 'sig', 'kid': 'IVM04'}
    ]
  });
  expect(jwks, isA<IvmRS256JWKS>());
  expect(jwks, isNotNull);
  expect(jwks.getKeyByIndex(0), isA<IvmRS256JWK>());
  expect(jwks.getKeyByIndex(1).kty, 'EC');
  expect(jwks.getKeyByIndex(0).kid, 'XXX66');
  expect(jwks.getKeyByKid('IVM04'), isA<IvmRS256JWK>());
  expect(jwks.getKeyByKid('IVM04').alg, 'HS256');

  /// T5:
  /// test the method addJWK a JWK to the list
  ///
  jwks.addJWK(jwk);
  expect(jwks, isA<IvmRS256JWKS>());
  expect(jwks.getKeyByIndex(2), isA<IvmRS256JWK>());
  expect(jwks.getKeyByIndex(2).kid, 'IVM66');
  expect(jwks.getKeyByKid('IVM66').alg, 'RS256');
}
