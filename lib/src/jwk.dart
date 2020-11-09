part of '../ivmjwt.dart';

/// JWK - JSON Web Keys
///
/// This is must follow
class JWK {
  String kid;
  String alg;
  String n;
  String kty;
  String e;
  String use;

  Map<String, dynamic> asMap() {
    return {"kid": kid, "alg": alg, "n": n, "kty": kty, "e": e, "use": use};
  }

  void read(Map<String, dynamic> inputMap,
      {Iterable<String> ignore,
      Iterable<String> reject,
      Iterable<String> require}) {
    kid = inputMap["kid"].toString();
    alg = inputMap["alg"].toString();
    n = inputMap["n"].toString();
    kty = inputMap["kty"].toString();
    e = inputMap["e"].toString();
    use = inputMap["use"].toString();
  }

  void readFromMap(Map<String, dynamic> inputMap) {
    kid = inputMap['kid'].toString();
    alg = inputMap['alg'].toString();
    n = inputMap['n'].toString();
    kty = inputMap['kty'].toString();
    e = inputMap['e'].toString();
    use = inputMap['use'].toString();
  }
}
