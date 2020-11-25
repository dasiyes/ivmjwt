/// JWT library by Ivmanto(c)
///
/// This library provides tools for working with JWT tokens which comply with RFC7519.
/// The first version supports issue and verification of RS256 signed tokens.

library ivmjwt;

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:mirrors';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid_type/uuid_type.dart';
import 'package:ivmjv/ivmjv.dart';

// The JWT
part 'src/jwt/jwt.dart';
part 'src/jwt/segment_header.dart';
part 'src/jwt/segment_payload.dart';
part 'src/jwt/registered_jwt_claims.dart';
// ----

// The JWK
part 'src/jwk/jwk.dart';
part 'src/jwk/ivm_jwk.dart';
part 'src/jwk/jwks.dart';
part 'src/jwk/ivm_jwks.dart';
//----

// The ivmJWT - verify
part 'src/ivm_jwt.dart';
part 'src/verifyJWT/ivm_check_integrity.dart';
part 'src/verifyJWT/ivm_check_signature.dart';
part 'src/verifyJWT/ivm_check_claims.dart';
// ----

// The ivmJWT - issue
part 'src/rsa/ivm_key_pair.dart';
part 'src/rsa/ivm_signer.dart';
part 'src/rsa/ivm_verifier.dart';
// ----

part 'ivmjwt.g.dart';

part 'src/utilities.dart';
