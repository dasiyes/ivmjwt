import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'dart:convert';

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
  await IvmJWT.decodeJWTRS256(token, '');
}

/// tests Claims
///
void testIvmCheckClaims() async {}

/// test Signature
///
void testIvmCheckSignature() async {}
