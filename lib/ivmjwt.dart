/// JWT library by Ivmanto(c)
///
/// Initial intention is to use this library to work with JWT tokens
/// that comply with RFC7519. Intended sign in RS256 and its verification
/// for use with Google`s idToken.
library ivmjwt;

import 'dart:convert';
import 'dart:mirrors';
import 'dart:typed_data';

// import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

// The JWT
part 'src/jwt/jwt.dart';
part 'src/jwt/segment_header.dart';
part 'src/jwt/segment_payload.dart';
part 'src/jwt/registered_jwt_claims.dart';
// ----

// The JWK
part 'src/jwk/jwk.dart';
part 'src/jwk/ivm_jwk.dart';
//---

// The ivmJWT
part 'src/ivm_jwt.dart';
part 'src/verifyJWT/ivm_check_integrity.dart';
part 'src/verifyJWT/ivm_check_signature.dart';
// ----

part 'ivmjwt.g.dart';

part 'src/utilities.dart';
