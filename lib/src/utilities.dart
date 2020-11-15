part of '../ivmjwt.dart';

/// Utilities for IvmJWT
///
class Utilities {
  /// Decodes Base64Url encoded strings
  /// [encodedString] the string in Base64 format
  static Future<String> base64UrlDecode(String encodedString) async {
    // Decode in List of integers. Note: base64 normalization required!
    final Uint8List encIntList =
        await base64Url.decode(base64.normalize(encodedString));

    // Decode in UTF string
    try {
      return utf8.decode(encIntList, allowMalformed: false);
    } catch (e) {
      rethrow;
    }
  }

  /// Encoding to Base64 String
  /// [source] is the string to be encoded in Base64
  static Future<String> base64UrlEncode(String source) async {
    try {
      final Uint8List bytes = utf8.encode(source);
      String base64Str = base64Url.encode(bytes);
      return base64Str;
    } catch (e) {
      rethrow;
    }
  }

  /// Verify JSON object
  ///
  /// This function is to support the JWT segments validation purpose only.
  /// It will respect RFC8259 but not in any matter fully implement it.
  ///
  // TODO: REwork the enntire function for validating json object
  static bool validateSegmentToJSON(String segment) {
    /// Private function to verify if string value converts well to int or double.

    // <<<============ local functions ============>>>
    bool _isNum(String source) {
      try {
        num.parse(source);
        return true;
      } catch (e) {
        return false;
      }
    }

    /// Validate json elements
    ///
    bool _validateJsonElement(List<String> bodyParts) {
      // Verify if each part consists from a colon(:) splited,
      // correctly formatted keys and values.
      bodyParts.forEach((element) {
        try {
          final List<String> kv = element.split(RegExp(r":(?!//)"));
          if (kv.isNotEmpty && kv.length == 2) {
            kv.forEach((node) {
              print('node: $node');
              // Verify if each node of (K,V) pair meets at least one of the
              // conditions from the below list:
              // * surrounded by: "", [] or {}
              // * null, false or true
              // * is [int] or [double] runtimeType
              if (node == 'false' ||
                  node == 'true' ||
                  node == 'null' ||
                  _isNum(node) ||
                  (node.startsWith("[") && node.endsWith("]")) ||
                  (node.startsWith("{") && node.endsWith("}")) ||
                  (node.startsWith("\"") && node.endsWith("\""))) {
                // do nothing
              } else {
                throw Exception('Invalid quotation of keys or values!');
              }
            });
          } else {
            print('elem: $element');
            print('kv: $kv');
            throw Exception('Invalid key-value pair in the segment value!');
          }
        } catch (e) {
          rethrow;
        }
      });
      // -=- -=- Return verification confirmation -=- -=-
      return true;

      // -=- -=-
    }

    //
    // <<<============ End of local functions ============>>>

    print('segment to validte: $segment');

    // Verify bodyPart List

    // Verify if the value provided satisfy minimum requirements
    if (segment.isEmpty || segment.trim().length < 7) {
      throw Exception('Invalid segment string length!');
    }

    // Verify the segment value is properlly noteted as per requiremnts
    if (segment.trim().startsWith("{") && segment.trim().endsWith("}")) {
      // Remove first and last chars from the segment string
      var segmentBody = segment.trim().substring(1, segment.trim().length);
      segmentBody = segmentBody.substring(0, segmentBody.trim().length - 1);

      // List with k,v pairs extracted from the segment
      List<String> bodyParts = [];
      print('segmentBody: $segmentBody');

      // Segment body split on 2 parts
      final spliter_inx = segmentBody.indexOf(':');
      bodyParts.add(segmentBody.substring(0, spliter_inx));

      final restString = segmentBody.substring(spliter_inx + 1);
      final firstChar = restString.substring(0, 1);

      switch (firstChar) {
        case "\"":
          bodyParts.add(restString.substring(0, restString.indexOf(',')));
          break;
        case "[":
          bodyParts.add(restString);
          print('bodyParts: ${bodyParts.length}');
          break;
        case "{":
          // FIXME: not a valid statement
          bodyParts.add(restString);
          break;
        default:
          break;
      }

      if (bodyParts.isNotEmpty && bodyParts.length == 2) {
        print('bodyParts >1: $bodyParts and bp.length ${bodyParts.length}');
        return _validateJsonElement(bodyParts);
      } else {
        throw Exception('Invalid segment body content!');
      }
    } else {
      throw Exception('Invalid segment format!');
    }
  }

  /// Get Object Data tool
  ///
  /// [what] parameter defines if the method will return object's fields or methods
  ///
  static List<String> getObjectDefNames(Object obj, String what) {
    // Prep the result list
    List<String> result = [];
    var def_mirror;

    try {
      InstanceMirror instance_mirror = reflect(obj);
      def_mirror = instance_mirror.type;
    } catch (e) {
      throw Exception('Error while getting the mirror system! $e.');
    }

    for (var v in def_mirror.declarations.values) {
      if (what == 'fields' ||
          what == 'field' ||
          what == 'properties' ||
          what == 'property') {
        if (v is VariableMirror) {
          var fname = MirrorSystem.getName(v.simpleName);
          result.add(fname);
        }
      } else if (what == 'method' || what == 'methods') {
        if (v is MethodMirror) {
          var mname = MirrorSystem.getName(v.simpleName);
          result.add(mname);
        }
      }
    }
    // Return the list
    return result;
  }

  /// Retrive JWK from external API
  ///
  /// Need preliminary configured API to receive the JWK data. In case where
  /// the key values are rotated on regular base, this method will provide
  /// cache refreshing mechanism for expired values
  ///
  static Future<RSAPublicKey> getJWK(String jwks, String kid) async {
    // TODO: [JWT-3] implement get JWK
    // Convert the string of jwks to json. The string have been verified in previous steps of the main function.
    Map<String, dynamic> json_keys = json.decode(jwks);

    try {
      // Instantiate the JWKS object
      IvmRS256JWKS _jwks = IvmRS256JWKS.fromJson(json_keys);
      List<IvmRS256JWK> keys = _jwks.getKeysAsList();
      keys.forEach((key) {
        if (key.kid == kid) {
          return _publicKey(key);
        }
      });
      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Private function to compose RSAPublicKey to use for signature verification
  static RSAPublicKey _publicKey(IvmRS256JWK keySet) {
    Uint8List _eBytes = base64Url.decode(base64Url.normalize(keySet.e));
    Uint8List _nBytes = base64Url.decode(base64Url.normalize(keySet.n));

    final BigInt modulus = readBytes(_nBytes);
    final BigInt exponent = readBytes(_eBytes);

    return RSAPublicKey(modulus, exponent);
  }

  // << =========/*  dart-lang/sdk team examples functions */================ >>

  /// Reads Uint8List array into a BigInt.
  ///
  /// [readBytes] and [writeBigInt] are functions' examples given in GitHub
  /// (https://github.com/dart-lang/sdk/issues/32803) from dart-lang/sdk team.
  ///
  static BigInt readBytes(Uint8List bytes) {
    BigInt read(int start, int end) {
      if (end - start <= 4) {
        int result = 0;
        for (int i = end - 1; i >= start; i--) {
          result = result * 256 + bytes[i];
        }
        return new BigInt.from(result);
      }
      int mid = start + ((end - start) >> 1);
      var result = read(start, mid) +
          read(mid, end) * (BigInt.one << ((mid - start) * 8));
      return result;
    }

    return read(0, bytes.length);
  }

  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    int bytes = (number.bitLength + 7) >> 3;
    var b256 = new BigInt.from(256);
    var result = new Uint8List(bytes);
    for (int i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      number = number >> 8;
    }
    return result;
  }

  // << ============/* PointyCastle examples */============================ >>

  /// Alternative functions [decodeBigInt] and [encodeBigInt] from the
  /// PointyCastle library for converting between Uint8List and BigInt.
  ///
  /// Decode a BigInt from bytes in big-endian encoding.
  ///
  static BigInt decodeBigInt(List<int> bytes) {
    BigInt result = new BigInt.from(0);
    for (int i = 0; i < bytes.length; i++) {
      result += new BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Encode a BigInt into bytes using big-endian encoding.
  static Uint8List encodeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.

    var _byteMask = new BigInt.from(0xff);

    int size = (number.bitLength + 7) >> 3;
    var result = new Uint8List(size);
    for (int i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      number = number >> 8;
    }
    return result;
  }
}
