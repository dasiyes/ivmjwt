part of '../../ivmjwt.dart';

/// Generate RSA key pair
///
/// Overview by [pointycastle]
/// The RSA (Rivest Shamir Adleman) algorithm is an asymmetric cryptographic algorithm (also known as a public-key algorithm). It uses two keys: a public key that is used for encrypting data and verifying signatures, and a private key that is used for decrypting data and creating signatures.
///

class IvmKeyPair {
  /// The pair of Keys
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _pair;
  int ivmBitStrength;
  Uuid _kid;

  IvmKeyPair({int this.ivmBitStrength});

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

  /// The entire function is from PointyCastle example
  ///
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

  /// Getter for the keyPair
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> get keyPair {
    if (this._pair == null) {
      generateAPair();
      return this._pair;
    }
    return this._pair;
  }

  /// Getter for the public key in RSAPublicKey format
  RSAPublicKey get publicKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.publicKey;
  }

  /// Getter for the private key in RSAPrivateKey format
  RSAPrivateKey get privateKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.privateKey;
  }

  /// Getter for the keyPair ID.
  Uuid get kid {
    if (this._pair == null) {
      this._kid = Uuid.nil;
      return this._kid;
    }
    return this._kid;
  }

  /// Get the public key as JWK
  /// According to [RFC7518 section 6.3.1] for RSA Public key the memebers [n](modulus) and [e](exponent) MUST be presented alongside with mandatory [kty] key.
  ///
  /// Algorithm is handled by [RFC7518 section 7.1.1] as registration template.
  /// For this key pair the default alg is RS256.
  Map<String, dynamic> getPublicKeyAsJWK() {
    if (this._pair != null) {
      /// Get the public key's modulus
      final n =
          base64Url.encode(Utilities.writeBigInt(this._pair.publicKey.modulus));

      /// Get the public key's exponent
      final e = base64Url
          .encode(Utilities.writeBigInt(this._pair.publicKey.publicExponent));

      /// Get the keys' id
      final k = this.kid;

      Map<String, dynamic> rsaJWK = {
        "kty": "RSA",
        "n": '$n',
        "e": '$e',
        "alg": "RS256",
        "use": "sig",
        "kid": '$k'
      };

      return rsaJWK;
    } else {
      return null;
    }
  }

  /// Get the private key as JWK
  ///
  /// According to [RFC7518 section 6.3.2] for RSA Private key.
  /// In addition to the members used to represent RSA public keys, the
  /// following members are used to represent RSA private keys. The
  /// parameter "d" is REQUIRED for RSA private keys. The others enable
  /// optimizations and SHOULD be included by producers of JWKs
  /// representing RSA private keys. If the producer includes any of the
  /// other private key parameters, then all of the others MUST be present,
  /// with the exception of "oth", which MUST only be present when more
  /// than two prime factors were used.
  ///
  Map<String, dynamic> getPrivateKeyAsJWK() {
    // TODO: [dev] think of use-case that make sense since the private key should not be shared!
    throw UnimplementedError();
  }

  /// Get the public key PEM string
  ///
  String getPublicKeyAsPEM() {
    // TODO: [JWT-10] [dev] Implement public key as PEM
    throw UnimplementedError();
  }
}
