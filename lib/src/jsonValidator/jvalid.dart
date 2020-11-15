part of '../../ivmjwt.dart';

/// JSON Validator [RFC8259]
///
/// This class will validate if a string object represents a valid JSON object defined by RFC8259 standard.
///
/// JavaScript Object Notation (JSON) is a text format for the serialization of structured data.
///
/// JSON can represent four primitive types (strings, numbers, booleans, and null) and two structured types (objects and arrays).
class JsonValidator {
  String json;
  bool _validity = false;

  JsonValidator(String this.json);

  bool validate() {
    // An empty string is not a valid json object
    if (json.isEmpty) return false;

    // A zero length object is valid (faster return than value validation)
    if (json.length == 2 && json.startsWith("{") && json.endsWith("}"))
      return true;

    // Do cycling validation of the Name-Value Pairs
    return _validateNameValuePair(json);
  }

  /// An object is an unordered collection of zero or more name/value pairs, where:
  /// * a name is a string
  /// and
  /// * a value is a string, number, boolean, null, object, or array.
  ///
  /// An array is an ordered sequence of zero or more values.
  ///
  bool _validateNameValuePair(String value) {
    String _value = value.trim();

    // define the function exit point
    if (_value.isEmpty) return _validity;

    do {
      // validate an object
      if (_value == 'invalid') {
        _validity = false;
      } else {
        _validity == true;
      }
      // cycling validation until the entire string is validated or
      // _value 'invalid' is sent.
      _value = _validateFirstKeyValuePair(_value);
    } while (_value.isNotEmpty);

    return _validity;
  }

  /// Validate Key-Value Pair
  ///
  /// This function esentialy validates the first token with key-value pair; If it is valid then the function returns is a string of the rest of the provided string (the first k-v pair removed) that needs to be validate.
  ///
  String _validateFirstKeyValuePair(String value) {
    bool _validPairName = false;
    bool _validPairValue = false;
    String tokens;
    String spc = _getSuroundingChars(value.trim());

    if (['[]', '{}'].contains(spc)) {
      // Remove the object's lead and closing chars
      tokens = value.substring(1, value.length - 1);
    } else {
      tokens = value.trim();
    }

    // Getting first PairName string
    final String firstPairName =
        tokens.substring(0, tokens.indexOf(RegExp(r":(?!//)"))).trim();
    print('... pairsName: $firstPairName');

    if (_getSuroundingChars(firstPairName) == '""') {
      _validPairName = true;
    } else {
      return 'invalid';
    }

    // Getting first PairValue string
    int colonIndex = tokens.indexOf(RegExp(r":(?!//)"));
    int commaIndex = tokens.indexOf(',');

    String valueStartsWith;

    valueStartsWith = tokens.substring(colonIndex + 1, colonIndex + 2).trim();

    if (valueStartsWith.isEmpty) {
      valueStartsWith = tokens.substring(colonIndex + 1, colonIndex + 3).trim();
    }

    String firstPairValue;

    if (['[', '{', 'f', 't', 'n'].contains(valueStartsWith)) {
      // Get the array or object of the value
      firstPairValue = _getValueObject(tokens.substring(colonIndex + 1).trim());
      if (firstPairValue.isNotEmpty) {
        _validPairValue = true;
      } else {
        return 'invalid';
      }
    } else if (['1', '2', '3', '4', '5', '6', '7', '8', '9', '0']
        .contains(valueStartsWith)) {
      firstPairValue = _getValueObject(tokens.substring(colonIndex + 1).trim());
      if (firstPairValue.isNotEmpty || firstPairValue != 'invalid') {
        _validPairValue = true;
      } else {
        return 'invalid';
      }
    } else {
      if (commaIndex == -1) {
        firstPairValue = tokens.substring(colonIndex + 1);
      } else {
        firstPairValue = tokens.substring(colonIndex + 1, commaIndex);
      }
      if (_getSuroundingChars(firstPairValue) == '""') {
        _validPairValue = true;
      } else {
        return 'invalid';
      }
    }

    print('.... pairsValue: $firstPairValue');
    print('cmIdx: $commaIndex');
    print('_validPairValue: $_validPairValue');

    if (_validPairName && _validPairValue && commaIndex != -1) {
      final String retValue = '{${tokens.substring(commaIndex + 1)}}';
      print('return: $retValue');
      return retValue;
    } else if (_validPairName && _validPairValue && commaIndex == -1) {
      return '';
    } else {
      return 'invalid';
    }
  }

  String _getSuroundingChars(String str) {
    if (str.length < 2 || str == null) {
      return 'invalid';
    }
    return '${str.substring(0, 1)}${str.substring(str.length - 1)}';
  }

  /// This function will extract the first pair's value
  String _getValueObject(String restValue) {
    String result;
    int commaIndex = restValue.indexOf(',');

    /// Local function to verify for numbers
    String _isNum() {
      if (commaIndex != -1) {
        try {
          return num.parse(restValue.substring(0, commaIndex)).toString();
        } catch (e) {
          print('Exception while parsing to number: $e');
          return 'invalid';
        }
      } else {
        try {
          return num.parse(restValue).toString();
        } catch (e) {
          print('Exception while parsing to number: $e');
          return 'invalid';
        }
      }
    }

    /// Local function to handle Tru, False and Null values
    String _handleTFN() {
      if (commaIndex != -1) {
        result = restValue.substring(0, commaIndex);
      } else {
        result = restValue;
      }
      return result;
    }

    print(restValue);
    final String leadChar = restValue.substring(0, 1);
    switch (leadChar) {
      case '[':
        break;
      case '{':
        break;
      case 't':
        result = _handleTFN();
        break;
      case 'f':
        result = _handleTFN();
        break;
      case 'n':
        result = _handleTFN();
        break;
      default:
        result = _isNum();
        break;
    }
    return result;
  }
}
