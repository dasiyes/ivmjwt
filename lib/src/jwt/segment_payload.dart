part of '../../ivmjwt.dart';

/*
  * JWT Claims Set by [RFC7519]:
      A JSON object that contains the claims conveyed by the JWT.
  * Claim
      A piece of information asserted about a subject.  A claim is
      represented as a name/value pair consisting of a Claim Name and a
      Claim Value. 
*/
/// JWT's Claims Set
///
/// This call instance will be used to bring the token's claims
/// according to the standard RFC7519.
/// It also implements the standard`s registered claims.
class SegmentPayload implements RegisteredClaims {
  /*
   * JSON Web Token (JWT) Overview by [RFC7519]:
   JWTs represent a set of claims as a JSON object that is encoded in a
   JWS and/or JWE structure.  This JSON object is the JWT Claims Set.
   As per Section 4 of RFC 7159 [RFC7159]:, the JSON object consists of
   zero or more name/value pairs (or members), where the names are
   strings and the values are arbitrary JSON values.  These members are
   the claims represented by the JWT.  This JSON object MAY contain
   whitespace and/or line breaks before or after any JSON values or
   structural characters, in accordance with Section 2 of RFC 7159
   [RFC7159]:.
  */
  /// Instantiate the Claims Set with optional registered claims
  ///
  SegmentPayload(
      {this.iss, this.sub, this.aud, this.exp, this.nbf, this.iat, this.jti});

  /// Instantiate the Claims Set from a json object.
  ///
  factory SegmentPayload.fromJson(Map<String, dynamic> json) =>
      _SegmentPayloadFromJson(json);

  /// Converts the SegmentPayload object back to a json
  ///
  Map<String, dynamic> toJson() => _SegmentPayloadToJson(this);

  void _fromElement(Map<String, Object> initial) {
    initial.entries
        .forEach((element) => _properties[element.key] = element.value);
  }

  /// Private properties map. Used for adding custom object properties.
  ///
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

  /// Customizing the class to support any custom fields/kyes in the claims set
  ///
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

/// Instantiate SegmentPayload object from a json object
///
//  ignore: non_constant_identifier_names
SegmentPayload _SegmentPayloadFromJson(Map<String, dynamic> jpld) {
  // Converting aud value to a list
  var audList = <String>[];
  if (jpld['aud'].toString().startsWith('[')) {
    audList = jpld['aud'] as List<String>;
  } else {
    audList.add(jpld['aud'].toString());
  }

  // Calculating exp from maxAge or
  // if exists - verify if its value is in the future
  if (jpld['maxAge'] != null) {
    try {
      final ma = int.parse(jpld['maxAge'].toString());
      jpld['exp'] = Utilities.currentTimeInSMS() + ma;
    } catch (e) {
      jpld['exp'] = Utilities.currentTimeInSMS() + 3600;
    }
  } else {
    if (jpld['exp'] == null) {
      jpld['exp'] = Utilities.currentTimeInSMS() + 3600;
    }
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
      sgp._fromElement({'$key': value.toString()});
    } else {
      sgp._fromElement({'$key': value});
    }
  });

  return sgp;
}

/// Converts the SegmentPayload object back to a json
///
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
