import 'package:json_annotation/json_annotation.dart';

part 'achievement_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AchievementModel {
  final String id;
  final String name;
  final String type;
  final DateTime createdAt;
  final String user;

  AchievementModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.user,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);
}
