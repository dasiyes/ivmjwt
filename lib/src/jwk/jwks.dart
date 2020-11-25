part of '../../ivmjwt.dart';

/// JWK Set [RFC7517-5]
///
/// A JWK Set is a JSON object that represents a set of JWKs. The JSON object MUST have a "keys" member, with its value being an array of JWKs. This JSON object MAY contain whitespace and/or line breaks.
///
/// The member names within a JWK Set MUST be unique; JWK Set parsers MUST either reject JWK Sets with duplicate member names or use a JSON parser that returns only the lexically last duplicate member name, as specified in Section 15.12 ("The JSON Object") of ECMAScript 5.1 [ECMAScript].
///
/// Additional members can be present in the JWK Set; if not understood by implementations encountering them, they MUST be ignored. Parameters for representing additional properties of JWK Sets should either be registered in the IANA "JSON Web Key Set Parameters" registry established by Section 8.4 or be a value that contains a Collision-Resistant Name.
///
/// Implementations SHOULD ignore JWKs within a JWK Set that use "kty" (key type) values that are not understood by them, that are missing required members, or for which values are out of the supported ranges.
abstract class JWKS implements JWK {
  JWKS(Map<String, List> jwks) {
    final e = Exception('Invalid structure of the object with keys!');
    if (!_jwks.keys.contains('keys')) {
      throw e;
    } else {
      if (!_jwks['keys'].runtimeType.toString().startsWith('List')) {
        throw e;
      }
    }
    _jwks = jwks;
  }

  /// "keys" Parameter
  ///
  /// The value of the "keys" parameter is an array of JWK values. By default, the order of the JWK values within the array does not imply an order of preference among them, although applications of JWK Sets can choose to assign a meaning to the order for their purposes, if desired.
  Map<String, List> _jwks;

  /// Set the object value
  ///
  set keys(Map<String, List> value) {
    if (!_jwks.keys.contains('keys')) {
      throw e;
    } else {
      if (!_jwks.keys.runtimeType.toString().startsWith('List')) {
        throw e;
      } else {
        _jwks = value;
      }
    }
  }

  /// Get the entire object as a map
  ///
  Map<String, List> get keys {
    return _jwks;
  }

  /// Get the List of JWKs
  ///
  Iterable<String> getKeysAsList() {
    return _jwks.keys;
  }

  /// Get a single JWKey by its index from the set
  ///
  JWK getKeyByIndex(int index);

  /// Get a JWKey by its property kid (key ID)
  ///
  JWK getKeyByKid(String kid);
}
