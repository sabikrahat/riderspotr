import 'package:json_annotation/json_annotation.dart';

part 'user_leaderboard_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserLeaderboardModel {
  final String user;
  final int rank;
  final int totalXp;
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;

  UserLeaderboardModel({
    required this.user,
    required this.rank,
    required this.totalXp,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
  });

  factory UserLeaderboardModel.fromJson(Map<String, dynamic> json) =>
      _$UserLeaderboardModelFromJson(json);
}
