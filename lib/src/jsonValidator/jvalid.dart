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
    if (_value.isEmpty) return false;

    print('initial value: $_value');

    do {
      // cycling validation until the entire string is validated or
      // _value 'invalid' is sent.
      _value = _validateFirstKeyValuePair(_value);

      // validate an object
      if (_value == 'invalid') {
        this._validity = false;
        break;
      } else if (_value.isEmpty) {
        this._validity = true;
      }
    } while (_value.isNotEmpty);

    return this._validity;
  }

  /// Validate Key-Value Pair
  ///
  /// This function esentialy validates the first token with key-value pair; If it is valid then the function returns is a string of the rest of the provided string (the first k-v pair removed) that needs to be validate.
  ///
  String _validateFirstKeyValuePair(String value) {
    //Step-0
    // <<<< ================ Prep & Analyses =============================>>>>
    bool _validPairName = false;
    bool _validPairValue = false;
    String tokens;
    String firstPairName;
    String firstPairValue;
    String valueStartsWith;
    String retValue;
    String spc = _getSuroundingChars(value.trim());

    // Remove the object's lead and closing chars or not
    // depending on the surounding chars
    if (['[]', '{}'].contains(spc)) {
      tokens = value.trim().substring(1, value.length - 1);

      print('tokens to evaluate: $tokens');
      // If the surounding chars are "[]" - get the list of the elements
      if (spc == "[]") {
        // TODO: analyse the array elements...
      }
    } else {
      tokens = value.trim();
    }

    // Identify the separators positions for the first k-v pair.
    int colonIndex = tokens.indexOf(RegExp(r":(?!//)"));
    int commaIndex = tokens.indexOf(',');

    // Get the starting char for the value part of the pair.
    valueStartsWith = tokens.substring(colonIndex + 1, colonIndex + 2).trim();
    if (valueStartsWith.isEmpty) {
      valueStartsWith = tokens.substring(colonIndex + 1, colonIndex + 3).trim();
    }

    // Define a list of chars that Value part of the pair can start with
    final List<String> _possibleFC = [
      '"',
      '[',
      '{',
      'f',
      't',
      'n',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0',
      '-'
    ];

    // Step-1
    // <<<<================= Getting first PairName string ================>>>>
    firstPairName = tokens.substring(0, colonIndex).trim();

    if (_getSuroundingChars(firstPairName) == '""') {
      _validPairName = true;
    } else {
      return 'invalid';
    }

    // Step-2
    // <<<<================== Getting first PairValue string ==============>>>>

    // Extract the Value part from the key-value token;
    if (_possibleFC.contains(valueStartsWith)) {
      firstPairValue = _getValueObject(tokens.substring(colonIndex + 1).trim());
    } else {
      return 'invalid';
    }

    // Check the extracted firstPairValue for success.
    if (firstPairValue.isEmpty || firstPairValue == 'invalid') {
      return 'invalid';
    } else {
      _validPairValue = true;
    }

    // Step-3
    // <<<<==================== Composing the return result ===============>>>>

    /// * Note: if the first token (k-v pair) was successfully verified, then
    /// * the composing part below should CUT the first token and return as
    /// * result the rest of the provided string [value].
    /// * If this token has been the last pair in the object AND it has been
    /// * successfully verified - the returned result is EMPTY string.
    ///
    if (_validPairName && _validPairValue && commaIndex != -1) {
      if (['[]', '{}'].contains(spc)) {
        retValue =
            '${spc.substring(0, 1)}${tokens.substring(commaIndex + 1)}${spc.substring(1)}';
      } else {
        retValue = '{${tokens.substring(commaIndex + 1)}}';
      }
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
    ///
    String _isNum() {
      if (commaIndex == -1) {
        try {
          num.parse(restValue).toString();
          return restValue;
        } catch (e) {
          print('Exception while parsing to number: $e');
          return 'invalid';
        }
      } else {
        try {
          return num.parse(restValue.substring(0, commaIndex)).toString();
        } catch (e) {
          print('Exception while parsing to number: $e');
          return 'invalid';
        }
      }
    }

    /// Local function to handle True, False and Null values
    ///
    String _handleTFN() {
      if (commaIndex == -1) {
        result = restValue;
      } else {
        result = restValue.substring(0, commaIndex);
      }
      return result;
    }

    /// Local function to handle values with suroundings chars
    ///
    String _handleDQ() {
      // This is the last token - no comma till the end of the string;
      if (commaIndex == -1) {
        // Check for proper surounding double quotes
        if (_getSuroundingChars(restValue) == '""') {
          result = restValue;
        } else {
          return 'invalid';
        }
      } else {
        String _extVal = restValue.substring(0, commaIndex);
        if (_getSuroundingChars(_extVal) == '""') {
          result = _extVal;
        } else {
          return 'invalid';
        }
      }
      return result;
    }

    /// Local function to handle ARRAYS as value from the token
    ///
    /// Arrays
    /// An array structure is represented as square brackets surrounding zero
    /// or more values (or elements).  Elements are separated by commas.
    /// array = begin-array [ value *( value-separator value ) ] end-array
    /// There is no requirement that the values in an array be of the same
    /// type.
    String _handleARRAYS({@required oBraket, @required cBraket}) {
      // commaIndex will NOT work here due to existing commas within the array.
      List<int> openingArrayIndexes = [];
      List<int> closingArrayIndexes = [];
      int tmpIndex = 0;
      // Calc valid array's enclosures
      print('-restValue: $restValue');

      do {
        tmpIndex = restValue.indexOf("$oBraket", tmpIndex);
        openingArrayIndexes.add(tmpIndex);
        if (tmpIndex != -1) tmpIndex++;
        print('tmpIndex: $tmpIndex');
      } while (tmpIndex != -1);

      // Intermidiate reset
      tmpIndex = 0;

      do {
        tmpIndex = restValue.indexOf("$cBraket", tmpIndex);
        closingArrayIndexes.add(tmpIndex);
        if (tmpIndex != -1) tmpIndex++;
        print('tmpIndex: $tmpIndex');
      } while (tmpIndex != -1);

      print(
          'opening: ${openingArrayIndexes.length}; closing: ${closingArrayIndexes.length}');

      // Invalid enclosure case
      if (openingArrayIndexes.length != closingArrayIndexes.length) {
        return 'invalid';
      }

      // Redefining commaIndex for the comma located after the last closing tag
      commaIndex = restValue.indexOf(
          ',', closingArrayIndexes[closingArrayIndexes.length - 2]);

      bool validatedObj = false;
      if (commaIndex == -1) {
        // the object is the last token...
        print('value to send: $restValue');
        validatedObj = _validateNameValuePair(restValue.trim());
        print('validated result: $validatedObj');
        if (validatedObj) {
          return restValue;
        } else {
          return 'invalid';
        }
      } else {
        // there is more tokens after the object
        String obj = restValue.substring(0, commaIndex);
        print('value to send: $obj');
        validatedObj = _validateNameValuePair(obj.trim());
        print('validated result: $validatedObj');
        if (validatedObj) {
          return obj;
        } else {
          return 'invalid';
        }
      }
    }

    /// Getting the lead char of the provided restValue
    String leadChar = restValue.substring(0, 1);
    if (leadChar.isEmpty) {
      leadChar = restValue.substring(0, 2);
    }

    switch (leadChar) {
      case '"':
        result = _handleDQ();
        break;
      case '[':
        result = _handleARRAYS(oBraket: '[', cBraket: ']');
        break;
      case '{':
        result = _handleARRAYS(oBraket: '{', cBraket: '}');
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
