part of '../../ivmjwt.dart';

/// Abstract JWT Token Class
///
/// The definition of JWT Token implementation
abstract class JWT extends Object {
  SegmentHeader header;
  Map<String, dynamic> payload;
  String signature;
  String token;

  /// Registered claim names
  Map<String, dynamic> claim;

  /// Private claims to join the registered claim names;
  Map<String, dynamic> data;

  /// [RFC7519] Abstract
  /// JSON Web Token (JWT) is a compact, URL-safe means of representing
  /// claims to be transferred between two parties. The claims in a JWT
  /// are encoded as a JSON object that is used as the payload of a JSON
  /// Web Signature (JWS) structure or as the plaintext of a JSON Web
  /// Encryption (JWE) structure, enabling the claims to be digitally
  /// signed or integrity protected with a Message Authentication Code
  /// (MAC) and/or encrypted.
  ///
  /// Create RS256 signed token and return this JWT
  Future<String> issueJWTRS256();

  /// Verify RS256 signed JWT. Unsigned token MUST NOT be verified.
  static Future<bool> _verifyJWTRS256(String token, String jwks) async {
    return false;
  }

  /// decode the token payload and header and return it as json representation
  static Future<Map<String, dynamic>> decodeJWTRS256(
      String token, String jwks) async {
    Map<String, dynamic> result = {};
    if (await _verifyJWTRS256(token, jwks)) {
      return result;
    }
    return null;
  }
}
