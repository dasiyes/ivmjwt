part of '../../ivmjwt.dart';

/// Generate RSA key pair
///
/// Overview by [pointycastle]
/// The RSA (Rivest Shamir Adleman) algorithm is an asymmetric cryptographic algorithm (also known as a public-key algorithm). It uses two keys: a public key that is used for encrypting data and verifying signatures, and a private key that is used for decrypting data and creating signatures.
///

class IvmGenerateKP {
  /// The pair of Keys
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _pair;
  int ivmBitStrength;
  Uuid _kid;

  IvmGenerateKP({int this.ivmBitStrength});

  /// To generate a pair of RSA keys:
  ///
  /// 1. Obtain a SecureRandom number generator.
  /// 2. Instantiate an RSAKeyGenrator object.
  /// 3. Initialize the key generator object with the secure random number generator and other parameters.
  /// 4. Invoke the object's generateKeyPair method.

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _generateRSAKeyPair(
      SecureRandom secureRandom,
      {int bitStrength = 2048}) {
    // create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitStrength, 64),
          secureRandom));

    // Use the generator
    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types
    final ivmPublic = pair.publicKey as RSAPublicKey;
    final ivmPrivate = pair.privateKey as RSAPrivateKey;
    this._kid = Uuid(uuid.v1());

    // return the generated keys!
    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        ivmPublic, ivmPrivate);
  }

  SecureRandom _ivmSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }

  /// Trigger the generation and get the pair
  ///
  /// This method will generate a new key pair from the the same instance of the
  /// class. The pair will have a new key id but the same bit strength define
  /// in the class instantiation.
  ///
  void generateAPair() {
    this._kid = Uuid.nil;
    this._pair = _generateRSAKeyPair(_ivmSecureRandom(),
        bitStrength: ivmBitStrength ?? 2048);
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> get keyPair {
    if (this._pair == null) {
      generateAPair();
      return this._pair;
    }
    return this._pair;
  }

  RSAPublicKey get publicKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.publicKey;
  }

  RSAPrivateKey get privateKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.privateKey;
  }

  Uuid get kid {
    if (this._pair == null) {
      this._kid = Uuid.nil;
      return this._kid;
    }
    return this._kid;
  }
}
