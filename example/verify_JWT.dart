import 'package:ivmjwt/ivmjwt.dart';

/// Verify JWT RS256 signed
///
void main() async {
  const token = 'token_value';
  const jwks = '{"keys": []}';

  /// Expect bool if the token is valid or not
  final result = await IvmJWT.decodeJWTRS256(token, jwks);
  print(result);
}
