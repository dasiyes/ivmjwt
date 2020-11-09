part of '../ivmjwt.dart';

/// Utilities for IvmJWT
///
class Utilities {
  /// Decodes Base64Url encoded strings
  /// [encodedString] the string in Base64 format
  static Future<String> base64Decode(String encodedString) async {
    // Decode in List of integers. Note: base64 normalization required!
    final Uint8List encIntList =
        await base64Url.decode(base64.normalize(encodedString));

    // Decode in UTF string
    try {
      return utf8.decode(encIntList, allowMalformed: false);
      // TODO:[debug] remove 1 line below after debugging
      // return "{alg: \"RS256\", typ: \"JWT\"}";
    } catch (e) {
      rethrow;
    }
  }

  /// Encoding to Base64 String
  /// [source] is the string to be encoded in Base64
  static Future<String> base64Encode(String source) async {
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
  static bool validateSegmentToJSON(String segment) {
    // Verify if the value provided satisfy minimum requirements
    if (segment.isEmpty || segment.trim().length < 7) {
      throw Exception('Invalid header string length!');
    }

    // Verify the segment value is properlly noteted as per requiremnts
    if (segment.trim().startsWith("{") && segment.trim().endsWith("}")) {
      // Remove first and last chars from the segment string
      var segmentBody = segment.trim().substring(1, segment.trim().length);
      segmentBody = segmentBody.substring(0, segmentBody.trim().length - 1);

      // Verify body of the segment string has at least 1 (one) (k,v) pair.
      final List<String> bodyParts = segmentBody.trim().split(',');
      if (bodyParts.isNotEmpty && bodyParts.length > 0) {
        // Verify if each part consists from a colon(:) splited, double quoted strings.
        bodyParts.forEach((element) {
          try {
            final List<String> kv = element.split(':');
            if (kv.isNotEmpty && kv.length == 2) {
              kv.forEach((node) {
                // Verify if double quotes(") are around every node of kv pair.
                if (!(node.trim().startsWith("\"")) ||
                    !(node.trim().endsWith("\""))) {
                  throw Exception('Invalid quotation of keys and values!');
                }
              });
            } else {
              throw Exception('Invalid key-value pair in the header!');
            }
          } catch (e) {
            rethrow;
          }
        });
        // -=- -=- Return verification confirmation -=- -=-
        return true;

        // -=- -=-
      } else {
        throw Exception('Invalid header body content!');
      }
    } else {
      throw Exception('Invalid header format!');
    }
  }
}
