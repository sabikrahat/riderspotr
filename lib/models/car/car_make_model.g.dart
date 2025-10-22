// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_make_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarMakeModel _$CarMakeModelFromJson(Map<String, dynamic> json) => CarMakeModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  name: json['name'] as String,
  logoUrl: json['logo_url'] as String,
);

Map<String, dynamic> _$CarMakeModelToJson(CarMakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'name': instance.name,
      'logo_url': instance.logoUrl,
    };
