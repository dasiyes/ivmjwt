part of '../ivmjwt.dart';

/// Ivmanto JWT
///
/// The Ivmanto`s JWT class with issue and verify methods for RS256 signed tokens
///
class IvmJWT extends JWT {
  // The constructor
  IvmJWT();

  /// Issue RS256 signed JWT [RFC7519]
  ///
  /// This function takes at least one of the two optional parameters:
  /// [strClaims] - a string as a valid representation of a JSON object.
  /// or
  /// [mapClaims] - the dart's declaration of a JSON object.
  ///
  /// If both arguments are null - the function will throw exception
  /// 'Not sufficient payload data provided!'.
  //
  /// If both parameters are available, the function will use [strClaims]
  /// as a prefered option.
  ///
  /// The function will auto-generate the key-pair and return it alongside
  /// with the new issued JWToken. Later on, you can use it to acquire the
  /// private and the public keys used for the signing and verification of
  /// the token.
  ///
  @override
  Future<Map<String, dynamic>> issueJWTRS256(
      [String strClaims, Map<String, dynamic> mapClaims]) async {
    SegmentPayload _claims;
    // Throw exception when there is no suficient claims data
    if ((strClaims == null && mapClaims == null) ||
        (strClaims.isEmpty && mapClaims.isEmpty) ||
        (strClaims.isEmpty && mapClaims == null) ||
        (strClaims == null && mapClaims.isEmpty)) {
      throw Exception('Insuficient payload!');
    }

    // If both parameters are provided - use the string claims
    if ((strClaims != null && mapClaims != null) ||
        (strClaims != null && mapClaims == null)) {
      // cases to use [strClaims] param
      final jv = JsonValidator(strClaims);
      if (jv.validate()) {
        final claimsJ = json.decode(strClaims) as Map<String, dynamic>;
        _claims = SegmentPayload.fromJson(claimsJ);
      } else {
        throw Exception('Invalid json format of the claim');
      }
    } else if (mapClaims != null && mapClaims.isNotEmpty) {
      try {
        _claims = SegmentPayload.fromJson(mapClaims);
      } catch (e) {
        throw Exception(
            'Error raised while encoding the parameter mapClaims to json string! $e.');
      }
    }

    /// 1. Generate key pair
    ///
    IvmKeyPair ivmkp;
    try {
      ivmkp = IvmKeyPair(ivmBitStrength: 2048);
      ivmkp.generateAPair();
    } catch (e) {
      throw Exception('Error raised while generating key pair! $e.');
    }

    final prvKey = ivmkp.privateKey;
    final kid = ivmkp.kid;

    // Get the public key as JWK
    final kpPublicKey = ivmkp.getPublicKeyAsJWK();
    print('jwk public key: $kpPublicKey');

    // Get the public key as element of JWKS
    final jwks = {'keys': [].add(kpPublicKey)};
    print('jwks with single JWK: $jwks');

    /// 2. Build the dataToSign bytes list from the provided in paramaters
    /// header and payload segments.
    ///
    final _header =
        '{\"alg\": \"RS256\", \"typ\": \"JWT\", \"kid\": \"${kid.toString()}\"}';

    final _claimsStr = _claims.toJson().toString();
    final dataToSign = Uint8List.fromList('${_header}.${_claimsStr}'.codeUnits);

    /// 3. Use function [sign] to sign the segments data with the private key
    /// from step-1.
    ///
    try {
      final sign = IvmSignerRSA256(prvKey, dataToSign);

      /// 4. Compose the 3 segments of the JWToken as Base64 string separated
      /// with comma (.)
      ///
      final segment1 = await Utilities.base64UrlEncode(_header);
      final segment2 = await Utilities.base64UrlEncode(_claimsStr);
      final segment3 = sign.getBase64Signature();

      // Returning the token and the publicKey as JWKS
      return {
        'token': '${segment1}.${segment2}.${segment3}',
        'publicKey': '$jwks'
      };
      // <<<<

    } catch (e) {
      print(e);
      throw Exception(
          'Error has raised while preparing and signing the token! $e.');
    }
  }

  /// Verify JWT RS256 signed token
  ///
  /// This method will verify JWT [token] signed with RS256 algorithm.
  /// [jwks] is expected key set containing the public key that signed the token. The string content should represent a valid json object.
  ///
  static Future<bool> _verifyJWTRS256(String token, String jwks) async {
    /// Verification proprties
    SegmentHeader vSegHeader;
    SegmentPayload vSegPayload;
    var validAlg = false;
    var validJWKS = false;
    var validSignature = false;
    var timeValid = false;

    // Step-1 Check the token integrity
    final _integrity = await _checkTokenIntegrity(token);

    // In integrity object the key "valid" is the bool result of the integrity validation.
    if (_integrity['valid'] as bool) {
      try {
        // ... set the Header object to be sent to step-2 checking signature
        final headerJson = json.decode(_integrity['header'].toString())
            as Map<String, dynamic>;
        vSegHeader = SegmentHeader.fromJson(headerJson);
      } catch (e) {
        throw Exception('Error while getting header object values! $e.');
      }

      // A valid header MUST have a key 'alg' and its value MUST NOT be 'none';
      try {
        validAlg = vSegHeader.alg != 'none' &&
            vSegHeader.alg != '' &&
            vSegHeader.alg != null;
      } catch (e) {
        throw Exception('Invalid verification of mandatory header values! $e.');
      }

      try {
        // ... set the Payload (claims) object to be sent to step-2 checking signature
        final payloadJson = json.decode(_integrity['payload'].toString())
            as Map<String, dynamic>;
        vSegPayload = SegmentPayload.fromJson(payloadJson);
      } catch (e) {
        throw Exception(
            'Invalid verification of mandatory payload values! $e.');
      }
      // Throw exception if the token's integrity validation resolved (very unlikely) to False.
    } else {
      throw Exception('Token integrity validation has failed!');
    }

    /// For signature verification the [jwks] is required.
    /// It must run over json validation first.
    //
    // Verify if the jwks is a valid JSON
    try {
      final jv = JsonValidator(jwks);
      validJWKS = jv.validate();
    } catch (e) {
      throw Exception('Error validating to json the provided JWKs value! $e.');
    }

    // Step-2 Check the signature
    if (vSegHeader != null && vSegPayload != null && validAlg && validJWKS) {
      /// [header] the token header string
      /// [payload] the token payload
      /// [token] the original token value supplied to this function
      /// [alg] the signing algorithm as defined in the token header
      /// [jwks] set of keys to get the public key from it.
      /// [kid] is the key id that will be used to identify the exact JWK from the set.
      ///
      validSignature = await _verifyRS256Signature(
          header: _integrity['header'].toString(),
          payload: _integrity['payload'].toString(),
          token: token,
          alg: vSegHeader.alg,
          jwks: jwks,
          kid: vSegHeader.kid);
    } else {
      throw Exception('The token signature verification not possible!');
    }

    // Step-3: Verify the token time validity: exp and if exist iat & nbf
    if (vSegHeader != null &&
        vSegPayload != null &&
        validAlg &&
        validJWKS &&
        validSignature) {
      // Verifies the exp part of the token payload segment with now().
      // 180 seconds will be added to now() value as further processing time
      // to ensure the token validity in the next 3 minutes
      timeValid = await _verifyClaims(vSegPayload);
    } else {
      throw Exception('The token claims verification not possible!');
    }

    print(
        '_verifyJWTRS256 result: ${vSegHeader != null && vSegPayload != null && validAlg && validJWKS && validSignature && timeValid}');
    return vSegHeader != null &&
        vSegPayload != null &&
        validAlg &&
        validJWKS &&
        validSignature &&
        timeValid;
  } // end of verifyJWTRS256

  /// Decode the provided [token] using the [jwks] set.
  ///
  static Future<Map<String, dynamic>> decodeJWTRS256(
      String token, String jwks) async {
    if (await _verifyJWTRS256(token, jwks)) {
      Map<String, dynamic> decodedPayload;

      /// decode payload
      try {
        // Split the token to segments
        final tokenSegments = token.split('.');
        final jwtPayload = await Utilities.base64UrlDecode(tokenSegments[1]);
        decodedPayload = json.decode(jwtPayload) as Map<String, dynamic>;
      } catch (e) {
        throw Exception('Error decoding payload segment! $e.');
      }
      // TODO: consider to combine the header segment as part of the payload?
      return decodedPayload ?? {};
    } else {
      return null;
    }
  }

  /// Create a new JWT token and sign it with the provided private key
  ///
  @override
  Future<String> signJWTRS256(RSAPrivateKey privateKey,
      [String strClaims, Map<String, dynamic> mapClaims]) {
    // TODO: [JWT-11] implement sign JWT with provided private key
    throw UnimplementedError();
  }
}
