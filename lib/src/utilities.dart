import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Utilities for IvmJWT
///
class Utilities {
  /// Decodes Base64Url encoded strings
  static Future<String> base64Decode(String encodedString) async {
    // Decode in List of integers. Note: base64 normalization required!
    final Uint8List encIntList =
        await base64.decode(base64.normalize(encodedString));

    // Decode in UTF string
    try {
      return utf8.decode(encIntList, allowMalformed: false);
    } catch (e) {
      rethrow;
    }
  }
}
