part of '../../ivmjwt.dart';

/// RSA Signer
///
/// by [pointycastle]
/// To create a signature:
///
/// 1. Obtain an RSAPrivateKey.
/// 2. Instantiate an RSASigner with the desired Digest algorithm object and an algorithm identifier.
/// 3. Initialize the object for signing with the private key.
/// 4. Invoke the object's generateSignature method with the data being signed.
///
/// RS256 (RSA Signature with SHA-256)
/// [source](https://stackoverflow.com/questions/39239051/rs256-vs-hs256-whats-the-difference)
///
/// Algorithm	  | Object Identifier	    | Hexadecimal encoding of DER
/// MD2	          1.2.840.113549.2.2	    06082a864886f70d0202
/// MD4	          1.2.840.113549.2.4	    06082a864886f70d0204
/// MD5	          1.2.840.113549.2.5	    06082a864886f70d0205
/// RIPEMD-128	  1.3.36.3.2.2	          06052b24030202
/// RIPEMD-160	  1.3.36.3.2.1	          06052b24030201
/// RIPEMD-256	  1.3.36.3.2.3	          06052b24030203
/// SHA-1	        1.3.14.3.2.26	          06052b0e03021a
/// SHA-224	      2.16.840.1.101.3.4.2.4	0609608648016503040204
/// SHA-256	      2.16.840.1.101.3.4.2.1	0609608648016503040201
/// SHA-384	      2.16.840.1.101.3.4.2.2	0609608648016503040202
/// SHA-512	      2.16.840.1.101.3.4.2.3	0609608648016503040203
///
class IvmSignerRSA256 {
  RSAPrivateKey _privateKey;
  Uint8List _dataToSign;
  Uint8List _signedBytes;

  IvmSignerRSA256(RSAPrivateKey privateKey, Uint8List dataToSign) {
    if (privateKey == null) {
      throw Exception('Invalid key provided!');
    }
    this._privateKey = privateKey;
    if (dataToSign == null || dataToSign.isEmpty) {
      throw Exception('No data to sign!');
    }
    this._dataToSign = dataToSign;
  }

  /// PointyCastle example
  Uint8List rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');

    signer.init(
        true, PrivateKeyParameter<RSAPrivateKey>(privateKey)); // true=sign

    final sig = signer.generateSignature(dataToSign);

    return sig.bytes;
  }

  Uint8List get signedBytes {
    if (this._signedBytes == null) {
      this._signedBytes = rsaSign(this._privateKey, this._dataToSign);
      return this._signedBytes;
    }
    return this._signedBytes;
  }

  String getBase64Signature() {
    String signB64;

    if (this._signedBytes == null) {
      this._signedBytes = signedBytes;
    }
    signB64 = base64Url.encode(this._signedBytes);
    return signB64;
  }
}
