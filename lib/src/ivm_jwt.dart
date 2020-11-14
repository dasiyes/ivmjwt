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
  /// This method will verify JWT token signed with RS256 algorithm.
  /// If the parameter pubKey is omited, the method would expect kid property to be provided in the token header. In this option the libaray has to be configured properly to acquire the JWK from external API system.
  static Future<Map<String, dynamic>> verifyJWTRS256(String token,
      [String pubKey = null]) async {
    // Verified Segment Header
    SegmentHeader vSegHeader;
    SegmentPayload vSegPayload;
    bool validAlg = false;

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
      ALG_CHECK:
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

    // Signature verification result prep
    bool _signature = false;

    // TODO: JWT-1 Implement signature check ...
    // Step-2 Check the signature
    if (vSegHeader != null && vSegPayload != null && validAlg) {
      // trigger verification step-2 here...
      print(
          "alg: ${vSegHeader.alg} and payload: ${vSegPayload.iss}, email: ${vSegPayload._properties['email']}");

      // Send either kid or pubKey value to signature verification.
      // If pubKey is provided (prefered) it wil be used. Alternativelly kid will be sent.
      if (pubKey != null) {
        _signature = await _verifyRS256Signature(
            header: _integrity['header'],
            payload: _integrity['payload'],
            token: token,
            alg: vSegHeader.alg,
            pubKey: pubKey);
      } else if (pubKey == null && vSegHeader.kid != null) {
        _signature = await _verifyRS256Signature(
            header: _integrity['header'],
            payload: _integrity['payload'],
            token: token,
            alg: vSegHeader.alg,
            kid: vSegHeader.kid);
      } else {
        throw Exception(
            'Insuficient data provided for the token signature verification!');
      }
    } else {
      throw Exception('The token signature verification not possible!');
    }

    // Step-3 here ...
    print('signature verification: $_signature');
    // ...

    // Supposed to be the decoded JWT
    return result;
  } // end of verifyJWTRS256
}
