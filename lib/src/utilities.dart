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
  static bool validateSegmentToJSON(String segment) {
    /// Private function to verify if string value converts well to int or double.
    bool _isNum(String source) {
      try {
        num.parse(source);
        return true;
      } catch (e) {
        return false;
      }
    }

    // Verify if the value provided satisfy minimum requirements
    if (segment.isEmpty || segment.trim().length < 7) {
      throw Exception('Invalid segment string length!');
    }

    // Verify the segment value is properlly noteted as per requiremnts
    if (segment.trim().startsWith("{") && segment.trim().endsWith("}")) {
      // Remove first and last chars from the segment string
      var segmentBody = segment.trim().substring(1, segment.trim().length);
      segmentBody = segmentBody.substring(0, segmentBody.trim().length - 1);

      // Verify body of the segment string has at least 1 (one) (k,v) pair.
      final List<String> bodyParts = segmentBody.trim().split(',');

      if (bodyParts.isNotEmpty && bodyParts.length > 0) {
        // Verify if each part consists from a colon(:) splited,
        // correctly formatted keys and values.
        bodyParts.forEach((element) {
          try {
            final List<String> kv = element.split(RegExp(r":(?!//)"));
            if (kv.isNotEmpty && kv.length == 2) {
              kv.forEach((node) {
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
              print(element);
              print(kv);
              throw Exception('Invalid key-value pair in the segment value!');
            }
          } catch (e) {
            rethrow;
          }
        });
        // -=- -=- Return verification confirmation -=- -=-
        return true;

        // -=- -=-
      } else {
        throw Exception('Invalid segment body content!');
      }
    } else {
      throw Exception('Invalid segment format!');
    }
  }

  /// Get Object Data tool
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
}
