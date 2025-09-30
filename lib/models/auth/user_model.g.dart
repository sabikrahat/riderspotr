// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  username: json['username'] as String?,
  dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
  knowledgeLevel: json['knowledge_level'] as String?,
  experience: json['experience'] as String?,
  location: json['location'] as String?,
  locationLatLng: json['location_lat_lng'],
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'username': instance.username,
  'dob': instance.dob?.toIso8601String(),
  'knowledge_level': instance.knowledgeLevel,
  'experience': instance.experience,
  'location': instance.location,
  'location_lat_lng': instance.locationLatLng,
  'created_at': instance.createdAt.toIso8601String(),
};
