import 'package:ivmjwt/ivmjwt.dart';

Future<void> main() async {
  final ivmjwt = IvmJWT();

  final exp = Utilities.currentTimeInSMS() + 300000;
  final _claims = '{\"iss\": \"Ivmanto.com\", \"exp\": $exp}';

  final result = await ivmjwt.issueJWTRS256(_claims);

  if (result.keys.contains('token')) {
    final token = result['token'].toString();
    print('the token: \n\n$token');
    print("the publicKey: \n\n$result['publicKey']");
  } else {
    print(result);
  }
}
