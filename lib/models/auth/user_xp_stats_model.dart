import 'package:json_annotation/json_annotation.dart';

part 'user_xp_stats_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserXPStatsModel {
  final String user;
  double totalXp;
  double xpToNextLevel;
  double xpToNextLevelProgress;
  int level;

  UserXPStatsModel({
    required this.user,
    required this.totalXp,
    required this.xpToNextLevel,
    required this.xpToNextLevelProgress,
    required this.level,
  });

  factory UserXPStatsModel.fromJson(Map<String, dynamic> json) => _$UserXPStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserXPStatsModelToJson(this);

  // Create a copy with method
  UserXPStatsModel copyWith({
    String? user,
    double? totalXp,
    double? xpToNextLevel,
    double? xpToNextLevelProgress,
    int? level,
  }) {
    return UserXPStatsModel(
      user: user ?? this.user,
      totalXp: totalXp ?? this.totalXp,
      xpToNextLevel: xpToNextLevel ?? this.xpToNextLevel,
      xpToNextLevelProgress: xpToNextLevelProgress ?? this.xpToNextLevelProgress,
      level: level ?? this.level,
    );
  }
}
