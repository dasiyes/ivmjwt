import 'package:ivmjwt/ivmjwt.dart';

/// Verify a given JWT signed with RS256 key
///
Future main() async {
  // ...
  // A sample JWT - Google`s idTkoken (RS256)
  String idt =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6ImYwOTJiNjEyZTliNjQ0N2RlYjEwNjg1YmI4ZmZhOGFlNjJmNmFhOTEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjc0MDM0NTIwNzMxLXN2bmZ2aGE3c2JwOTcxdWJnMG1ja2FtYWFjMDdqaGMyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjc0MDM0NTIwNzMxLXN2bmZ2aGE3c2JwOTcxdWJnMG1ja2FtYWFjMDdqaGMyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTExMzc4NTczOTE3NjI3ODU0MDU1IiwiZW1haWwiOiJuaWtvbGF5LnRvbmV2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiVFlleWR1QUlTM3Qya2dZT0p5MmNuQSIsIm5hbWUiOiJOaWtvbGF5IFRvbmV2IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdqMDdBbEdJdFIzYjRRLWhQRGxVUThwbF9GZXk1VWVNSEdrREtMVkVBPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ik5pa29sYXkiLCJmYW1pbHlfbmFtZSI6IlRvbmV2IiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2MDQ4NjY2NDcsImV4cCI6MTYwNDg3MDI0NywianRpIjoiMjMwMGJmODQ2NTlmMTFmMjY1MGE0YjNmMzdmMWUxNDhlN2Y1MjcyOSJ9.v89V0C7jRxJU0fNS5I2ExV3qk5ki8LNrIVKlRkkz00m19qpwp_qeR2HaPZZrz2Mtv4VBWUzzbKibzieun17H4u9O7DbN0Em2C3th6KD4-BE0JNFHC9CDsBN7Hu336njZ7WkafeOTpS_AJEO07diC39aJxA7StH6UrrCPcam02OmWv_G0lCGZhTkPMiieywQHQ2ELdMQEqcaFCfCCkcargJosSRwAJKx9BTnl2eI5nhXtxuarLXuEvAX1LNkTjYgXAbuOOCUfOzOzgFiP2ITXyk2GrMl35NQefgdoBg3Utoae24c4xFFHUGMYMJ00P7S-gtU25-YiDEwVHhoxGhmURg";

  // String idt =
  //    'eyJhbGciOiJSUzI1NiIsImtpZCI6ImYwOTJiNjEyZTliNjQ0N2RlYjEwNjg1YmI4ZmZhOGFlNjJmNmFhOTEiLCJ0eXAiOiJKV1QifQ.x.hjkg';

  // The JWKS as example from Google SignIn
  String jwks =
      "{\"keys\":[{\"e\":\"AQAB\",\"n\":\"4_Ipw_yzV3OB1fS4ngnnH2cRDy7dZTBP8TEaqJiILHve3P2Z6NSgTr9dbLCUXjO-pwt6t_dMs2oVPDfpM8I-10g9cO-gcPA5QTzTKcHoned0B9p8jzEEvSDBlej1qH0-SgJMooQrbJXHjatF4TiAOTCFT-yRwPbcar0QYhvUWNV52xjEvj4yDnmK42y819LY7Hy-Gkzky4iV9mjf6qEFmlxTjSdqxuQo0Y68YHJZLGSx3rQmNzYt0XY8So3aGKXz_v4mMHkZl62mQGx5U_80LmB-3j6WjIJXilJmj1pbMU6Cp6sWjA9pTgAxF5LDzxplXpjQas33vsJ5n1xsmGxpow\",\"alg\":\"RS256\",\"kty\":\"RSA\",\"use\":\"sig\",\"kid\":\"f092b612e9b6447deb10685bb8ffa8ae62f6aa91\"},{\"alg\":\"RS256\",\"use\":\"sig\",\"n\":\"vjjZdBjWDVibe5f02VSd3U8gqGzjnGL7ZTMUZMxzeYMH14sTm99eGJoFFuP6b0ti-VHTbdUc88jNe9KY7cfoihvTS7ZIjzwyGUq2ThV5fsWo0gYZwnKbLz0QyAXIi7U89zDEud8K8GIq4mK1Q1kcXFsjN9pa59qMthjVHMUBJGQRqH22mzxc0JhkBMs4ElG1UHMyCnDcTAFHw30c7iE6uTXBATtNIkLzUy1X5hLnKW00JqD-L20bsXOAP-_7yGkpSEvvaxroeBm58JHUNhvWklvsK4S-Dh8Lm917apNSCWumfDQ6plBJrhRI3tQl9k06ZfayRf-46y7DarZP7FJOqQ\",\"kid\":\"d946b137737b973738e5286c208b66e7a39ee7c1\",\"kty\":\"RSA\",\"e\":\"AQAB\"}]}";
  try {
    final res = await IvmJWT.decodeJWTRS256(idt, jwks);
    print(res);
  } catch (e) {
    print(e);
  }
}
