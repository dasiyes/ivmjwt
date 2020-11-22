part of '../ivmjwt.dart';

/// Ivmanto JWT
///
/// The Ivmanto`s implementation of JWT
///
class IvmJWT extends JWT {
  // Verify and decode properties
  // JWK key;
  // SegmentHeader header;
  // Map<String, dynamic> payload;
  // String signature;
  // String ivmToken;

  // The constructor
  IvmJWT();

  @override
  void _sign() {
    // TODO: implement sign
  }

  /// Issue RS256 signed JWT
  ///
  /// This function will take as parameter the claims as payload of the
  /// future JWT in either one of formats:
  /// [strClaims] - a string that can be verified to a JSON object
  /// or
  /// [mapClaims] - the dart's representation of a JSON object
  /// If both arguments are null - the function will throw exception
  /// 'Not suficient payload data provided!'.
  /// If both parameters are provided - the strClaims will be used.
  @override
  String issueJWTRS256([String strClaims, Map<String, dynamic> mapClaims]) {
    /// 1. Generate key pair
    ///
    /// 2. Build the dataToSign bytes list from the provided in paramaters
    /// header and payload segments.
    ///
    /// 3. Use function [sign] to sign the segments data with the private key
    /// from step-1.
    ///
    /// 4. Compose the 3 segments of the JWToken as Base64 string separated
    /// with comma (.)
    ///
    return '';
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
    bool validAlg = false;
    bool validJWKS = false;
    bool validSignature = false;
    bool timeValid = false;

    // Step-1 Check the token integrity
    final _integrity = await _checkTokenIntegrity(token);

    // In integrity object the key "valid" is the bool result of the integrity validation.
    if (_integrity['valid'] as bool) {
      try {
        // ... set the Header object to be sent to step-2 checking signature
        vSegHeader = SegmentHeader.fromJson(json.decode(_integrity['header']));
      } catch (e) {
        throw Exception('Error while getting header object values! $e.');
      }

      // A valid header MUST have a key 'alg' and its value MUST NOT be 'none';
      try {
        validAlg = (vSegHeader.alg != 'none' &&
            vSegHeader.alg != '' &&
            vSegHeader.alg != null);
      } catch (e) {
        throw Exception('Invalid verification of mandatory header values! $e.');
      }

      try {
        // ... set the Payload (claims) object to be sent to step-2 checking signature
        vSegPayload =
            SegmentPayload.fromJson(json.decode(_integrity['payload']));
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
          header: _integrity['header'],
          payload: _integrity['payload'],
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

    return (vSegHeader != null &&
        vSegPayload != null &&
        validAlg &&
        validJWKS &&
        validSignature &&
        timeValid);
  } // end of verifyJWTRS256

  /// Decode RS256 signed JWT
  ///
  /// Decoding of the token payload MUST go over validation phase first
  ///
  static Future<Map<String, dynamic>> decodeJWTRS256(
      String token, String jwks) async {
    if (await _verifyJWTRS256(token, jwks)) {
      Map<String, dynamic> decodedPayload;

      /// decode payload
      try {
        // Split the token to segments
        final List<String> tokenSegments = token.split('.');
        final String jwtPayload =
            await Utilities.base64UrlDecode(tokenSegments[1]);
        decodedPayload = json.decode(jwtPayload);
      } catch (e) {
        throw Exception('Error decoding payload segment! $e.');
      }
      // TODO: consider to combine the header segment as part of the payload?
      return decodedPayload ?? {};
    } else {
      return null;
    }
  }
}
