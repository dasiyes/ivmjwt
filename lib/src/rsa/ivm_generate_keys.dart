part of '../../ivmjwt.dart';

/// Generate RSA key pair
///
/// Overview [pointycastle]
/// The RSA (Rivest Shamir Adleman) algorithm is an asymmetric cryptographic algorithm (also known as a public-key algorithm). It uses two keys: a public key that is used for encrypting data and verifying signatures, and a private key that is used for decrypting data and creating signatures.
///
/// TODO: <<<<<<<<<<< ======================  Remove below lines after development =================>>>>>>>>>>>>>>
///
/// General theory [wikipedia](https://en.wikipedia.org/wiki/RSA_(cryptosystem)#Key_generation)
///
/// The keys for the RSA algorithm are generated in the following way:
///
/// 1. Choose two distinct prime numbers p and q.
///   * For security purposes, the integers p and q should be chosen at random, and should be similar in magnitude but differ in length by a few digits to make factoring harder.[2] Prime integers can be efficiently found using a primality test.
///   * p and q are kept secret.
/// 2. Compute n = pq.
///   * n is used as the modulus for both the public and private keys. Its length, usually expressed in bits, is the key length.
///   * n is released as part of the public key.
/// 3. Compute λ(n), where λ is Carmichael's totient function. Since n = pq, λ(n) = lcm(λ(p),λ(q)), and since p and q are prime, λ(p) = φ(p) = p − 1 and likewise λ(q) = q − 1. Hence λ(n) = lcm(p − 1, q − 1).
///   * λ(n) is kept secret.
///   * The lcm may be calculated through the Euclidean algorithm, since lcm(a,b) = |ab|/gcd(a,b).
/// 4. Choose an integer e such that 1 < e < λ(n) and gcd(e, λ(n)) = 1; that is, e and λ(n) are coprime.
///   * e having a short bit-length and small Hamming weight results in more efficient encryption  – the most commonly chosen value for e is 216 + 1 = 65,537. The smallest (and fastest) possible value for e is 3, but such a small value for e has been shown to be less secure in some settings.[15]
///   * e is released as part of the public key.
/// 5. Determine d as d ≡ e−1 (mod λ(n)); that is, d is the modular multiplicative inverse of e modulo λ(n).
///   * This means: solve for d the equation d⋅e ≡ 1 (mod λ(n)); d can be computed efficiently by using the Extended Euclidean algorithm, since, thanks to e and λ(n) being coprime, said equation is a form of Bézout's identity, where d is one of the coefficients.
///   * d is kept secret as the private key exponent.
///
/// <<<<<<<<<<< ======================== romeve =========================>>>>>>>>>>>>>>>>>>
class IvmGenerateKP {
  /// The pair of Keys
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> _pair;
  int ivmBitStrength;

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
  void generateAPair() {
    this._pair = _generateRSAKeyPair(_ivmSecureRandom(),
        bitStrength: ivmBitStrength ?? 2048);
    print('privateKey modulus: ${this._pair.privateKey.modulus}');
    print('publicKey modulus: ${this._pair.publicKey.modulus}');
  }

  get keyPair {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair;
  }

  get publicKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.publicKey;
  }

  get privateKey {
    if (this._pair == null) {
      generateAPair();
    }
    return this._pair.privateKey;
  }
}
