part of '../ivmjwt.dart';

/// Ivmanto JWT
///
/// The Ivmanto`s implementation of JWT
///
class IvmJWT extends JWT {
  IvmJWT();

  JWK key;
  SegmentHeader header;
  Map<String, dynamic> payload;
  String signature;
  String token;

  @override
  void sign() {
    // TODO: implement sign
  }

  @override
  void issueJWTRS256() {
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
  }

  /// Verify JWT RS256 signed token
  ///
  /// This method will verify JWT [token] signed with RS256 algorithm.
  /// [jwks] is expected key set containing the public key that signed the token. The string content should represent a valid json object.
  static Future<Map<String, dynamic>> verifyJWTRS256(
      String token, String jwks) async {
    /// Verification proprties
    SegmentHeader vSegHeader;
    SegmentPayload vSegPayload;
    bool validAlg = false;
    bool validJWKS = false;
    bool validSignature = false;
    bool timeValid = false;

    Map<String, dynamic> result = {"message": "invalid token!"};

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
      // ...
    } else {
      throw Exception('The token claims verification not possible!');
    }

    /// Finally return the token claims
    if (vSegHeader != null &&
        vSegPayload != null &&
        validAlg &&
        validJWKS &&
        validSignature &&
        timeValid) {
      /// The claims value of the token as Dart's JSON representation Map<String,dynamic>>
      result = vSegPayload.toJson();
    }

    return result;
  } // end of verifyJWTRS256
}
