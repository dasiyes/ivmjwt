import 'package:ivmjwt/ivmjwt.dart';
import 'package:pointycastle/pointycastle.dart';

Future<String> main() async {
  String result = "ivmJWToken here...";

  IvmGenerateKP ivmkp = IvmGenerateKP(ivmBitStrength: 1028);
  RSAPublicKey pubKey = ivmkp.publicKey;
  RSAPrivateKey prvKey = ivmkp.privateKey;

  print(pubKey.modulus);
  print(prvKey.modulus);
  return result;
}
