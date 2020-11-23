part of '../../ivmjwt.dart';

/// Ivmaanto's implementation of JWK
///
/// This implementation is to handle RS256 tokens
///
class IvmRS256JWK extends JWK {
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
  String n;

  @override
  String p;

  @override
  String q;

  @override
  String qi;

  @override
  String use;

  IvmRS256JWK(String kty,
      {String this.alg = null,
      String this.use = null,
      String this.key_ops = null,
      String this.kid = null,
      String this.n = null,
      String this.e = null})
      : super(kty, alg: alg, use: use, key_ops: key_ops, kid: kid, n: n, e: e);

  factory IvmRS256JWK.fromJson(Map<String, dynamic> json) =>
      _IvmRS256JWKFromJson(json);

  /// Extract the public key from JWK json format as RSAPublicKey
  ///
  RSAPublicKey getRSAPublicKey() {
    Uint8List _eBytes = base64Url.decode(base64Url.normalize(this.e));
    Uint8List _nBytes = base64Url.decode(base64Url.normalize(this.n));

    final BigInt modulus = Utilities.readBytes(_nBytes);
    final BigInt exponent = Utilities.readBytes(_eBytes);

    return RSAPublicKey(modulus, exponent);
  }
}

/// Factory method to load JWK from json object
///
IvmRS256JWK _IvmRS256JWKFromJson(Map<String, dynamic> json) {
  try {
    IvmRS256JWK pk = IvmRS256JWK(json['kty']);
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
