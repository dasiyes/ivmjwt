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
  static Future<Map<String, dynamic>> verifyJWTRS256(String token) async {
    // Verified Segment Header
    SegmentHeader vSegHeader;
    SegmentPayload vSegPayload;

    Map<String, dynamic> result = {
      "message": "you have to wait for your token validation! :)"
    };

    // Step-1 Check the token integrity
    final _integrity = await _checkTokenIntegrity(token);

    // Once verified ...
    if (_integrity['valid'] as bool) {
      // ... set the Header values to be sent to step-2 checking signature
      vSegHeader = SegmentHeader.fromJson(json.decode(_integrity['header']));

      // ... set the Payload (claims)
      vSegPayload = SegmentPayload.fromJson(json.decode(_integrity['payload']));
      // String payload = _integrity['payload'].toString();

      print(
          "alg: ${vSegHeader.alg} and payload: ${vSegPayload.iss}, email: ${vSegPayload._properties['email']}");
    }
    // Step-2 Check the signature

    // Supposed to be the decoded JWT
    return result;
  } // end of verifyJWTRS256
}
