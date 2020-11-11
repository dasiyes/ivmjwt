part of '../../ivmjwt.dart';

/// The JWT Header Definition
///
/// This class consider properties for signed JWT issued
/// as idTokens.
@JsonSerializable(nullable: false, includeIfNull: false)
class SegmentHeader {
  @JsonKey(nullable: false)
  final String alg;
  @JsonKey(nullable: true, includeIfNull: true)
  final String typ;
  @JsonKey(nullable: true, includeIfNull: false)
  final String cty;
  @JsonKey(nullable: true, includeIfNull: false)
  final String kid;

  SegmentHeader({this.alg, this.typ, this.cty, this.kid});
  factory SegmentHeader.fromJson(Map<String, dynamic> json) =>
      _$SegmentHeaderFromJson(json);
  Map<String, dynamic> toJson() => _$SegmentHeaderToJson(this);
}
