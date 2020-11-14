part of '../../ivmjwt.dart';

/// Ivmaanto's implementation of JWK
///
/// This implementation is to handle RS256 tokens
///
class IvmRS256JWK implements JWK {
  @override
  void set kty(String value) {
    if (['EC', 'RSA', 'oct'].contains(value)) {
      this._kty = value;
    } else {
      throw Exception('Unacceptable value for the key type!');
    }
  }

  get kty {
    return this._kty;
  }

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
      String this.e = null}) {
    if (['EC', 'RSA', 'oct'].contains(kty)) {
      this._kty = kty;
    } else {
      throw Exception('Unacceptable value for the key type!');
    }
  }
  factory IvmRS256JWK.fromJson(Map<String, dynamic> json) =>
      _IvmRS256JWKFromJson(json);
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
