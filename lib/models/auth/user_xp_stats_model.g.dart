// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_xp_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserXPStatsModel _$UserXPStatsModelFromJson(Map<String, dynamic> json) =>
    UserXPStatsModel(
      user: json['user'] as String,
      totalXp: (json['total_xp'] as num).toDouble(),
      xpToNextLevel: (json['xp_to_next_level'] as num).toDouble(),
      xpToNextLevelProgress: (json['xp_to_next_level_progress'] as num)
          .toDouble(),
      level: (json['level'] as num).toInt(),
    );

Map<String, dynamic> _$UserXPStatsModelToJson(UserXPStatsModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'total_xp': instance.totalXp,
      'xp_to_next_level': instance.xpToNextLevel,
      'xp_to_next_level_progress': instance.xpToNextLevelProgress,
      'level': instance.level,
    };
