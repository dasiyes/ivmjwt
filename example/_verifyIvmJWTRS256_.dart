import 'package:ivmjwt/ivmjwt.dart';

void main() {
  String token =
      "eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCIsICJraWQiOiAiNmJlMjg5ZGYtMmRiMy0xMWViLThmZGMtZTllMzU5ZTg5ZDM2In0=.eyJpc3MiOiAiSXZtYW50by5jb20ifQ==.SBs2CKrI7Eezg0YJSM0Tc88LsvQCgQYClMBEeIHhrgxlUaTCiZlL6VM5JS0_DhQYWCm6BfYt5FWCrmiqGE6NCZlzQjqoaC50N6vRlZqyl7QhEQPHqPPByDLTnx39Nl-PAJ6HsMHkLHVYFyWliYuipVvqD778-J_cOSt4wp4RItXEvKzn1LIJd26oJCSh3zR1slswnUOMGTAGoB68KNh4-POzIn_w3pvbVsNzp5oz_qfrDaysYC56LqnBTKYJasLP6qmrm3UJbo8CDTVE2atHsTfM-MxLB1Nt0NKtrw9_Um95WwvCmX6jytYIl9Jedb1AO6rG-oyzefN9JPgtucmNnw==";

  String jwks =
      "{\"keys\":[{\"alg\":\"RS256\",\"use\":\"sig\",\"n\":\"6VUDbUZRLLIGeLDMf1PuAWReUedoVfQOC-07qsqlPkR0eycEaW3GWtBclLcXiTMkARcqUu38joFQVwcfa2Ik2lTE0p-OibwlQddZJo05wwZIMHwqYy94LPkfi3bl3s2OJCzPKbIJq4lz0551pnNBdwNYDlQOCgV0o5VErfxaFbKwpvsaDq_KH7hE-JjdbBgluIlqN63cOTpz5dzvNixEqxrUK2AlHeHfHH7l9B0UwYi-EnIUC5gYaWUB5wghnVY6wMcNRZQYqxot4ZP71qrf2dyFscXEvRykpmqsaolhsAVJKWIf5c60uB4cIV9ZE-6DaXMKss-pJGpUbx-2lbrogA==\",\"kid\":\"6be289df-2db3-11eb-8fdc-e9e359e89d36\",\"kty\":\"RSA\",\"e\":\"AQAB\"}]}";

  var res = IvmJWT.decodeJWTRS256(token, jwks);

  print(res);
}
