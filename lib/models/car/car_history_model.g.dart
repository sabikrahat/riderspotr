// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarHistoryModel _$CarHistoryModelFromJson(Map<String, dynamic> json) =>
    CarHistoryModel(
      car: json['car'] as String,
      significance: json['significance'] as String?,
      heritage: json['heritage'] as String?,
      funFacts: (json['fun_facts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      designerName: json['designer_name'] as String?,
    );

Map<String, dynamic> _$CarHistoryModelToJson(CarHistoryModel instance) =>
    <String, dynamic>{
      'car': instance.car,
      'significance': instance.significance,
      'heritage': instance.heritage,
      'fun_facts': instance.funFacts,
      'designer_name': instance.designerName,
    };
