import 'package:ivmjwt/ivmjwt.dart';

Future<void> main() async {
  IvmJWT ivmjwt = IvmJWT();

  String _claims = "{\"iss\": \"Ivmanto.com\"}";

  String token = await ivmjwt.issueJWTRS256(_claims);
  print(token);
  String jwks =
      "{\"alg\":\"RS256\",\"use\":\"sig\",\"n\":\"vjjZdBjWDVibe5f02VSd3U8gqGzjnGL7ZTMUZMxzeYMH14sTm99eGJoFFuP6b0ti-VHTbdUc88jNe9KY7cfoihvTS7ZIjzwyGUq2ThV5fsWo0gYZwnKbLz0QyAXIi7U89zDEud8K8GIq4mK1Q1kcXFsjN9pa59qMthjVHMUBJGQRqH22mzxc0JhkBMs4ElG1UHMyCnDcTAFHw30c7iE6uTXBATtNIkLzUy1X5hLnKW00JqD-L20bsXOAP-_7yGkpSEvvaxroeBm58JHUNhvWklvsK4S-Dh8Lm917apNSCWumfDQ6plBJrhRI3tQl9k06ZfayRf-46y7DarZP7FJOqQ\",\"kid\":\"d946b137737b973738e5286c208b66e7a39ee7c1\",\"kty\":\"RSA\",\"e\":\"AQAB\"}";

  var res = IvmJWT.decodeJWTRS256(token, jwks);
}
