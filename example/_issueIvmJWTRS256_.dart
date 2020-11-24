import 'package:ivmjwt/ivmjwt.dart';

Future<void> main() async {
  final ivmjwt = IvmJWT();

  final exp = Utilities.currentTimeInSMS() + 300000;
  final _claims =
      '{\"iss\": \"Ivmanto.com\", \"exp\": $exp, \"ivmanto\": \"dev\"}';

  final result = await ivmjwt.issueJWTRS256(_claims);

  if (result.keys.contains('token')) {
    final token = result['token'].toString();
    final jwks = result['publicKey'].toString();

    print('the token: \n\n$token');
    print("the publicKey: \n\n${result['publicKey']}");

    print('<<<< ========== /* */ ========== >>>>');

    final res = await IvmJWT.decodeJWTRS256(token, jwks);
    print('res: $res');
  } else {
    print(result);
  }
}
