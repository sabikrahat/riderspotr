// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      id: json['id'] as String,
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      totalPoints: (json['total_points'] as num).toInt(),
      carSpots: (json['car_spots'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'total_points': instance.totalPoints,
      'car_spots': instance.carSpots,
    };
