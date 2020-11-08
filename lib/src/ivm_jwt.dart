import 'package:ivmjwt/src/jwt.dart';

import 'jwt.dart';
import 'jwk.dart';
import 'utilities.dart';

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

  static Future<Map<String, dynamic>> verifyJWTRS256(String token) async {
    if (token.isNotEmpty) {
      /// Step-1: Check for token integrity (3 parts)
      ///
      /// Check that the JWT is well-formed
      /// Ensure that the JWT conforms to the structure of a JWT. If this fails, the token is considered invalid, and the request must be rejected.
      ///
      /// Verify that the JWT contains three segments, separated by two period ('.') characters.
      ///
      /// Parse the JWT to extract its three components. The first segment is the Header, the second is the Payload, and the third is the Signature. Each segment is base64url encoded.
      ///
      /// Base64url-decode the Header, ensuring that no line breaks, whitespace, or other additional characters have been used, and verify that the decoded Header is a valid JSON object.
      ///
      /// Base64url-decode the Payload, ensuring that no line breaks, whitespace, or other additional characters have been used, and verify that the decoded Payload is a valid JSON object.
      final List<String> tokenSegments = token.split('.');
      if (tokenSegments.length == 3 && tokenSegments[2].length > 0) {
        // Decode and check the header value
        try {
          final jwtHeader = await Utilities.base64Decode(tokenSegments[0]);
          print(jwtHeader);
        } catch (e) {
          rethrow;
        }
      } else {
        // Token does not have 3 inetgrity parts
        throw Exception('Token integrity is broken!');
      }
    }
    return {};
  }
}
