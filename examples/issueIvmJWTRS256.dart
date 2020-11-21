import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';

Future<String> main() async {
  String result = "ivmJWToken here...";

  IvmGenerateKP ivmkp = IvmGenerateKP(ivmBitStrength: 1028);

  // Checking pair for NULL
  print(ivmkp.kid);
  ivmkp.keyPair;
  print(ivmkp.kid);

  RSAPublicKey pubKey = ivmkp.publicKey;
  RSAPrivateKey prvKey = ivmkp.privateKey;

  // Checking pair NOT Null
  ivmkp.keyPair;

  print(pubKey.modulus);
  print(prvKey.modulus);
  return result;
}
