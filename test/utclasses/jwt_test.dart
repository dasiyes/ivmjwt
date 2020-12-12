import 'dart:convert';
import 'dart:typed_data';

import 'package:ivmjwt/ivmjwt.dart';
import 'package:test/test.dart';

/// Unit testing the JWT object
///
void initJWT() {
  // TODO: [dev] implement JWT test suite
  /// T1:
  /// Check the segment header init
  ///
  final segHeader =
      SegmentHeader(alg: 'RS256', typ: 'JWT', cty: 'sig', kid: 'IVM512');
  expect(segHeader, isA<SegmentHeader>());
  expect(segHeader, isNotNull);
  expect(segHeader.kid, 'IVM512');

  final jsonHeader = json.decode(
          '{"alg": "RS256", "typ": "JWT", "cty": "JWS", "kid": "IVM512"}')
      as Map<String, dynamic>;
  final segHeader2 = SegmentHeader.fromJson(jsonHeader);
  expect(segHeader2, isA<SegmentHeader>());
  expect(segHeader2, isNotNull);
  expect(segHeader2.cty, 'JWS');

  /// T2:
  /// Check the segment payload init
  ///
}

void verifyOwnIssuedJWT() async {
  // Creating the claims
  final _claims = json.decode(
          '{\"iss\": \"Ivmanto.com\", \"maxAge\": 7200, \"ivmanto\": \"dev\"}')
      as Map<String, dynamic>;

  /// Instantiate segment payload and ivmJWT objects
  final segmentPayload = SegmentPayload.fromJson(_claims);
  final ivmjwt = IvmJWT(segmentPayload);

  /// call the issue method for RS256 signed token creation.
  final obj = await ivmjwt.issueJWTRS256();
  final token = obj['token'].toString();
  final keys = obj['publicKey'].toString();
  final segments = token.split('.');

  // expect the token to not be empty
  expect(token.isNotEmpty, true);
  // expect the keys to  not be empty
  expect(keys.isNotEmpty, true);
  expect(keys.contains('keys'), true);
  expect(segments.length == 3, true);

  /// Verification of the own issued token
  ///
  final result = await IvmJWT.decodeJWTRS256(token, keys);
  expect(result.containsKey('iss'), true);
  expect(result['iss'], 'Ivmanto.com');
  expect(result.containsKey('ivmanto'), true);
  expect(result['ivmanto'], 'dev');
  expect(result.containsKey('exp'), true);
}

/// Units testing _verifyJWTRS256 method
///
/// tests Integrity
///
void testIvmCheckIntegrity() async {
  /// T1:
  /// Test empty token verification in function _verifyJWTRS256. Expected result is to get in return FALSE value.
  /// BEcause it is private function this test is doen over the decodeJWTRS256 function, which expected result in this case is a NULL value. In between there should be stdout emit.

  expect(IvmJWT.decodeJWTRS256('', ''), completion(isNull));

  // Creating the claims
  final _claims = json.decode(
          '{\"iss\": \"Ivmanto.dev\", \"maxAge\": 7200, \"ivmanto\": \"verify\"}')
      as Map<String, dynamic>;

  /// Instantiate segment payload and ivmJWT objects
  final segmentPayload = SegmentPayload.fromJson(_claims);
  final ivmjwt = IvmJWT(segmentPayload);

  /// call the issue method for RS256 signed token creation.
  final obj = await ivmjwt.issueJWTRS256();
  final token = obj['token'].toString();

  /// T2:
  /// Test the case when the token integrity is broken:
  ///   * token length is NOT 3
  ///   * token last segment is empty
  ///
  /// A) testing !(tokenSegments.length == 3)
  final token1 = token.replaceAll('.', ':');
  expect(
      () => IvmJWT.decodeJWTRS256(token1, '*'),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString() == 'Exception: Token integrity is broken!')));

  /// B) testing (tokenSegments[2].isEmpty)
  final dotPosition = token.indexOf('.');
  final dotPosition2 = token.indexOf('.', dotPosition + 1);
  final token2 = token.substring(0, dotPosition2 + 1);
  expect(
      () => IvmJWT.decodeJWTRS256(token2, '*'),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString() == 'Exception: Token integrity is broken!')));

  /// T3:
  /// Test case when base64 decoding throws an exception
  ///   * token header
  ///   * token payload
  ///
  final token3 = token.replaceAll('a', '+');
  expect(
      () => IvmJWT.decodeJWTRS256(token3, '*'),
      throwsA(predicate((e) =>
          e is Exception &&
          e
              .toString()
              .startsWith('Exception: Error decoding header segment! '))));

  final token4 = token.replaceFirst('a', '+', dotPosition);
  expect(
      () => IvmJWT.decodeJWTRS256(token4, '*'),
      throwsA(predicate((e) =>
          e is Exception &&
          e
              .toString()
              .startsWith('Exception: Error decoding payload segment! '))));

  /// T4:
  /// Test case when validating JSON throws an exception
  ///   * token header
  ///   * token payload
  ///

  // Creating the header & claims with wrong JSON format
  const _header = '{\"alg\": RS256, \"typ\": \"JWT\"}';
  const _claimsStr =
      '{\"iss\": Ivmanto.dev, \"maxAge\": 7200, \"ivmanto\": \"verify\"}';
  final segment1 = base64Url.encode(_header.codeUnits);
  final segment2 = base64Url.encode(_claimsStr.codeUnits);
  const segment3 = 'aftrev';

  // Composing the token with wrong json values for header and payload
  final fToken = '${segment1}.${segment2}.${segment3}';

  expect(
      () => IvmJWT.decodeJWTRS256(fToken, '*'),
      throwsA(predicate((e) =>
          e is Exception &&
          e.toString().startsWith(
              'Exception: Token integrity validation has failed!'))));
}

/// Units testing _verifyJWTRS256 method
///
/// tests Claims
///
void testIvmCheckClaims() async {}

/// Units testing _verifyJWTRS256 method
///
/// test Signature
///
void testIvmCheckSignature() async {}
