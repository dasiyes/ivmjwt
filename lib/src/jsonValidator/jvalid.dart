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
    bool _isAnArray = false;
    String tokens;
    String firstPairName;
    String firstPairValue;
    String valueStartsWith;
    String retValue;
    String spc = _getSuroundingChars(value.trim());

    // Remove the object's lead and closing chars or not
    // depending on the surounding chars
    if (spc == '[]') {
      tokens = _getValueObject(value);
      print('[_getValueObject result]: tokens to evaluate: $tokens');
    }

    // IMPORTANT!!! Do not join with the upper IF statement!!!
    if (spc == '{}') {
      tokens = value.trim().substring(1, value.length - 1);
      print('[_validateFirstKeyValuePair {}]: tokens to evaluate: $tokens');
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
      print(
          'firstPairName: $firstPairName, _getValueObject param: ${tokens.substring(colonIndex + 1).trim()}');
      firstPairValue = _getValueObject(tokens.substring(colonIndex + 1).trim());

      // If the value part starts with '[' the value may be a valid ARRAY and the commaIndex needs to be redefined
      if (valueStartsWith == '[') {
        _isAnArray = true;
      }
      print('firstPairValue: $firstPairValue');
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
      } else if (spc == '[]') {
        print('[ret value from [] ] - ${tokens.substring(commaIndex + 1)}');
        print('retValue: $retValue');
      }
      print('step-3 compose retValue: $retValue');
      return retValue;
    } else if (_validPairName && _validPairValue && _isAnArray) {
      if (firstPairValue.isEmpty) {
        retValue = '';
      } else {
        retValue = '{$firstPairValue}';
      }
      print('retValue: $retValue');
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

      return {"oil": openingArrayIndexes, "cil": closingArrayIndexes};
    }

    /// Validate single ARRAY
    ///
    String _validateSingleArray(int openBraketIndex, int closingBraketIndex) {
      //TODO: re-work the entire parsing logic below.
      List array = restValue
          .substring(openBraketIndex + 1, closingBraketIndex)
          .trim()
          .split(',');
      int i = 0;
      String retval = '';
      String evaString = '';

      print(
          'the array extracted: ${restValue.substring(openBraketIndex + 1, closingBraketIndex)}');

      do {
        print('value to validate: ${array[i]}');
        if (array[i].toString().trim().isEmpty) {
          retval = 'invalid';
          break;
        }
        if (array[i].toString().trim().startsWith('{') ||
            array[i].toString().trim().startsWith('[')) {
          // Rmove leading braket
          evaString = array[i].toString().substring(1);
        } else if (array[i].toString().trim().endsWith('}') ||
            array[i].toString().trim().endsWith(']')) {
          evaString =
              array[i].toString().substring(0, array[i].toString().length - 1);
        }
        print('transformed value to validate: ${evaString}');

        retval = _getValueObject(evaString);
        print('retval: $retval');
        if (retval == 'invalid') {
          break;
        }
        i++;
      } while (i < array.length);

      // On exit of the cycle do check the value to return
      if (retval == 'invalid') {
        return retval;
      } else {
        return restValue;
      }
    }

    /// verify for numbers
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

    /// handle True, False and Null values
    ///
    String _handleTFN() {
      if (commaIndex == -1) {
        result = restValue;
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
    /// Arrays
    /// An array structure is represented as square brackets surrounding zero
    /// or more values (or elements).  Elements are separated by commas.
    ///
    ///  array = begin-array [ value *( value-separator value ) ] end-array
    ///
    /// There is no requirement that the values in an array be of the same
    /// type.
    String _handleNested({@required oBraket, @required cBraket}) {
      bool validatedObj = false;

      // Calculate enclosures
      Map<String, List<int>> _indexesMap =
          _calculateEnclosures(oBraket: oBraket, cBraket: cBraket);
      List<int> openningIndexes = _indexesMap['oil'];
      List<int> closingIndexes = _indexesMap['cil'];

      print(
          'opening: ${openningIndexes.length}; closing: ${closingIndexes.length}');

      // Invalid (asymetric) enclosure case
      if (openningIndexes.length != closingIndexes.length) {
        return 'invalid';
      }

      // Redefining commaIndex for the comma located after the last closing tag
      commaIndex =
          restValue.indexOf(',', closingIndexes[closingIndexes.length - 2]);

      // Validate a single array object
      if ('$oBraket$cBraket' == '[]') {
        int enclosureLevels = openningIndexes.length - 1;
        String rsl;
        rsl = _validateSingleArray(
            openningIndexes[0], closingIndexes[enclosureLevels - 1]);

        print('validate single Array result: $rsl');
        if (rsl == 'invalid') return rsl;

        if (commaIndex == -1) {
          // Successfully verified single array
          return '';
        } else {
          String obj = restValue.substring(commaIndex + 1).trim();
          print('[_validateSingleArray] NOT Last token rest value: $obj');
          return obj;
        }
      } else if ('$oBraket$cBraket' == '{}') {
        if (commaIndex == -1) {
          validatedObj = _validateNameValuePair(restValue.trim());
          print(
              'validating restValue: $restValue | validated result: $validatedObj');
          if (validatedObj) {
            return restValue;
          } else {
            return 'invalid';
          }
          // Not the last token in the string
        } else {
          // there is more tokens after the object
          String obj = restValue.substring(0, commaIndex);
          print('value to send: $obj');
          validatedObj = _validateNameValuePair(obj.trim());
          print(
              'validating restValue: $restValue | validated result: $validatedObj');
          if (validatedObj) {
            return obj;
          } else {
            return 'invalid';
          }
        }
      } else {
        return 'invalid';
      }

      // Validate json (map-{}) object
    }
    // <<<<================================================================>>>>

    /// Getting the lead char of the provided restValue
    String leadChar = restValue.trim().substring(0, 1);
    switch (leadChar) {
      case '"':
        result = _handleDQ();
        break;
      case '[':
        result = _handleNested(oBraket: '[', cBraket: ']');
        print('[_handleNested-[] ] $result');
        break;
      case '{':
        result = _handleNested(oBraket: '{', cBraket: '}');
        print('[_handleNested-{} ] $result');
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
