// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  make: json['make'] == null
      ? null
      : CarMakeModel.fromJson(json['make'] as Map<String, dynamic>),
  model: json['model'] as String?,
  rarity: $enumDecode(_$RarityEnumMap, json['rarity']),
  points: (json['points'] as num).toInt(),
  description: json['description'] as String?,
  production: json['production'] == null
      ? null
      : CarProductionModel.fromJson(json['production'] as Map<String, dynamic>),
  specs: json['specs'] == null
      ? null
      : CarSpecsModel.fromJson(json['specs'] as Map<String, dynamic>),
  history: json['history'] == null
      ? null
      : CarHistoryModel.fromJson(json['history'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'make': instance.make,
  'model': instance.model,
  'rarity': _$RarityEnumMap[instance.rarity]!,
  'points': instance.points,
  'description': instance.description,
  'production': instance.production,
  'specs': instance.specs,
  'history': instance.history,
};

const _$RarityEnumMap = {
  Rarity.common: 'common',
  Rarity.uncommon: 'uncommon',
  Rarity.rare: 'rare',
  Rarity.epic: 'epic',
  Rarity.legendary: 'legendary',
  Rarity.mythic: 'mythic',
};
