part of '../../ivmjwt.dart';

/// The JWT Payload Definition
///
/// This class defines the JWT payload segment which includs all
/// optional registered claims.
///
class SegmentPayload implements RegisteredClaims {
  SegmentPayload(
      {this.iss, this.sub, this.aud, this.exp, this.nbf, this.iat, this.jti});

  factory SegmentPayload.fromJson(Map<String, dynamic> json) =>
      _SegmentPayloadFromJson(json);
  Map<String, dynamic> toJson() => _SegmentPayloadToJson(this);

  void fromElement(Map<String, Object> initial) {
    initial.entries
        .forEach((element) => _properties[element.key] = element.value);
  }

  // Private properties map init
  final _properties = <String, Object>{};

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

  /// Customizing the class to support any custom fields/kyes in the payload
  @override
  dynamic noSuchMethod(Invocation invocation) {
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

// ignore: non_constant_identifier_names
SegmentPayload _SegmentPayloadFromJson(Map<String, dynamic> jpld) {
  // TODO: [dev] Debug for all possible cases of convertion of aud from Srtring into a list;
  // Converting aud value to a list
  var audList = <String>[];
  if (jpld['aud'].toString().startsWith('[')) {
    audList = jpld['aud'] as List<String>;
  } else {
    audList.add(jpld['aud'].toString());
  }

  // Instntiate the object
  final sgp = SegmentPayload(
    iss: jpld['iss'].toString(),
    sub: jpld['sub'].toString(),
    aud: audList,
    exp: jpld['exp'] as int,
    nbf: jpld['nbf'] as int,
    iat: jpld['iat'] as int,
    jti: jpld['jti'].toString(),
  );

  // Get the list of the object's properties
  final spFields = Utilities.getObjectDefNames(sgp, 'fields');

  // Go over all json elements
  jpld.forEach((key, value) {
    // if the key is not in the current Object
    if (!spFields.contains(key)) {
      sgp.fromElement({'$key': value.toString()});
    }
  });

  return sgp;
}

// ignore: non_constant_identifier_names
Map<String, dynamic> _SegmentPayloadToJson(SegmentPayload instance) {
  final val = <String, dynamic>{};

  instance._properties.forEach((String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  });

  return val;
}
