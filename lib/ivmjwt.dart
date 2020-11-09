/// JWT library by Ivmanto(c)
///
/// Initial intention is to use this library to work with JWT tokens
/// that comply with RFC7519. Intended sign in RS256 and its verification
/// for use with Google`s idToken.
library ivmjwt;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';

part 'src/jwt.dart';
part 'src/jwk.dart';
part 'src/ivm_jwt.dart';
part 'src/registered_jwt_claims.dart';
part 'src/utilities.dart';
