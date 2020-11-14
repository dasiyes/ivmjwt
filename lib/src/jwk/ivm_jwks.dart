part of '../../ivmjwt.dart';

/// Ivmanto's implementation of JWKS
///
/// The set of JWKs will be provided to the verification function
/// of RS256 signed tokens
///
class IvmRS256JWKS extends JWKS {
  @override
  Map<String, List<JWK>> _jwks;

  @override
  String _kty;

  @override
  String alg;

  @override
  String d;

  @override
  String dp;

  @override
  String dq;

  @override
  String e;

  @override
  String key_ops;

  @override
  String kid;

  @override
  String kty;

  @override
  String n;

  @override
  String p;

  @override
  String q;

  @override
  String qi;

  @override
  String use;

  IvmRS256JWKS(Map<String, List<JWK>> keySet) : super(keySet);

  @override
  JWK getKeyByIndex(int index) {
    // TODO: implement getKeyByIndex
    throw UnimplementedError();
  }

  @override
  JWK getKeyByKid(String kid) {
    // TODO: implement getKeyByKid
    throw UnimplementedError();
  }
}
