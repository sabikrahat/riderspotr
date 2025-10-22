// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_specs_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarSpecsModel _$CarSpecsModelFromJson(Map<String, dynamic> json) =>
    CarSpecsModel(
      car: json['car'] as String,
      acceleration0100: (json['acceleration_0_100'] as num?)?.toDouble(),
      topSpeedKmh: (json['top_speed_kmh'] as num?)?.toInt(),
      quarterMiles: (json['quarter_mile_s'] as num?)?.toDouble(),
      powerKw: (json['power_kw'] as num?)?.toInt(),
      configuration: json['configuration'] as String?,
      displacementl: (json['displacement_l'] as num?)?.toDouble(),
      torqueNm: (json['torque_nm'] as num?)?.toDouble(),
      weightKg: (json['weight_kg'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CarSpecsModelToJson(CarSpecsModel instance) =>
    <String, dynamic>{
      'car': instance.car,
      'acceleration_0_100': instance.acceleration0100,
      'top_speed_kmh': instance.topSpeedKmh,
      'quarter_mile_s': instance.quarterMiles,
      'power_kw': instance.powerKw,
      'configuration': instance.configuration,
      'displacement_l': instance.displacementl,
      'torque_nm': instance.torqueNm,
      'weight_kg': instance.weightKg,
    };
