part of '../../ivmjwt.dart';

/// Ivmaanto's implementation of JWK
///
/// This implementation is to handle RS256 tokens
///
class IvmRS256JWK extends JWK {
  IvmRS256JWK(String kty,
      {this.alg,
      this.use,
      // ignore: non_constant_identifier_names
      this.key_ops,
      this.kid,
      this.n,
      this.e})
      : super(kty, alg: alg, use: use, key_ops: key_ops, kid: kid, n: n, e: e);

  factory IvmRS256JWK.fromJson(Map<String, dynamic> json) =>
      _IvmRS256JWKFromJson(json);

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
  // ignore: non_constant_identifier_names
  String key_ops;

  @override
  String kid;

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

  /// Extract the public key from JWK json format as RSAPublicKey
  ///
  RSAPublicKey getRSAPublicKey() {
    final _eBytes = base64Url.decode(e);
    final _nBytes = base64Url.decode(n);

    final modulus = Utilities.readBytes(_nBytes);
    final exponent = Utilities.readBytes(_eBytes);

    return RSAPublicKey(modulus, exponent);
  }
}

/// Factory method to load JWK from json object
///
// ignore: non_constant_identifier_names
IvmRS256JWK _IvmRS256JWKFromJson(Map<String, dynamic> json) {
  try {
    final pk = IvmRS256JWK(json['kty'].toString());
    pk.alg = json['alg'] as String;
    pk.use = json['use'] as String;
    pk.kid = json['kid'] as String;
    pk.n = json['n'] as String;
    pk.e = json['e'] as String;
    return pk;
  } catch (e) {
    rethrow;
  }
}
