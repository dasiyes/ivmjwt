import 'dart:convert';
import 'dart:typed_data';
import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';

Future<String> main() async {
  String result = "ivmJWToken here...";

  IvmGenerateKP ivmkp = IvmGenerateKP(ivmBitStrength: 1028);

  ivmkp.generateAPair();
  RSAPublicKey pubKey = ivmkp.publicKey;
  RSAPrivateKey prvKey = ivmkp.privateKey;
  String dataToSign = '.';
  Uint8List signature;

  try {
    IvmSignerRSA256 sign = IvmSignerRSA256(prvKey, utf8.encode(dataToSign));
    signature = sign.signedBytes;
    print(signature);
    print(sign.getBase64Signature());
  } catch (e) {
    print(e);
  }

  Uint8List pSignedData = utf8.encode('.');

  try {
    IvmVerifierRSA256 verifier =
        IvmVerifierRSA256(pubKey, pSignedData, signature);

    print('verified?: ${verifier.verifyRS256()}');
  } catch (e) {
    print(e);
  }
  return result;
}
