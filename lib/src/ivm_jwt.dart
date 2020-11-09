part of '../ivmjwt.dart';

/// Ivmanto JWT
///
/// The Ivmanto`s implementation of JWT
///
class IvmJWT extends JWT {
  IvmJWT();

  JWK key;
  Map<String, String> header;
  Map<String, dynamic> payload;
  String signature;
  String token;

  @override
  void issueJWTRS256() {
    // TODO: implement issueJWTRS256
  }

  @override
  void sign() {
    // TODO: implement sign
  }

  /// Verify JWT RS256 signed token
  ///
  static Future<Map<String, dynamic>> verifyJWTRS256(String token) async {
    Map<String, dynamic> result = {};
    bool validHeader = false;
    String jwtHeader = '';

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
      jwtHeader = await Utilities.base64Decode(tokenSegments[0]);
      //TODO:[dedug] Remove 1 line below after debuging
      print('jwtHeader: $jwtHeader type: ${jwtHeader.runtimeType}');
    } catch (e) {
      rethrow;
    }

    // Verify if the header is a valid JSON
    try {
      validHeader = await Utilities.validateSegmentToJSON(jwtHeader);
      stdout.writeln('JWT Header valid?: $validHeader');
    } catch (e) {
      stdout.writeln('Error validating JWT token header! $e.');
      rethrow;
    }

    /// Base64url-decode the Payload, ensuring that no line breaks, whitespace, or other additional characters have been used, and verify that the decoded Payload is a valid JSON object.
    ///

    return result;
  } // end of verifyJWTRS256
}
