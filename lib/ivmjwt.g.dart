// GENERATED CODE - DO NOT MODIFY BY HAND

part of ivmjwt;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SegmentHeader _$SegmentHeaderFromJson(Map<String, dynamic> json) {
  return SegmentHeader(
    alg: json['alg'] as String,
    typ: json['typ'] as String,
    cty: json['cty'] as String,
    kid: json['kid'] as String,
  );
}

Map<String, dynamic> _$SegmentHeaderToJson(SegmentHeader instance) {
  final val = <String, dynamic>{
    'alg': instance.alg,
    'typ': instance.typ,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cty', instance.cty);
  writeNotNull('kid', instance.kid);
  return val;
}
