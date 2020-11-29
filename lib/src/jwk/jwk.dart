part of '../../ivmjwt.dart';

/// JWK - JSON Web Key [RFC7517]
///
/// [Ivmanto]: This class will respect RFC7517 but not in any mean implement it in full.
///
/// Abstract according to [RFC7517]:
/// A JSON Web Key (JWK) is a JavaScript Object Notation (JSON) data
///    structure that represents a cryptographic key.  This specification
///    also defines a JWK Set JSON data structure that represents a set of
///    JWKs.  Cryptographic algorithms and identifiers for use with this
///    specification are described in the separate JSON Web Algorithms (JWA)
///    specification and IANA registries established by that specification.
abstract class JWK {
  /// "kty" by  [RFC7517]:
  ///
  /// The "kty" (key type) parameter identifies the cryptographic algorithm
  ///  family used with the key, such as "RSA" or "EC".  "kty" values should
  ///  either be registered in the IANA "JSON Web Key Types" registry
  ///  established by [JWA] or be a value that contains a Collision-
  ///  Resistant Name.  The "kty" value is a case-sensitive string.  This
  ///  member MUST be present in a JWK.
  ///
  // ignore: avoid_unused_constructor_parameters, non_constant_identifier_names
  JWK(String kty,
      {this.use, this.alg, this.kid, this.key_ops, this.n, this.e}) {
    if (['EC', 'RSA', 'oct'].contains(kty)) {
      _kty = kty;
    } else {
      throw Exception('Unacceptable value for the key type!');
    }
  }

  /// Instantiate an object from a json object
  JWK.fromJson(Map<String, dynamic> json);

  /// "kty" (Key Type) Parameter
  ///
  /// The "kty" (key type) parameter identifies the cryptographic algorithm family used with the key, such as "RSA" or "EC". "kty" values should either be registered in the IANA "JSON Web Key Types" registry established by [JWA] or be a value that contains a Collision- Resistant Name. The "kty" value is a case-sensitive string. This member [MUST] be present in a JWK.
  ///
  /// A list of defined "kty" values can be found in the IANA "JSON Web Key Types" registry established by [JWA]; the initial contents of this registry are the values defined in [RFC7518 Section 6.1]: of [JWA]:.
  ///
  String _kty;

  /// "use" (Public Key Use) Parameter
  ///
  /// The "use" (public key use) parameter identifies the intended use of the public key. The "use" parameter is employed to indicate whether a public key is used for encrypting data or verifying the signature on data.
  /// Values defined by this specification are:
  ///   o  "sig" (signature)
  ///   o  "enc" (encryption)
  ///
  /// Other values MAY be used. The "use" value is a case-sensitive string. Use of the "use" member is OPTIONAL, unless the application requires its presence.
  String use;

  /// "alg" (Algorithm) Parameter
  ///
  /// The "alg" (algorithm) parameter identifies the algorithm intended for use with the key. The values used should either be registered in the IANA "JSON Web Signature and Encryption Algorithms" registry established by [JWA] or be a value that contains a Collision- Resistant Name. The "alg" value is a case-sensitive ASCII string. Use of this member is OPTIONAL.
  ///
  String alg;

  /// "kid" (Key ID) Parameter
  ///
  /// The "kid" (key ID) parameter is used to match a specific key. This is used, for instance, to choose among a set of keys within a JWK Set during key rollover. The structure of the "kid" value is unspecified. When "kid" values are used within a JWK Set, different keys within the JWK Set SHOULD use distinct "kid" values. (One example in which different keys might use the same "kid" value is if they have different "kty" (key type) values but are considered to be equivalent alternatives by the application using them.) The "kid" value is a case-sensitive string. Use of this member is OPTIONAL. When used with JWS or JWE, the "kid" value is used to match a JWS or JWE "kid" Header Parameter value.
  String kid;

  /// "key_ops" (Key Operations) Parameter
  ///
  /// The "key_ops" (key operations) parameter identifies the operation(s) for which the key is intended to be used. The "key_ops" parameter is intended for use cases in which public, private, or symmetric keys may be present.
  ///
  // ignore: non_constant_identifier_names
  String key_ops;

  /// Parameters for RSA Public Keys
  /// ==============================
  ///
  /// "n" (Modulus) Parameter
  /// The "n" (modulus) parameter contains the modulus value for the RSA public key. It is represented as a Base64urlUInt-encoded value.
  ///
  String n;

  /// "e" (Exponent) Parameter
  ///
  /// The "e" (exponent) parameter contains the exponent value for the RSA public key. It is represented as a Base64urlUInt-encoded value.
  ///
  String e;

  /// Parameters for RSA Private Keys
  /// ===============================
  ///
  /// [NOTE:] This library doe not make use fo these keys as of the initial version.
  ///
  /// "d" (Private Exponent) Parameter
  /// The "d" (private exponent) parameter contains the private exponent value for the RSA private key. It is represented as a Base64urlUInt- encoded value.
  ///
  String d;

  /// "p" (First Prime Factor) Parameter
  /// The "p" (first prime factor) parameter contains the first prime factor. It is represented as a Base64urlUInt-encoded value.
  ///
  String p;

  /// "q" (Second Prime Factor) Parameter
  ///
  /// The "q" (second prime factor) parameter contains the second prime factor. It is represented as a Base64urlUInt-encoded value.
  ///
  String q;

  /// "dp" (First Factor CRT Exponent) Parameter
  ///
  /// The "dp" (first factor CRT exponent) parameter contains the Chinese Remainder Theorem (CRT) exponent of the first factor. It is represented as a Base64urlUInt-encoded value.
  ///
  String dp;

  ///  "dq" (Second Factor CRT Exponent) Parameter
  ///
  /// The "dq" (second factor CRT exponent) parameter contains the CRT exponent of the second factor. It is represented as a Base64urlUInt- encoded value.
  ///
  String dq;

  /// "qi" (First CRT Coefficient) Parameter
  ///
  /// The "qi" (first CRT coefficient) parameter contains the CRT coefficient of the second factor. It is represented as a Base64urlUInt-encoded value.
  ///
  String qi;

  set kty(String value) {
    if (['EC', 'RSA', 'oct'].contains(value)) {
      _kty = value;
    }
  }

  String get kty {
    return _kty;
  }
}
