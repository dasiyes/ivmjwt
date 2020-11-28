import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'dart:convert';

/// Unit testing the JWT object
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
