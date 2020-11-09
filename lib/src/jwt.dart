part of '../ivmjwt.dart';

/// Abstract JWT Token Class
///
/// The definition of JWT Token implementation
abstract class JWT extends Object {
  SegmentHeader header;
  Map<String, dynamic> payload;
  String signature;

  /// Registered claim names
  Map<String, dynamic> claim;

  /// Private claims to join the registered claim names;
  Map<String, dynamic> data;

  /// Create, RS256 sign and return new JWT
  void issueJWTRS256();

  /// Verify RS256 signed JWT. Unsigned token MUST NOT be verified.
  static void verifyJWTRS256() {
    // provide the JWT token String value
  }

  /// Signing the JWT with the used encryption method in the header
  void sign();
}

/// The JWT Header Definition
///
/// This class consider properties for signed JWT issued
/// as idTokens.
@JsonSerializable(nullable: false, includeIfNull: false)
class SegmentHeader {
  final String alg;
  final String typ;
  final String cty;
  final String kid;

  SegmentHeader({this.alg, this.typ, this.cty, this.kid});
  factory SegmentHeader.fromJson(Map<String, dynamic> json) =>
      _$HeaderFromJson(json);
  Map<String, dynamic> toJson() => _$HeaderToJson(this);
}

SegmentHeader _$HeaderFromJson(Map<String, dynamic> json) {
  return SegmentHeader(
      alg: json['alg'] as String,
      typ: json['typ'] as String,
      cty: json['cty'] as String,
      kid: json['kid'] as String);
}

Map<String, dynamic> _$HeaderToJson(SegmentHeader instance) =>
    <String, dynamic>{
      'alg': instance.alg,
      'typ': instance.typ,
      'cty': instance.cty,
      'kid': instance.kid,
    };
