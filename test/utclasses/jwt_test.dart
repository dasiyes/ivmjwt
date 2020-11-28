import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:test/test.dart';
import 'dart:convert';

/// Unit testing the JWT object
void initJWT() {
  // TODO: [dev] implement JWT test suite
  /// T1:
  /// Check the segment header init
  ///
  final segHeader =
      SegmentHeader(alg: 'RS256', typ: 'JWT', cty: 'sig', kid: 'IVM512');
  expect(segHeader, isA<SegmentHeader>());
  expect(segHeader, isNotNull);
  expect(segHeader.kid, 'IVM512');

  final jsonHeader = json.decode(
          '{"alg": "RS256", "typ": "JWT", "cty": "JWS", "kid": "IVM512"}')
      as Map<String, dynamic>;
  final segHeader2 = SegmentHeader.fromJson(jsonHeader);
  expect(segHeader2, isA<SegmentHeader>());
  expect(segHeader2, isNotNull);
  expect(segHeader2.cty, 'JWS');

  /// T2:
  /// Check the segment payload init
  ///
}

void verifyGID() async {
  /// T1:
  /// Verify GID
  ///
  const token =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjJlMzAyNWYyNmI1OTVmOTZlYWM5MDdjYzJiOTQ3MTQyMmJjYWViOTMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJhY2NvdW50cy5nb29nbGUuY29tIiwiYXpwIjoiNjc0MDM0NTIwNzMxLXN2bmZ2aGE3c2JwOTcxdWJnMG1ja2FtYWFjMDdqaGMyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwiYXVkIjoiNjc0MDM0NTIwNzMxLXN2bmZ2aGE3c2JwOTcxdWJnMG1ja2FtYWFjMDdqaGMyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTExMzc4NTczOTE3NjI3ODU0MDU1IiwiZW1haWwiOiJuaWtvbGF5LnRvbmV2QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJhdF9oYXNoIjoiemFWLUhpY0tpc3M0a193Y1VZbjBaUSIsIm5hbWUiOiJOaWtvbGF5IFRvbmV2IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hLS9BT2gxNEdqMDdBbEdJdFIzYjRRLWhQRGxVUThwbF9GZXk1VWVNSEdrREtMVkVBPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6Ik5pa29sYXkiLCJmYW1pbHlfbmFtZSI6IlRvbmV2IiwibG9jYWxlIjoiZW4iLCJpYXQiOjE2MDY1ODY4NDIsImV4cCI6MTYwNjU5MDQ0MiwianRpIjoiZjNlYzQxMTJkYjY0NzgxNWU4ZmU3MmVmMWRmMjMyZTY0MTQ5MzBlOSJ9.enMaI89-KMtRtlJOfpVDiRXsIOOq9K7MLIUmKjXBg4U7c-4Ne19epc7sGuxvSzRYHpPYMaIVzDmtRmQusPS0MlQfrCAyzP6AVkAC-FhcKpwW-UI52Tok5_yTGwUWqNvT6C9GeEtfRCu7BXLNbKXRU45uKU6LSNbnsdJBKePLuBCSAEy-zHTBAD3K_ewJsnPwY57hIjer3Cw5Wm9FHLl3PXekhP7JS-6lverzf6okquFmRso7ScKQnVYVcHEvTrhM9zG6ltdMFIbwi909PFct3qPpcmtancOOvGMr5a8j5zWKz6mECzydKPAb_ym9V3Nnu0VeaugLnOzYFwM6Fr3tHw';
  const jwks = '''{
  "keys": [
    {
      "kty": "RSA",
      "use": "sig",
      "kid": "dedc012d07f52aedfd5f97784e1bcbe23c19724d",
      "e": "AQAB",
      "alg": "RS256",
      "n": "sV158-MQ-5-sP2iTJibiMap1ug8tNY97laOud3Se_3jd4INq36NwhLpgU3FC5SCfJOs9wehTLzv_hBuo-sW0JNjAEtMEE-SDtx5486gjymDR-5Iwv7bgt25tD0cDgiboZLt1RLn-nP-V3zgYHZa_s9zLjpNyArsWWcSh6tWe2R8yW6BqS8l4_9z8jkKeyAwWmdpkY8BtKS0zZ9yljiCxKvs8CKjfHmrayg45sZ8V1-aRcjtR2ECxATHjE8L96_oNddZ-rj2axf2vTmnkx3OvIMgx0tZ0ycMG6Wy8wxxaR5ir2LV3Gkyfh72U7tI8Q1sokPmH6G62JcduNY66jEQlvQ"
    },
    {
      "alg": "RS256",
      "e": "AQAB",
      "n": "syWuIlYmoWSl5rBQGOtYGwO5OCCZnhoWBCyl-x5gby5ofc4HNhBoVVMUggk-f_MH-pyMI5yRYsS_aPQ2bmSox2s4i9cPhxqtSAYMhTPwSwQ2BROC7xxi_N0ovp5Ivut5q8TwAn5kQZa_jR9d7JO20BUB7UqbMkBsqg2J8QTtMJ9YtA5BmUn4Y6vhIjTFtvrA6iM4i1cKoUD5Rirt5CYpcKwsLxBZbVk4E4rqgv7G0UlWt6NAs-z7XDkchlNBVpMUuiUBzxHl4LChc7dsWXRaO5vhu3j_2WnxuWCQZPlGoB51jD_ynZ027hhIcoa_tXg28_qb5Al78ZttiRCQDKueAQ",
      "use": "sig",
      "kid": "2e3025f26b595f96eac907cc2b9471422bcaeb93",
      "kty": "RSA"
    }
  ]
}''';
  final claims = await IvmJWT.decodeJWTRS256(token, jwks);
  print('claims: $claims');
  expect(claims, claims);
}

void verifyOwnIssuedJWT() async {
  // Creating the claims
  final _claims = json.decode(
          '{\"iss\": \"Ivmanto.com\", \"maxAge\": 7200, \"ivmanto\": \"dev\"}')
      as Map<String, dynamic>;

  /// Instantiate segment payload and ivmJWT objects
  final segmentPayload = SegmentPayload.fromJson(_claims);
  final ivmjwt = IvmJWT(segmentPayload);

  /// call the issue method for RS256 signed token creation.
  final obj = await ivmjwt.issueJWTRS256();
  final token = obj['token'].toString();
  final keys = obj['publicKey'].toString();
  final segments = token.split('.');

  // expect the token to not be empty
  expect(token.isNotEmpty, true);
  // expect the keys to  not be empty
  expect(keys.isNotEmpty, true);
  expect(keys.contains('keys'), true);
  expect(segments.length == 3, true);

  /// Verification of the own issued token
  ///
  final result = await IvmJWT.decodeJWTRS256(token, keys);
  expect(result.containsKey('iss'), true);
  expect(result['iss'], 'Ivmanto.com');
  expect(result.containsKey('ivmanto'), true);
  expect(result['ivmanto'], 'dev');
  expect(result.containsKey('exp'), true);
}
