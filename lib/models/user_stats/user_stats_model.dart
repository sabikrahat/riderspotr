import 'package:json_annotation/json_annotation.dart';

import '../auth/user_model.dart';

part 'user_stats_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserStatsModel {
  final String id;
  UserModel? user;
  final int totalPoints;
  final int carSpots;

  UserStatsModel({
    required this.id,
    this.user,
    required this.totalPoints,
    required this.carSpots,
  });

  factory UserStatsModel.fromJson(Map<String, dynamic> json) => _$UserStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatsModelToJson(this);

  static const query = '*, user: id!inner(*)';

  UserStatsModel copyWith({
    String? id,
    UserModel? user,
    int? totalPoints,
    int? carSpots,
  }) {
    return UserStatsModel(
      id: id ?? this.id,
      user: user ?? this.user,
      totalPoints: totalPoints ?? this.totalPoints,
      carSpots: carSpots ?? this.carSpots,
    );
  }
}
