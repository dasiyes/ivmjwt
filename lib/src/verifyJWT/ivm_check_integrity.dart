part of '../../ivmjwt.dart';

/// Token integrity check
///
/// The entry point for JWT validation function
Future<Map<String, dynamic>> _checkTokenIntegrity(String token) async {
  String jwtHeader = '';
  String jwtPayload = '';
  bool validHeader = false;
  bool validPayload = false;

  /// Step-1: Check for token integrity (3 parts)
  ///
  if (token.isEmpty) {
    throw Exception('Invalid or empty token provided!');
  }

  /// Check that the JWT is well-formed
  /// Ensure that the JWT conforms to the structure of a JWT. If this fails, the token is considered invalid, and the request must be rejected.
  ///

  /// Parse the JWT to extract its three components. The first segment is the Header, the second is the Payload, and the third is the Signature. Each segment is base64url encoded.
  ///
  final List<String> tokenSegments = token.split('.');

  /// Verify that the JWT contains three segments, separated by two period ('.') characters.
  ///
  if (!(tokenSegments.length == 3) || !(tokenSegments[2].length > 0)) {
    // Token does not have 3 inetgrity parts
    throw Exception('Token integrity is broken!');
  }

  /// Decode and check the header value
  ///
  /// Base64url-decode the Header, ensuring that no line breaks, whitespace, or other additional characters have been used, and verify that the decoded Header is a valid JSON object.
  ///
  try {
    jwtHeader = await Utilities.base64UrlDecode(tokenSegments[0]);
  } catch (e) {
    throw Exception('Error decoding header segment! $e.');
  }

  // Verify if the header is a valid JSON
  try {
    validHeader = JsonValidator(jwtHeader).validate();
    // validHeader = await Utilities.validateSegmentToJSON(jwtHeader);
  } catch (e) {
    throw Exception('Error validating header segment! $e.');
  }

  /// Base64url-decode the Payload, ensuring that no line breaks, whitespace, or other additional characters have been used, and verify that the decoded Payload is a valid JSON object.
  ///
  try {
    jwtPayload = await Utilities.base64UrlDecode(tokenSegments[1]);
  } catch (e) {
    throw Exception('Error decoding payload segment! $e.');
  }

  // Verify if the payload is a valid JSON
  try {
    validPayload = JsonValidator(jwtPayload).validate();
    // validPayload = await Utilities.validateSegmentToJSON(jwtPayload);
  } catch (e) {
    throw Exception('Error validating header segment! $e.');
  }

  // Return the validity check and decoded segments
  if (validHeader && validPayload) {
    return {"valid": true, "header": jwtHeader, "payload": jwtPayload};
  } else {
    return {"valid": false, "header": null, "payload": null};
  }
}
