part of '../../ivmjwt.dart';

/// Check the token claims
///
/// The main and only mandatory is the time expiration [exp]
///
Future<bool> _verifyClaims(SegmentPayload claims) async {
  var result = false;
  if (claims.exp == null) {
    return result;
  }

  final exp = claims.exp;
  final nbf = claims.nbf ?? 0;
  final now = Utilities.currentTimeInSMS();

  /// If not_before is active - consider it for time validity
  if (nbf >= 0 && nbf < now + 180) {
    if (exp > now + 180) {
      result = true;
    }
  }

  return result;
}
