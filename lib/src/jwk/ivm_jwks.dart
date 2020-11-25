part of '../../ivmjwt.dart';

/// Ivmanto's implementation of JWKS
///
/// The set of JWKs will be provided to the verification function
/// of RS256 signed tokens
///
class IvmRS256JWKS extends JWKS {
  IvmRS256JWKS(this._jwks) : super(_jwks);

  factory IvmRS256JWKS.fromJson(Map<String, dynamic> json) =>
      _IvmRS256JWKSFromJson(json);

  @override
  Map<String, List> _jwks;

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

  @override
  IvmRS256JWK getKeyByIndex(int index) {
    return _jwks['keys'][index] as IvmRS256JWK;
  }

  @override
  IvmRS256JWK getKeyByKid(String kid) {
    final keysArray = _jwks['keys'] as List<IvmRS256JWK>;
    for (var key in keysArray) {
      if (key.kid == kid) {
        return key;
      }
    }
    return null;
  }
}

// ignore: non_constant_identifier_names
IvmRS256JWKS _IvmRS256JWKSFromJson(Map<String, dynamic> json) {
  /// [e] general excption to throw from this method
  final e = Exception('Invalid structure of the object with keys!');

  final listJWKs = <IvmRS256JWK>[];

  if (json.keys.contains('keys')) {
    if (json['keys'].runtimeType.toString().startsWith('List')) {
      final keys = json['keys'] as List;

      for (var element in keys) {
        try {
          final key = IvmRS256JWK.fromJson(element as Map<String, dynamic>);
          listJWKs.add(key);
        } catch (e) {
          rethrow;
        }
      }

      /// Building the json object with the keys
      final objKeys = <String, List<IvmRS256JWK>>{'keys': listJWKs};

      /// Instantiate the JWKS object
      ///
      final jwks = IvmRS256JWKS(objKeys);
      return jwks;
    } else {
      throw e;
    }
  } else {
    throw e;
  }
}
