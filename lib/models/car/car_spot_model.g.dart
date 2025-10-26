// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_spot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarSpotModel _$CarSpotModelFromJson(Map<String, dynamic> json) => CarSpotModel(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  user: json['user'] as String,
  car: json['car'] == null
      ? null
      : CarModel.fromJson(json['car'] as Map<String, dynamic>),
  imageUrl: json['image_url'] as String,
  latLng: json['lat_lng'],
  location: json['location'] as Map<String, dynamic>?,
  address: json['address'] as String,
  isClaimed: json['is_claimed'] as bool,
);

Map<String, dynamic> _$CarSpotModelToJson(CarSpotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt.toIso8601String(),
      'user': instance.user,
      'car': instance.car,
      'image_url': instance.imageUrl,
      'lat_lng': instance.latLng,
      'address': instance.address,
      'location': instance.location,
      'is_claimed': instance.isClaimed,
    };
