part of '../../ivmjwt.dart';

/// Abstract by [RFC7519]:
///
/// JSON Web Token (JWT) is a compact, URL-safe means of representing
/// claims to be transferred between two parties. The claims in a JWT
/// are encoded as a JSON object that is used as the payload of a JSON
/// Web Signature (JWS) structure or as the plaintext of a JSON Web
/// Encryption (JWE) structure, enabling the claims to be digitally
/// signed or integrity protected with a Message Authentication Code
/// (MAC) and/or encrypted.
///
abstract class JWT extends Object {
  /// JSON Web Token (JWT)
  ///    A string representing a set of claims as a JSON object that is
  ///    encoded in a JWS or JWE, enabling the claims to be digitally
  ///    signed or MACed and/or encrypted.
  ///
  JWT(this.claimsSet);

  /// JWT JOSE Header by [RFC7519]:
  ///
  SegmentHeader header;

  /// JWT Claims Set by [RFC7519]:
  ///
  SegmentPayload claimsSet;

  /// Create RS256 signed token and return this JWT alongside witht the
  /// public key that can be used to verify it.
  ///
  Future<Map<String, dynamic>> issueJWTRS256();

  /// Create RS256 signed token with provided private key to be signed with
  ///
  Future<String> signJWTRS256(RSAPrivateKey pvK);

  /// Verify RS256 signed JWT. Unsigned token MUST NOT be verified.
  ///
  static Future<bool> _verifyJWTRS256(String token, String jwks) async {
    return false;
  }

  /// decode the token payload and header and return it as json representation
  ///
  static Future<Map<String, dynamic>> decodeJWTRS256(
      String token, String jwks) async {
    final result = <String, dynamic>{};
    if (await _verifyJWTRS256(token, jwks)) {
      return result;
    }
    return null;
  }
}
