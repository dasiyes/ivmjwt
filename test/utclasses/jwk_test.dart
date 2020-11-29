import 'dart:convert' show json;
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

  /// T6:
  /// Load a key from real JSON. Check the loaded values?
  ///
  const keys = '''{
    "keys": [
        {
          "kty": "RSA",
          "use": "sig",
          "kid": "dedc012d07f52aedfd5f97784e1bcbe23c19724d",
          "e": "AQAB",
          "alg": "RS256",
          "n": "sV158-MQ-5-sP2iTJibiMap1ug8tNY97laOud3Se_3jd4INq36NwhLpgU3FC5SCfJOs9wehTLzv_hBuo-sW0JNjAEtMEE-SDtx5486gjymDR-5Iwv7bgt25tD0cDgiboZLt1RLn-nP-V3zgYHZa_s9zLjpNyArsWWcSh6tWe2R8yW6BqS8l4_9z8jkKeyAwWmdpkY8BtKS0zZ9yljiCxKvs8CKjfHmrayg45sZ8V1-aRcjtR2ECxATHjE8L96_oNddZ-rj2axf2vTmnkx3OvIMgx0tZ0ycMG6Wy8wxxaR5ir2LV3Gkyfh72U7tI8Q1sokPmH6G62JcduNY66jEQlvQ"
        },
        {
          "alg": "RS256",
          "e": "AQAB",
          "n": "syWuIlYmoWSl5rBQGOtYGwO5OCCZnhoWBCyl-x5gby5ofc4HNhBoVVMUggk-f_MH-pyMI5yRYsS_aPQ2bmSox2s4i9cPhxqtSAYMhTPwSwQ2BROC7xxi_N0ovp5Ivut5q8TwAn5kQZa_jR9d7JO20BUB7UqbMkBsqg2J8QTtMJ9YtA5BmUn4Y6vhIjTFtvrA6iM4i1cKoUD5Rirt5CYpcKwsLxBZbVk4E4rqgv7G0UlWt6NAs-z7XDkchlNBVpMUuiUBzxHl4LChc7dsWXRaO5vhu3j_2WnxuWCQZPlGoB51jD_ynZ027hhIcoa_tXg28_qb5Al78ZttiRCQDKueAQ",
          "use": "sig",
          "kid": "2e3025f26b595f96eac907cc2b9471422bcaeb93",
          "kty": "RSA"
        }
      ]
    }''';
  final jJWKS = json.decode(keys) as Map<String, dynamic>;
  final jwkSet = IvmRS256JWKS.fromJson(jJWKS);

  expect(jwkSet, isA<IvmRS256JWKS>());
  expect(jwkSet, isNotNull);
  expect(jwkSet.keys.containsKey('keys'), true);
  expect(jwkSet.keys.length, 1);
  final aKey = jwkSet.getKeyByIndex(0);
  expect(aKey, isA<IvmRS256JWK>());
  expect(aKey.alg, 'RS256');
  expect(aKey.n, isNotNull);
  final key2 = jwkSet.getKeyByKid('2e3025f26b595f96eac907cc2b9471422bcaeb93');
  expect(key2, isA<IvmRS256JWK>());
  expect(key2.alg, 'RS256');
  expect(key2.n, isNotNull);
  expect(key2.n.length, 342);
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
