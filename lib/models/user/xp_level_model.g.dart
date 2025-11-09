// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_level_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

XpLevelModel _$XpLevelModelFromJson(Map<String, dynamic> json) => XpLevelModel(
  level: (json['level'] as num).toInt(),
  xpRequired: (json['xp_required'] as num).toInt(),
  xpCumulative: (json['xp_cumulative'] as num).toInt(),
);

Map<String, dynamic> _$XpLevelModelToJson(XpLevelModel instance) =>
    <String, dynamic>{
      'level': instance.level,
      'xp_required': instance.xpRequired,
      'xp_cumulative': instance.xpCumulative,
    };
