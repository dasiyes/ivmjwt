part of '../ivmjwt.dart';

/// Utilities for IvmJWT
///
class Utilities {
  /// Decodes Base64Url encoded strings
  /// [encodedString] the string in Base64 format
  static Future<String> base64UrlDecode(String encodedString,
      // ignore: avoid_positional_boolean_parameters
      [bool decodeL1 = false]) async {
    // Decode in List of integers. Note: base64 normalization required!
    final encIntList = base64Url.decode(base64.normalize(encodedString));

    // Decode in UTF string
    try {
      if (decodeL1) {
        return latin1.decode(encIntList);
      }
      return utf8.decode(encIntList, allowMalformed: false);
    } catch (e) {
      rethrow;
    }
  }

  /// Encoding to Base64 String
  /// [source] is the string to be encoded in Base64
  static Future<String> base64UrlEncode(String source,
      // ignore: avoid_positional_boolean_parameters
      [bool encodeL1 = false]) async {
    try {
      Uint8List bytes;
      if (encodeL1) {
        bytes = latin1.encode(source);
      } else {
        bytes = Uint8List.fromList(utf8.encode(source));
      }
      return base64Url.encode(bytes);
    } catch (e) {
      throw Exception('Error while base64Url encoding! $e');
    }
  }

  /// Get Object Data tool
  ///
  /// [what] parameter defines if the method will return object's fields or methods
  ///
  static List<String> getObjectDefNames(Object obj, String what) {
    // Prep the result list
    final result = <String>[];
    // ignore: prefer_typing_uninitialized_variables
    var defMirror;

    try {
      final instanceMirror = reflect(obj);
      defMirror = instanceMirror.type;
    } catch (e) {
      throw Exception('Error while getting the mirror system! $e.');
    }

    for (var v in defMirror.declarations.values) {
      if (what == 'fields' ||
          what == 'field' ||
          what == 'properties' ||
          what == 'property') {
        if (v is VariableMirror) {
          final fname = MirrorSystem.getName(v.simpleName);
          result.add(fname);
        }
      } else if (what == 'method' || what == 'methods') {
        if (v is MethodMirror) {
          final mname = MirrorSystem.getName(v.simpleName);
          result.add(mname);
        }
      }
    }
    // Return the list
    return result;
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
        var result = 0;
        for (var i = end - 1; i >= start; i--) {
          result = result * 256 + bytes[i];
        }
        return BigInt.from(result);
      }
      final mid = start + ((end - start) >> 1);
      final result = read(start, mid) +
          read(mid, end) * (BigInt.one << ((mid - start) * 8));
      return result;
    }

    return read(0, bytes.length);
  }

  static Uint8List writeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.
    final bytes = (number.bitLength + 7) >> 3;
    final b256 = BigInt.from(256);
    final result = Uint8List(bytes);
    for (var i = 0; i < bytes; i++) {
      result[i] = number.remainder(b256).toInt();
      // ignore: parameter_assignments
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
    var result = BigInt.from(0);
    for (var i = 0; i < bytes.length; i++) {
      result += BigInt.from(bytes[bytes.length - i - 1]) << (8 * i);
    }
    return result;
  }

  /// Encode a BigInt into bytes using big-endian encoding.
  static Uint8List encodeBigInt(BigInt number) {
    // Not handling negative numbers. Decide how you want to do that.

    final _byteMask = BigInt.from(0xff);

    final size = (number.bitLength + 7) >> 3;
    final result = Uint8List(size);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = (number & _byteMask).toInt();
      // ignore: parameter_assignments
      number = number >> 8;
    }
    return result;
  }

  /// Seconds/miliseconds since EPOCH
  ///
  /// @param String measure - default to "s", defines the measure of the returned result. Accepts "s" for seconds or "ms" for miliseconds.
  ///
  static int currentTimeInSMS({String measure = 's'}) {
    final ms = DateTime.now().millisecondsSinceEpoch;
    if (measure == 'ms') {
      return ms;
    }
    return (ms / 1000).round();
  }
}
