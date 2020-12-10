part of '../../ivmjwt.dart';

/// RSA Verifier
///
/// by [pointycastle]:
/// To verify a signature:
///
/// 1. Obtain an RSAPublicKey.
/// 2. Instantiate an RSASigner with the desired Digest algorithm object and algorithm identifier.
/// 3. Initialize the object for verification with the public key.
/// 4. Invoke the object's verifySignature method with the data that was supposedly signed and the signature.
///
class IvmVerifierRSA256 {
  IvmVerifierRSA256(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
    if (publicKey == null) {
      throw Exception('Invalid key provided!');
    }
    _publicKey = publicKey;
    if (signedData == null || signedData.isEmpty) {
      throw Exception('Signed data not provided!');
    }
    _signedData = signedData;
    if (signature == null || signature.isEmpty) {
      throw Exception('Signature is not provided!');
    }
    _signature = signature;
  }
  RSAPublicKey _publicKey;
  Uint8List _signedData;
  Uint8List _signature;

  /// PointyCastle example
  bool rsaVerify(
      RSAPublicKey publicKey, Uint8List signedData, Uint8List signature) {
    final sig = RSASignature(signature);

    final verifier = RSASigner(SHA256Digest(), '0609608648016503040201');

    verifier.init(
        false, PublicKeyParameter<RSAPublicKey>(publicKey)); // false=verify

    try {
      return verifier.verifySignature(signedData, sig);
    } on ArgumentError {
      return false; // for Pointy Castle 1.0.2 when signature has been modified
    }
  }

  bool verifyRS256() {
    return rsaVerify(_publicKey, _signedData, _signature);
  }
}
