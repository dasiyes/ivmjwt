import 'package:ivmjwt/ivmjwt.dart';
import 'package:test/test.dart';

/// Test jvalid.dart initiation
///
/// Test class instantiation and validate() function initiation.
void testJValidInit() {
  /// Test validate function initiation with empty parameter.
  JsonValidator jv1 = JsonValidator("");
  bool jv_result1 = jv1.validate();
  expect(jv_result1, false);

  /// Test validate function initiation with empty ({}) json string).
  JsonValidator jv2 = JsonValidator("{}");
  bool jv_result2 = jv2.validate();
  expect(jv_result2, true);

  /// Test validate function initiation with simple json value param provided at class instantiation.
  JsonValidator jv3 = JsonValidator("{\"name\": \"test\", \"value\": 1}");
  bool jv_result3 = jv3.validate();
  expect(jv_result3, true);

  /// Test validate function initiation with simple json value param provided as direct validate() param.
  JsonValidator jv4 = JsonValidator("");
  bool jv_result4 = jv4.validate("{\"name\": \"test\", \"value\": 1}");
  expect(jv_result4, true);
}

/// Test jvalid.dart validate()
///
/// Test validation of the main use cases:
/// - key-value pair's two parts: 1) name (key) and 2) value
/// * name should be double quoted
/// * value can be:
///   - string
///   - number
///   - 3 literal names: **true**, **false** or **null**
/// * structural chars: ":", ",", "[", "]", "{", "}"
///
void testValidateFunctionMain() {
  /// Test the validation of the name(key) & value
  /// 1) valid name/key & value
  JsonValidator jv = JsonValidator("");
  bool result1 = jv.validate("{\"name\": \"test\", \"value\": 1}");
  expect(result1, true);

  /// invalid key/name missing leading qm
  bool result2 = jv.validate("{name\": \"test\"}");
  expect(result2, false);

  /// invalid string value missing trailing qm
  bool result6 = jv.validate("{\"name\": \"test}");
  expect(result6, false);

  /// invalid string value missing leading qm
  bool result3 = jv.validate("{\"name\": test\"}");
  expect(result3, false);

  /// 2) validating the 3 lietral vlaue: false, true and null

  /// valid 'false' value
  bool result4 = jv.validate("{\"name\": false}");
  expect(result4, true);

  /// invalid 'false' value
  bool result5 = jv.validate("{\"name\": false\"}");
  expect(result5, false);

  /// valid 'true' value
  bool result7 = jv.validate("{\"name\": true}");
  expect(result7, true);

  /// invalid 'true' value
  bool result8 = jv.validate("{\"name\": true\"}");
  expect(result8, false);

  /// valid 'null' value
  bool result9 = jv.validate("{\"name\": null}");
  expect(result9, true);

  /// invalid 'null' value
  bool result10 = jv.validate("{\"name\": null\"}");
  expect(result10, false);
}
