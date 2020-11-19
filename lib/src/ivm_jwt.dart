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
  void issueJWTRS256() {
    // TODO: implement issueJWTRS256
  }

  @override
  void sign() {
    // TODO: implement sign
  }

  /// Verify JWT RS256 signed token
  ///
  /// This method will verify JWT [token] signed with RS256 algorithm.
  /// [jwks] is expected key set containing the public key that signed the token. The string content should represent a valid json object.
  static Future<Map<String, dynamic>> verifyJWTRS256(
      String token, String jwks) async {
    // Verified Segment Header
    SegmentHeader vSegHeader;
    SegmentPayload vSegPayload;
    bool validAlg = false;
    bool validJWKS = false;

    Map<String, dynamic> result = {
      "message": "you have to wait for your token validation! :)"
    };

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
      print('validJWKS: $validJWKS');
    } catch (e) {
      throw Exception('Error validating to json the provided JWKs value! $e.');
    }

    // Signature verification result prep
    bool _signature = false;

    // TODO: JWT-1 Implement signature check ...
    // Step-2 Check the signature
    if (vSegHeader != null && vSegPayload != null && validAlg && validJWKS) {
      // trigger verification step-2 here...
      print(
          "alg: ${vSegHeader.alg} and payload: ${vSegPayload.iss}, email: ${vSegPayload._properties['email']}");

      /// [header] the token header string
      /// [payload] the token payload
      /// [token] the original token value supplied to this function
      /// [alg] the signing algorithm as defined in the token header
      /// [jwks] set of keys to get the public key from it.
      /// [kid] is the key id that will be used to identify the exact JWK from the set.
      ///
      _signature = await _verifyRS256Signature(
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
    // Optionally verify iss for existance.
    print('signature verification: $_signature');
    // ...

    // Supposed to be the decoded JWT
    return result;
  } // end of verifyJWTRS256
}
