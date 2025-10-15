// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  make: json['make'] as String,
  makeExpand: _makeExpandFromJson(json['make_expand']),
  model: json['model'] as String?,
  rarity: json['rarity'] as String,
  points: (json['points'] as num).toInt(),
  description: json['description'] as String?,
);

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt.toIso8601String(),
  'make': instance.make,
  'make_expand': _makeExpandToJson(instance.makeExpand),
  'model': instance.model,
  'rarity': instance.rarity,
  'points': instance.points,
  'description': instance.description,
};
