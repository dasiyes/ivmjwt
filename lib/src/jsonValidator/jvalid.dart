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

  bool validate([String nestedJson]) {
    if (nestedJson == null) {
      json = this.json;
    } else {
      json = nestedJson;
    }
    // An empty string is not a valid json object
    if (json.isEmpty) return false;

    // A zero length object is a valid json.
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

    // Minumum token length (6 chars = {"":n}) check
    if (_value.length < 6) return false;

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
    bool _isAnArray = false;
    String tokens;
    String firstPairName;
    String firstPairValue;
    String valueStartsWith;
    String retValue;
    String spc = _getSuroundingChars(value.trim());

    // Verify the array
    if (spc == '[]') {
      tokens = _getValueObject(value);
    }

    // Remove the object's lead and closing chars or not
    // depending on the surounding chars
    if (spc == '{}') {
      tokens = value.trim().substring(1, value.length - 1);
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

      // If the value part starts with '[' the value may be a valid ARRAY and
      // the commaIndex needs to be redefined
      if (valueStartsWith == '[') {
        _isAnArray = true;
      }
    } else {
      return 'invalid';
    }

    // Check the extracted firstPairValue for success.
    if (firstPairValue == 'invalid') {
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
    if (_validPairName && _validPairValue && !_isAnArray && commaIndex != -1) {
      if (spc == '{}') {
        retValue = '{${tokens.substring(commaIndex + 1)}}';
      }
      return retValue;
    } else if (_validPairName && _validPairValue && _isAnArray) {
      if (firstPairValue.isEmpty) {
        retValue = '';
      } else {
        retValue = '{$firstPairValue}';
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

    // <<<<================== Local functions =======================>>>>

    /// Calculate enclosures
    ///
    Map<String, List<int>> _calculateEnclosures(
        {@required oBraket, @required cBraket}) {
      // commaIndex will NOT work here due to existing commas within the array.
      List<int> openingArrayIndexes = [];
      List<int> closingArrayIndexes = [];

      // Calc valid array's enclosures
      String char;
      int dq = 0;
      int i = 0;

      do {
        char = restValue[i];
        if (char == '"' && dq == 0) {
          dq++;
        } else if (char == '"' && dq == 1) {
          dq--;
        }
        if (char == oBraket && dq == 0) openingArrayIndexes.add(i);
        if (char == cBraket && dq == 0) closingArrayIndexes.add(i);
        i++;
      } while (i < restValue.length);

      return {"oil": openingArrayIndexes, "cil": closingArrayIndexes};
    }

    /// Parsing array from the begining of the restValue string
    /// This function assumes the string to be parsed BEGINS with
    /// [bracketType] either one of '[' or '{'
    String _parseEnclosure(String bracketType, [String toBeParsed]) {
      String tmpHolder;
      String openBracket;
      String closeBracket;

      if (bracketType == '[') {
        openBracket = '[';
        closeBracket = ']';
      } else if (bracketType == '{') {
        openBracket = '{';
        closeBracket = '}';
      } else {
        return 'invalid';
      }

      if (toBeParsed == null) {
        tmpHolder = restValue;
      } else {
        tmpHolder = toBeParsed;
      }

      // Calculate currly brakets enclosures
      Map<String, List<int>> _cbIndexMap =
          _calculateEnclosures(oBraket: '{', cBraket: '}');
      List<int> cbOpenningIndexes = _cbIndexMap['oil'];
      List<int> cbClosingIndexes = _cbIndexMap['cil'];

      // Calculate square brakets enclosures
      Map<String, List<int>> _sbIndexMap =
          _calculateEnclosures(oBraket: '[', cBraket: ']');
      List<int> sbOpenningIndexes = _sbIndexMap['oil'];
      List<int> sbClosingIndexes = _sbIndexMap['cil'];

      // Check for correct enclosure
      if (sbOpenningIndexes.length != sbClosingIndexes.length ||
          cbOpenningIndexes.length != cbClosingIndexes.length) {
        return 'invalid';
      }

      // Get the entire array string (find the closing bracket)
      int b = 1;
      String char = '';
      int closingBracketIndex;
      while (b != 0) {
        // [i] starts from 1 ASSUMING the char at position 0 is already the
        // opening bracket ( '[' or '{') thus b=1
        for (var i = 1; i < tmpHolder.length; i++) {
          char = tmpHolder[i];
          if (char == '$openBracket') {
            b++;
          } else if (char == '$closeBracket') {
            b--;
            if (b == 0) {
              closingBracketIndex = i;
              break;
            }
          }
        }
        // Force the b to ZERO
        if (b != 0) {
          closingBracketIndex = -1;
          b = 0;
        }
      }

      if (closingBracketIndex > 0 &&
          (tmpHolder.length - 1 >= closingBracketIndex)) {
        String result = tmpHolder.substring(0, closingBracketIndex + 1);

        return result;
      } else {
        return 'invalid';
      }
    }

    /// Validate an Object previously parsed
    ///
    bool _validateObject(String parsedObject) {
      return this.validate(parsedObject);
    }

    /// Validate an ARRAY previously parsed
    ///
    bool _validateArray(String parsedArray) {
      bool validity = false;
      String retval;
      String arrayBody = parsedArray.substring(1, parsedArray.length - 1);
      int commaIndex = -1;
      do {
        String firstChar = arrayBody.substring(0, 1);

        // Process arrayBody that starts with either one of '[' or '{'
        if (firstChar == '{' || firstChar == '[') {
          do {
            String nestedElement = _parseEnclosure('$firstChar', arrayBody);

            if (firstChar == '{') {
              bool validityNestedElement = validate(nestedElement);

              if (validityNestedElement) {
                if (arrayBody.trim().length == nestedElement.trim().length) {
                  arrayBody = '';
                  validity = validityNestedElement;
                } else if (arrayBody.length > nestedElement.length + 1) {
                  // cutting the first (verified) element
                  arrayBody = arrayBody.substring(nestedElement.length).trim();

                  // Check and cut-off the leading and trailing spaces and commas.
                  if (arrayBody.trim().endsWith(',')) {
                    arrayBody = arrayBody.trim().substring(0, arrayBody.length);
                    arrayBody = arrayBody.trim();
                  }
                  if (arrayBody.trim().startsWith(',')) {
                    arrayBody = arrayBody.trim().substring(1);
                    arrayBody = arrayBody.trim();
                  }

                  firstChar = arrayBody.substring(0, 1);
                } else {
                  validity = true;
                }
              } else {
                validity = false;
                break;
              }
            } else if (firstChar == '[') {
              if (_validateArray(nestedElement)) {
                if (arrayBody.trim().length == nestedElement.length) {
                  arrayBody = '';
                } else if (arrayBody.length > nestedElement.length) {
                  // cutting the first (verified) element
                  arrayBody = arrayBody.substring(nestedElement.length).trim();
                  firstChar = arrayBody.substring(0, 1);
                } else {
                  validity = true;
                }
              } else {
                validity = false;
                break;
              }
            }

            // Check and cut-off the leading and trailing spaces and commas.
            if (arrayBody.trim().endsWith(',')) {
              arrayBody = arrayBody.trim().substring(0, arrayBody.length);
            }
            if (arrayBody.trim().startsWith(',')) {
              arrayBody = arrayBody.trim().substring(1);
            }
          } while (arrayBody.startsWith('{') || arrayBody.startsWith('['));

          if (arrayBody.isEmpty) return validity;
        }

        // After confirmation the element is nor another array or objec
        // process the elements further as single pair's value
        String arrayElement;
        commaIndex = arrayBody.indexOf(',');

        if (commaIndex > -1) {
          arrayElement = arrayBody.substring(0, commaIndex);
        } else {
          arrayElement = arrayBody.substring(0);
        }
        // there is no nesting - verify the element
        retval = _getValueObject(arrayElement);

        // Cut out the first element
        arrayBody = arrayBody.substring(commaIndex + 1);
        if (retval == 'invalid') {
          validity = false;
          break;
        } else if (commaIndex == -1 && retval != 'invalid') {
          validity = true;
        }
      } while (commaIndex != -1);

      // Return the final validation result
      return validity;
    }

    /// verify for numbers
    ///
    String _isNum() {
      if (commaIndex == -1) {
        try {
          num.parse(restValue).toString();
          return restValue;
        } catch (e) {
          return 'invalid';
        }
      } else {
        try {
          return num.parse(restValue.substring(0, commaIndex)).toString();
        } catch (e) {
          return 'invalid';
        }
      }
    }

    /// handle True, False and Null values
    ///
    String _handleTFN() {
      if (commaIndex == -1) {
        if (['true', 'false', 'null'].contains(restValue)) {
          result = restValue;
        } else {
          result = 'invalid';
        }
      } else {
        result = restValue.substring(0, commaIndex);
      }
      return result;
    }

    /// handle values with suroundings double quotes
    ///
    String _handleDQ() {
      // This is the last token - no comma till the end of the string;
      if (commaIndex == -1) {
        // Check for proper surounding double quotes
        if (_getSuroundingChars(restValue.trim()) == '""') {
          result = restValue;
        } else {
          return 'invalid';
        }
      } else {
        String _extVal = restValue.trim().substring(0, commaIndex);
        if (_getSuroundingChars(_extVal) == '""') {
          result = _extVal;
        } else {
          return 'invalid';
        }
      }
      return result;
    }

    /// handle ARRAYS / OBJECTS as value from the token
    ///
    /// Objects
    ///
    /// An object structure is represented as a pair of curly brackets
    /// surrounding zero or more name/value pairs (or members).  A name is a
    /// string.  A single colon comes after each name, separating the name
    /// from the value.  A single comma separates a value from a following
    /// name.  The names within an object SHOULD be unique.
    ///
    ///  object = begin-object [ member *( value-separator member ) ]
    ///           end-object
    ///  member = string name-separator value
    ///
    String _handleObject() {
      // Invalidate smaller and not valid
      if (restValue.length == 1 || (restValue.length == 2 && restValue != '{}'))
        return 'invalid';

      String parsedObject = _parseEnclosure('{');

      // Redefining commaIndex for the comma located after the last closing bracket
      commaIndex = restValue.indexOf(',', parsedObject.length);

      // Validate an object and return BOOL for its validity
      if (_validateObject(parsedObject)) {
        if (commaIndex == -1) {
          // Successfully verified object as last pair's value
          return '';
        } else {
          // If the object is valid, but there is remaining part after it - return it
          return restValue.substring(commaIndex + 1).trim();
        }
      } else {
        return 'invalid';
      }
    }

    /// Arrays
    ///
    /// An array structure is represented as square brackets surrounding zero
    /// or more values (or elements).  Elements are separated by commas.
    ///
    ///  array = begin-array [ value *( value-separator value ) ] end-array
    ///
    /// There is no requirement that the values in an array be of the same
    /// type.
    String _handleArray() {
      // Identify an empty array ( 0 elements, allowed by the standard)
      if (restValue.startsWith('[') &&
          restValue.endsWith(']') &&
          restValue.length == 2) return '';

      String parsedArray = _parseEnclosure('[');

      if (parsedArray == 'invalid') return 'invalid';

      // Redefining commaIndex for the comma located after the last closing bracket
      commaIndex = restValue.indexOf(',', parsedArray.length);

      // Validate an array and return BOOL for its validity
      if (_validateArray(parsedArray)) {
        if (commaIndex == -1) {
          // Successfully verified array as last pair's value
          return '';
        } else {
          // If the array is valid, but there is remaining part after it - return it
          return restValue.substring(commaIndex + 1).trim();
        }
      } else {
        return 'invalid';
      }
    }

    // <<<<================================================================>>>>

    /// Getting the lead char of the provided restValue
    if (restValue.isEmpty) return '';
    String leadChar = restValue.trim().substring(0, 1);
    switch (leadChar) {
      case '"':
        result = _handleDQ();
        break;
      case '[':
        result = _handleArray();
        break;
      case '{':
        result = _handleObject();
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
        if (leadChar.isEmpty || leadChar == ',') {
          result = 'invalid';
          break;
        }
        result = _isNum();
        break;
    }
    return result;
  }
}
