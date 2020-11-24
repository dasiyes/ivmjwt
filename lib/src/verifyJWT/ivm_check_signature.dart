part of '../../ivmjwt.dart';

/// Check signature

/// The last segment of a JWT is the signature, which is used to verify that the token was signed by the sender and not altered in any way. The Signature is created using the Header and Payload segments, a signing algorithm, and a secret or public key (depending on the chosen signing algorithm).
///
/// * Check the signing algorithm. (Done in ALG_CHECK: in ivm_jwt.dart)
/// * Retrieve the alg property from the decoded Header.
/// * Ensure that it is an allowed algorithm. Specifically, to avoid certain attacks, make sure you disallow none.
/// * Check that it matches the algorithm selected in the verification function name [e.g. verifyRS256].
/// * Confirm that the token is correctly signed using the proper key.
///
/// **To verify the signature, you will need to:**
///
Future<bool> _verifyRS256Signature(
    {@required String header,
    @required String payload,
    @required String token,
    @required String alg,
    @required String kid,
    @required String jwks}) async {
  // step-PREP-0
  final tokenSegments = token.split('.');
  RSAPublicKey _usePKey;
  if (alg.isEmpty || alg == 'none') {
    return false;
  }

  // step-PREP-1: get the public key:
  //
  try {
    print('[_verifyRS256Signature] jwks: $jwks, kid: $kid');

    // Work with the JWKS to get the right jwkey and then return the RSAPublicKey from it.
    final jJWKS = json.decode(jwks) as Map<String, dynamic>;
    final jwkSet = IvmRS256JWKS.fromJson(jJWKS);
    final jKey = jwkSet.getKeyByKid(kid);
    _usePKey = jKey.getRSAPublicKey();

    // _usePKey = await Utilities.getJWK(jwks, kid);
    print('get _usePKey: ${_usePKey.modulus}');
    print('_usePKey.bitLength: ${_usePKey.modulus.bitLength}');
  } catch (e) {
    throw Exception(
        'Unable to acquire public key for signature verification! $e.');
  }

  // Verify if the algorithm matches the
  if (alg == 'RS256') {
    // Prepare the token's signature (segment-3) and the header and the payload
    // as combined signedData - all in Uint8List format;
    final u8lOrgSignature =
        base64Url.decode(base64Url.normalize(tokenSegments[2]));

    final hd = await Utilities.base64UrlDecode(tokenSegments[0]);
    final pd = await Utilities.base64UrlDecode(tokenSegments[1]);

    final signedData = utf8.encode('${hd}.${pd}') as Uint8List;

    // return the result of Verify the signature
    try {
      final ivmVerifier =
          IvmVerifierRSA256(_usePKey, signedData, u8lOrgSignature);
      print(' verifyRS256?: ${ivmVerifier.verifyRS256()}');

      return ivmVerifier.verifyRS256();
    } catch (e) {
      throw Exception('Error raised while verifying signature! $e');
    }
  } else {
    throw Exception('Invalid signature verification algorithm selected!');
  }
}

// 1. To verify that the signature is correct, you need to generate a new Base64url-encoded signature using the public key (RS256) or secret (HS256) and verify that it matches the original Signature included with the JWT:

// Take the original Base64url-encoded Header and original Base64url-encoded Payload segments (Base64url-encoded Header + "." + Base64url-encoded Payload), and hash them with SHA-256.

// Encrypt using either HMAC or RSA (depending on your selected signing algorithm) and the appropriate key.

// Base64url-encode the result.

// For RS256: Retrieve the public key from the JSON web key set (JWKS) located by using the Auth0 discovery endpoint. For debugging purposes, you can visually inspect your token at jwt.io; for this purpose, you can also locate your public key in the Auth0 Dashboard. Look in Applications>Settings>Advanced Settings>Certificates and locate the Signing Certificate field.

// For HS256: Retrieve the client_secret from Auth0's Management API using the Get a Client endpoint. For debugging purposes, you can visually inspect your token at jwt.io; for this purpose, you can also locate your secret in the Auth0 Dashboard. For applications, look in Settings and locate the Client Secret field. For APIs, look in Settings and locate the Signing Secret field. (Note that this field is only displayed for APIs using the HS256 signing algorithm.)

// In the case of RSA, you can also use the following steps:

// Calculate current hash value. A hash value of the signed message is calculated. For this calculation, the same hashing algorithm is used as was used during the signing process. The obtained hash value is called the current hash value because it is calculated from the current state of the message.

// Calculate the original hash value. The digital signature is decrypted with the same encryption algorithm that was used during the signing process. The decryption is done by the public key that corresponds to the private key used during the signing of the message. As a result, we obtain the original hash value that was calculated from the original message during the previous step of the signing process (the original message digests).

// Compare the current and the original hash values. If the two values are identical, the verification is successful and proves that the message has been signed with the private key that corresponds to the public key used in the verification process. If the two values differ, the digital signature is invalid and the verification is unsuccessful.

// If the generated signature does not match the original Signature included with the JWT, the token is considered invalid, and the request must be rejected.
