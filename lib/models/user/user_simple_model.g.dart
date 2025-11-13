// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_simple_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSimpleModel _$UserSimpleModelFromJson(Map<String, dynamic> json) =>
    UserSimpleModel(
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      username: json['username'] as String?,
      profilePictureUrl: json['profile_picture_url'] as String?,
    );

Map<String, dynamic> _$UserSimpleModelToJson(UserSimpleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'username': instance.username,
      'profile_picture_url': instance.profilePictureUrl,
    };
