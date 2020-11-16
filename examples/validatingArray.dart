import 'package:ivmjwt/ivmjwt.dart';

String json1 =
    "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}]}";
String json2 =
    "{\"nameMain\": \"test\", \"arrayMain\": [{\"name\": \"obj-1\", \"name2\": \"obj-2\"}, {\"array\": [1,2,4]}, {\"name3\": -3}], \"kvo\": 34}";

Future main() async {
  JsonValidator jv = JsonValidator(json2);
  bool result = jv.validate();
  print('valid?: $result');
}
