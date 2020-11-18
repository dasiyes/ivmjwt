import 'package:ivmjwt/ivmjwt.dart';

String json1 =
    "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}]}";
String json2 =
    "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}], \"kvo\": 34}";
String json3 = "{\"arrayMain\": [1, \"false\", true, null, -5], \"kvo\": 34.4}";
String json4 = "{\"arrayMain\": [1, \"false\", true, null, -5]}";

Future main() async {
  JsonValidator jv = JsonValidator(json1);
  bool result = jv.validate();
  print('valid?: $result');
}
