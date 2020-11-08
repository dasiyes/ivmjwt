/// Abstract JWT Token Class
///
/// The definition of JWT Token implementation
abstract class JWT extends Object {
  Map<String, String> header;
  Map<String, dynamic> payload;
  String signature;

  /// Registered claim names
  Map<String, dynamic> claim;

  /// Private claims to join the registered claim names;
  Map<String, dynamic> data;

  /// Create, RS256 sign and return new JWT
  void issueJWTRS256();

  /// Verify RS256 signed JWT. Unsigned token MUST NOT be verified.
  static void verifyJWTRS256() {
    // provide the JWT token String value
  }

  /// Signing the JWT with the used encryption method in the header
  void sign();
}
