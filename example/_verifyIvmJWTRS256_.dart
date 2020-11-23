import 'package:ivmjwt/ivmjwt.dart';

void main() async {
  String token =
      "eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCIsICJraWQiOiAiM2Q1YmI4NjktMmRkOS0xMWViLTgzZTEtOWQ4ZjcwOGYxMjFiIn0=.eyJpc3MiOiAiSXZtYW50by5jb20iLCAiZXhwIjogMTYwNjQ2OTY2Mn0=.f0tMzH1AZK6aAXJGsJyQknGRY_jxoFg83A-ardTe896WppEgTqIeG4pT06m3ywRw6Gub_6uypS94PstvCvUokNLeRS1C5Tx-mscwKjKtEVjnwdgLWV00mgWGUrdyMvWXvwYblPcfSLEVvPPAomEjG5BVVSlBEfBd4nuMwRQBvxYPrGe5lScN45Ai1_z48IP2pXVnXyoKvKxz0l2ranUfKQrCpf4nJttih02hp30jJ_WD8ja8hWkcUPbxMXFOpw7aP78hQZFD5L27YbWpYjZCWQc8SVYBJN_8ECvQ5yjOiTLDNRpbSlz4iUFS8JiO3LGTdrRjqSQxYI0FoyfC30BdoQ==";

  String jwks =
      "{\"keys\":[{\"alg\":\"RS256\",\"use\":\"sig\",\"n\":\"BaunotoPYsGs5Ez8aEfU4VjVQbDONG05B3aB2wH24ExbRM4D40AujAwC-GhADbtB9wdzTQTNG1ZWgPWIPTKf-bwaOG__55-DTVXa08B_4A6BtyiGnmgRG5T1ThXA453bz9Tmp_6-_2gjcNGYwKgV6xwO1i69nWismWecwSY2ynTStfBi6ZHHubpILJQwIvxO6ITkIR1WjsUUA0FMlO6NpBmKbYjZ-q9XUl4e0ibnT_vLlVMv0jkUqRNh89wNWXPqs6DM4qq-XQbjIxRpmxEtW4jCq9lUBEzwmXx3Cd5CvghfNxMxGfkpt6p2_dxLEbI8XxyZ8IO29zwe-OuF9EMxpA==\",\"kid\":\"3d5bb869-2dd9-11eb-83e1-9d8f708f121b\",\"kty\":\"RSA\",\"e\":\"AQAB\"}]}";

  var res = await IvmJWT.decodeJWTRS256(token, jwks);

  print('res: $res');
}
