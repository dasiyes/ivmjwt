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
  // TODO: Debug for all possible cases of convertion of aud from Srtring into a list;
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
    exp: jpld['exp'] as int,
    nbf: jpld['nbf'] as int,
    iat: jpld['iat'] as int,
    jti: jpld['jti'],
  );

  // Get the list of the object's properties
  List<String> spFields = Utilities.getObjectDefNames(sgp, 'fields');

  // Go over all json elements
  jpld.forEach((key, value) {
    // if the key is not in the current Object
    if (!spFields.contains(key)) {
      sgp.from({'$key': value.toString()});
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
