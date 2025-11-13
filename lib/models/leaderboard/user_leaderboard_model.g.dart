// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_leaderboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLeaderboardModel _$UserLeaderboardModelFromJson(
  Map<String, dynamic> json,
) => UserLeaderboardModel(
  user: json['user'] as String,
  rank: (json['rank'] as num).toInt(),
  totalXp: (json['total_xp'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  username: json['username'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
);

Map<String, dynamic> _$UserLeaderboardModelToJson(
  UserLeaderboardModel instance,
) => <String, dynamic>{
  'user': instance.user,
  'rank': instance.rank,
  'total_xp': instance.totalXp,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'username': instance.username,
  'profile_picture_url': instance.profilePictureUrl,
};
