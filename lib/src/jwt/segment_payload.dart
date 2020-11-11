part of '../../ivmjwt.dart';

/// The JWT Payload Definition
///
/// This class defines the JWT payload segment which includs all
/// optional registered claims.
///
class SegmentPayload implements RegisteredClaims {
  SegmentPayload(
      {this.iss, this.sub, this.aud, this.exp, this.nbf, this.iat, this.jti});

  // Private properties map init
  final _properties = new Map<String, Object>();

  from(Map<String, Object> initial) {
    initial.entries
        .forEach((element) => _properties[element.key] = element.value);
  }

  @override
  List<String> aud;

  @override
  int exp;

  @override
  int iat;

  @override
  String iss;

  @override
  String jti;

  @override
  int nbf;

  @override
  String sub;

  factory SegmentPayload.fromJson(Map<String, dynamic> json) =>
      _SegmentPayloadFromJson(json);
  Map<String, dynamic> toJson() => _SegmentPayloadToJson(this);

  noSuchMethod(Invocation invocation) {
    if (invocation.isAccessor) {
      final realName = MirrorSystem.getName(invocation.memberName);
      if (invocation.isSetter) {
        // for setter realname looks like "prop=" so we remove the "="
        final name = realName.substring(0, realName.length - 1);
        _properties[name] = invocation.positionalArguments.first;
        return;
      } else {
        return _properties[realName];
      }
    }
    return super.noSuchMethod(invocation);
  }
}

SegmentPayload _SegmentPayloadFromJson(Map<String, dynamic> jpld) {
  print('json: ${jpld}');

  // Converting aud vlue to a list
  List<String> audList = [];
  if ((jpld['aud'].toString().startsWith('['))) {
    audList = jpld['aud'] as List<String>;
  } else {
    audList.add(jpld['aud']);
  }

  // Instntiate the object
  SegmentPayload sgp = SegmentPayload(
    iss: jpld['iss'],
    sub: jpld['sub'],
    aud: audList,
    // aud: (jpld['aud'] as List)?.map((e) => e as String)?.toList(),
    exp: jpld['exp'] as int,
    nbf: jpld['nbf'] as int,
    iat: jpld['iat'] as int,
    jti: jpld['jti'],
  );

  List<String> spFields = Utilities.getObjectDefNames(sgp, 'fields');

  print('list of fields: $spFields');

  // Go over all json elements
  jpld.forEach((key, value) {
    // if the key is not in the current Object

    print('key: $key, value: $value');

    if (!spFields.contains(key)) {
      print('key $key is not in the spFields');
      print('value is from runningType: ${value.runtimeType}');

      String firstChar = value.toString().substring(0, 1);
      switch (firstChar) {
        case '[':
          sgp.from({'$key': (jpld['$key'] as List)});
          // [] = (jpld['$key'] as List)?.map((e) => e as String)?.toList();
          break;
        case '{':
          sgp.from({'$key': (jpld['$key'] as Map)});
          break;
        case '\"':
          sgp.from({'$key': value.toString()});
          break;
        default:
          switch (value) {
            case 'true':
              sgp.from({'$key': true});
              break;
            case 'false':
              sgp.from({'$key': false});
              break;
            case 'null':
              sgp.from({'$key': null});
              break;
            default:
              // sgp.from({'$key': num.parse(value)});
              sgp.from({'$key': value.toString()});
              break;
          }
          break;
      }
    }
  });

  return sgp;
}

Map<String, dynamic> _SegmentPayloadToJson(SegmentPayload instance) {
  final val = <String, dynamic>{};

  instance._properties.forEach((String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  });

  return val;
}
