// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  username: json['username'] as String?,
  dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
  measurement: json['measurement'] as String?,
  knowledgeLevel: json['knowledge_level'] as String?,
  experience: json['experience'] as String?,
  address: json['address'] as String?,
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  country: json['country'] as String?,
  countryCode: json['country_code'] as String?,
  state: json['state'] as String?,
  profilePictureUrl: json['profile_picture_url'] as String?,
  bannerUrl: json['banner_url'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  isGaragePrivate: json['is_garage_private'] as bool,
  stats: json['stats'] == null
      ? null
      : UserStatsModel.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'username': instance.username,
  'dob': instance.dob?.toIso8601String(),
  'measurement': instance.measurement,
  'knowledge_level': instance.knowledgeLevel,
  'experience': instance.experience,
  'address': instance.address,
  'location': instance.location,
  'country': instance.country,
  'country_code': instance.countryCode,
  'state': instance.state,
  'profile_picture_url': instance.profilePictureUrl,
  'banner_url': instance.bannerUrl,
  'created_at': instance.createdAt.toIso8601String(),
  'is_garage_private': instance.isGaragePrivate,
};
