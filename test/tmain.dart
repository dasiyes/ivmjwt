import 'package:test/test.dart';
import 'utclasses/jwk_test.dart';
import 'utclasses/jwt_test.dart';

/// The ivmJWT package test suites
///
void main() {
  group('ivmJWT unit tests', () {
    /// Test suite for ivmJWT's classes unit tests
    ///
    test('JWK and JWKS object initiation and creation', () {
      initJwkJwks();
      createJwkJwks();
    });

    test('JWT init and creation', initJWT);

    test('Own token verify', () async {
      verifyOwnIssuedJWT();
    });

    test('Unit tests _verifyJWTRS256', () async {
      testIvmCheckIntegrity();
      testIvmCheckClaims();
      testIvmCheckSignature();
    });
  });
}
