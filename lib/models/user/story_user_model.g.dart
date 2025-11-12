// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoryUserModel _$StoryUserModelFromJson(Map<String, dynamic> json) =>
    StoryUserModel(
      id: json['id'] as String,
      username: json['username'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );

Map<String, dynamic> _$StoryUserModelToJson(StoryUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'profile_picture_url': instance.profilePictureUrl,
    };
