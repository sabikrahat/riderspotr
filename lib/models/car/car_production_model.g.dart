// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_production_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarProductionModel _$CarProductionModelFromJson(Map<String, dynamic> json) =>
    CarProductionModel(
      car: json['car'] as String,
      yearStart: (json['year_start'] as num?)?.toInt(),
      yearEnd: (json['year_end'] as num?)?.toInt(),
      totalMade: (json['total_made'] as num?)?.toInt(),
      minValue: (json['min_value'] as num?)?.toInt(),
      maxValue: (json['max_value'] as num?)?.toInt(),
      circulationCount: (json['circulation_count'] as num?)?.toInt(),
      description: json['description'] as String?,
      msrp: (json['msrp'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CarProductionModelToJson(CarProductionModel instance) =>
    <String, dynamic>{
      'car': instance.car,
      'year_start': instance.yearStart,
      'year_end': instance.yearEnd,
      'total_made': instance.totalMade,
      'min_value': instance.minValue,
      'max_value': instance.maxValue,
      'circulation_count': instance.circulationCount,
      'description': instance.description,
      'msrp': instance.msrp,
    };
