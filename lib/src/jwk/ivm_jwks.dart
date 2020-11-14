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

  factory IvmRS256JWKS.fromJson(Map<String, dynamic> json) =>
      _IvmRS256JWKSFromJson(json);

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

IvmRS256JWKS _IvmRS256JWKSFromJson(Map<String, dynamic> json) {
  Exception e = Exception('Invalid structure of the object with keys!');
  List<JWK> listJWKs = [];

  if (json.keys.contains('keys')) {
    if (json['keys'].runtimeType.toString().startsWith('JSArray')) {
      List<Map<String, dynamic>> keys = json['keys'];
      keys.forEach((element) {
        try {
          IvmRS256JWK key = IvmRS256JWK.fromJson(element);
          listJWKs.add(key);
        } catch (e) {
          rethrow;
        }
      });
      final Map<String, List<JWK>> objKeys = {'keys': listJWKs};

      /// Instantiate the JWKS object
      ///
      IvmRS256JWKS jwks = IvmRS256JWKS(objKeys);
      return jwks;
    } else {
      throw e;
    }
  } else {
    throw e;
  }
}
