// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsModel _$UserStatsModelFromJson(Map<String, dynamic> json) =>
    UserStatsModel(
      user: json['user'] as String,
      totalSpots: (json['total_spots'] as num).toInt(),
      totalXp: (json['total_xp'] as num).toInt(),
      xpToNextLevel: (json['xp_to_next_level'] as num).toInt(),
      xpToNextLevelProgress: (json['xp_to_next_level_progress'] as num)
          .toDouble(),
      legendarySpots: (json['legendary_spots'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      uniqueSpots: (json['unique_spots'] as num).toInt(),
      spottingStreak: (json['spotting_streak'] as num).toInt(),
    );

Map<String, dynamic> _$UserStatsModelToJson(UserStatsModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'total_xp': instance.totalXp,
      'xp_to_next_level': instance.xpToNextLevel,
      'xp_to_next_level_progress': instance.xpToNextLevelProgress,
      'level': instance.level,
      'total_spots': instance.totalSpots,
      'unique_spots': instance.uniqueSpots,
      'legendary_spots': instance.legendarySpots,
      'spotting_streak': instance.spottingStreak,
    };
