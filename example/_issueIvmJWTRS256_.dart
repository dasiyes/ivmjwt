import 'package:ivmjwt/ivmjwt.dart';

Future<void> main() async {
  IvmJWT ivmjwt = IvmJWT();

  String _claims = "{\"iss\": \"Ivmanto.com\"}";

  String token = await ivmjwt.issueJWTRS256(_claims);
  print('the token: \n\n$token');
}
