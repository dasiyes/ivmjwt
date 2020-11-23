import 'package:ivmjwt/ivmjwt.dart';

Future<void> main() async {
  IvmJWT ivmjwt = IvmJWT();

  var exp = Utilities.currentTimeInSMS() + 300000;
  String _claims = "{\"iss\": \"Ivmanto.com\", \"exp\": $exp}";

  String token = await ivmjwt.issueJWTRS256(_claims);
  print('the token: \n\n$token');
}
