part of '../ivmjwt.dart';

/**
 * Creating a JWT by [RFC7519 section 7.1]
   To create a JWT, the following steps are performed.  The order of the
   steps is not significant in cases where there are no dependencies
   between the inputs and outputs of the steps.
   1.  Create a JWT Claims Set containing the desired claims.  Note that
      * whitespace is explicitly allowed in the representation and no
      * canonicalization need be performed before encoding.
   2.  Let the Message be the octets of the UTF-8 representation of the
      *  JWT Claims Set.
   3.  Create a JOSE Header containing the desired set of Header
      * Parameters.  The JWT MUST conform to either the [JWS] or [JWE]
      *  specification.  Note that whitespace is explicitly allowed in the
      *  representation and no canonicalization need be performed before
      *  encoding.
   4.  Depending upon whether the JWT is a JWS or JWE, there are two
       * cases:
       *  If the JWT is a JWS, create a JWS using the Message as the JWS
       *   Payload; all steps specified in [JWS] for creating a JWS MUST
       *   be followed.
       *  Else, if the JWT is a JWE, create a JWE using the Message as
       *   the plaintext for the JWE; all steps specified in [JWE] for
       *   creating a JWE MUST be followed.
   5.  If a nested signing or encryption operation will be performed,
       * let the Message be the JWS or JWE, and return to Step 3, using a
       * "cty" (content type) value of "JWT" in the new JOSE Header
       * created in that step.
   6.  Otherwise, let the resulting JWT be the JWS or JWE.
 */

/// Ivmanto JWT
///
/// The Ivmanto`s JWT class with issue and verify methods for RS256 signed tokens
///
class IvmJWT extends JWT {
  // Instantiate the object IvmJWT by providing the payload (claims) at
  // the time of creation. This require an object SegmentPayload object
  // to be created before hand.
  IvmJWT(this._claimsSet) : super(_claimsSet);

  final SegmentPayload _claimsSet;

  /// Issue RS256 signed JWT [RFC7519]:
  ///
  /// follow the steps from [RFC7519 section 7.1] - referenced above in
  /// this class
  @override
  Future<Map<String, dynamic>> issueJWTRS256() async {
    // The token claims check - this._claimsSet
    // TODO: [dev] verify the steps 1 to 6 from the plan above are in place.

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
    final kpPublicKey = json.encode(ivmkp.getPublicKeyAsJWK());

    // Get the public key as element of JWKS
    // final arrayPK = <Map<String, dynamic>>[kpPublicKey];
    final jwks = '{\"keys\": [${kpPublicKey}]}';

    /// 2. Build the dataToSign bytes list from the provided in paramaters
    /// header and payload segments.
    ///
    final _header =
        '{\"alg\": \"RS256\", \"typ\": \"JWT\", \"kid\": \"${kid.toString()}\"}';

    final _claimsStr = json.encode(_claimsSet.toJson());
    final dataToSign = Uint8List.fromList('${_header}.${_claimsStr}'.codeUnits);

    /// 3. Use function [sign] to sign the segments data with the private key
    /// from step-1.
    ///
    try {
      final sign = IvmSignerRSA256(prvKey, dataToSign);

      /// 4. Compose the 3 segments of the JWToken as Base64 string separated
      /// with comma (.)
      ///
      final segment1 = base64Url.encode(_header.codeUnits);
      final segment2 = base64Url.encode(_claimsStr.codeUnits);
      final segment3 = sign.getBase64Signature();

      // Returning the token and the publicKey as JWKS
      return {
        'token': '${segment1}.${segment2}.${segment3}',
        'publicKey': '$jwks'
      };
      // <<<<

    } catch (e) {
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

    // validate params
    if (token.isEmpty) {
      print('[_verifyJWTRS256]: WARNING Unable to verify an empty token!');
      return false;
    }
    if (jwks.isEmpty) {
      print(
          '[_verifyJWTRS256]: WARNING Unable to verify the token with empty keys set!');
      return false;
    }
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
      final jv = JsonValidator();
      if (jv == null || jwks.isEmpty) {
        print('[_verifyJWTRS256] WARNING Invalid JSON validator!');
      }
      validJWKS = await jv.validate(jwks);
    } catch (e) {
      throw Exception('Error validating the provided JWKs value to json! $e.');
    }

    // Step-2 Check the signature

    if (vSegHeader.toJson().toString() != null &&
        vSegPayload.toJson().toString() != null &&
        validAlg &&
        validJWKS) {
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
    // temp: validSignature temporary removed
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
