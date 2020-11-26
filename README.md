# ivmJWT Library
## ivmJWT is a helper library for working with JWT

This library will respect the standard [RFC7519] to a certain extend but not tested for its complete compliance.  

The first [beta] release supports only signing and verifying RSA (SHA-256).

# Get started

* install:
```dart
  dependencies:
    ivmjwt: ^0.1
```
and then run `pub get`.

* issue a new JWT RS256 signed token
```dart
final _claims = json.decode('{"iss": "Ivmanto.com", "maxAge": 1800, "ivmanto": "dev"}') as Map<String, dynamic>;
final ivmjwt = IvmJWT(SegmentPayload.fromJson(_claims));
final result = await ivmjwt.issueJWTRS256();
```
