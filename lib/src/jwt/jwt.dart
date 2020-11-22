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

  /// Create, RS256 sign and return new JWT
  String issueJWTRS256();

  /// Signing the token
  void _sign();

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
