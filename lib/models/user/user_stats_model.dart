import 'package:json_annotation/json_annotation.dart';

part 'user_stats_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserStatsModel {
  final String user;
  final int totalXp;
  final int xpToNextLevel;
  final double xpToNextLevelProgress;
  final int level;
  final int totalSpots;
  final int uniqueSpots;
  final int legendarySpots;
  final int spottingStreak;

  UserStatsModel({
    required this.user,
    required this.totalSpots,
    required this.totalXp,
    required this.xpToNextLevel,
    required this.xpToNextLevelProgress,
    required this.legendarySpots,
    required this.level,
    required this.uniqueSpots,
    required this.spottingStreak,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) =>
      _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  // UserStatsModel copyWith({
  //   String? id,
  //   UserModel? user,
  //   int? totalPoints,
  //   int? carSpots,
  // }) {
  //   return UserStatsModel(
  //     id: id ?? this.id,
  //     user: user ?? this.user,
  //     totalPoints: totalPoints ?? this.totalPoints,
  //     carSpots: carSpots ?? this.carSpots,
  //   );
  // }
}
