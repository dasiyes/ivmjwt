import 'package:test/test.dart';
import 'jvalid/test_jvalid.dart';

/// The ivmJWT package test suite
///
void main() {
  group('JValid', () {
    test('Function validate() testing...', () {
      testJValidInit();
      testValidateFunctionMain();
    });
  });
}
