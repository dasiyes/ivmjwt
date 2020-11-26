part of '../../ivmjwt.dart';

/**
 * JOSE Header by [RFC7519]
   For a JWT object, the members of the JSON object represented by the
   JOSE Header describe the cryptographic operations applied to the JWT
   and optionally, additional properties of the JWT.  Depending upon
   whether the JWT is a JWS or JWE, the corresponding rules for the JOSE
   Header values apply.
   This specification further specifies the use of the following Header
   Parameters in both the cases where the JWT is a JWS and where it is a
   JWE.
*/
/// The JWT Header Definition
///
/// This class defines the JOSE Header properties
///
@JsonSerializable(nullable: false, includeIfNull: false)
class SegmentHeader {
  /**
   * The "typ" (type) Header Parameter defined by [JWS] RFC7515 and [JWE] RFC7516 
   * is used by JWT applications to declare the media type [IANA.MediaTypes] of
   * this complete JWT.
  */
  /**
   * The "cty" (content type) Header Parameter defined by [JWS] RFC7515 and 
   * [JWE] RFC7516 is used by this specification to convey structural 
   * information about the JWT.
   */
  /// Instantiating the SegmentHeader with optional properties
  ///
  SegmentHeader({this.alg, this.typ, this.cty, this.kid});

  /// Instantiating the SegmentHeader object from json object
  ///
  factory SegmentHeader.fromJson(Map<String, dynamic> json) =>
      _$SegmentHeaderFromJson(json);

  /// Converting the object instance back to json object
  ///
  Map<String, dynamic> toJson() => _$SegmentHeaderToJson(this);

  @JsonKey(nullable: false)
  final String alg;
  @JsonKey(nullable: true, includeIfNull: true)
  final String typ;
  @JsonKey(nullable: true, includeIfNull: false)
  final String cty;
  @JsonKey(nullable: true, includeIfNull: false)
  final String kid;
}
