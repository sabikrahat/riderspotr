// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot_stat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotStatModel _$SpotStatModelFromJson(Map<String, dynamic> json) =>
    SpotStatModel(
      totalSpots: (json['total_spots'] as num).toInt(),
      todaysSpots: (json['todays_spots'] as num).toInt(),
      lastHourSpots: (json['last_hour_spots'] as num).toInt(),
    );

Map<String, dynamic> _$SpotStatModelToJson(SpotStatModel instance) =>
    <String, dynamic>{
      'total_spots': instance.totalSpots,
      'todays_spots': instance.todaysSpots,
      'last_hour_spots': instance.lastHourSpots,
    };
