import 'dart:convert';
import 'package:ivmjwt/ivmjwt.dart';

/// Create new, RS256 signed JWT
///
Future<void> issue() async {
  /// The token expire time is composed based on a property from claims "maxAge"
  /// If this property  is missing it will default to 3600. If the claims has
  /// the 'exp' key - its value will be used directly instead of calculating it
  /// from maxAge.
  final _claims = json.decode(
          '{\"iss\": \"Ivmanto.com\", \"maxAge\": 7200, \"ivmanto\": \"dev\"}')
      as Map<String, dynamic>;

  /// Instantiate segment payload and ivmJWT objects
  final segmentPayload = SegmentPayload.fromJson(_claims);
  final ivmjwt = IvmJWT(segmentPayload);

  /// call the issue method for RS256 signed token creation.
  final result = await ivmjwt.issueJWTRS256();

  /// Consume the result
  ///
  /// Expected result format
  /// ```json
  /// {"token": "xxx", "publicKey": {"keys":[]}}
  ///```
  ///
  print(result);
}

/// Verify RS256 signed JWT
///
void verify() async {
  const token = 'token_value';
  const jwks = '{"keys": []}';

  /// Expect bool if the token is valid or not
  final result = await IvmJWT.decodeJWTRS256(token, jwks);
  print(result);
}
