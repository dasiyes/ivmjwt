import 'package:test/test.dart';
import 'utclasses/jwk_test.dart';

/// The ivmJWT package test suites
///
void main() {
  group('ivmJWT unit tests', () {
    /// Test suite for ivmJWT's classes unit tests
    ///
    test('JWK and JWKS object initiation...', () {
      initJwkJwks();
      createJwkJwks();
    });
  });
}
