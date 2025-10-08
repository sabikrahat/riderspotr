import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id;
  final String email;
  String? firstName;
  String? lastName;
  String? username;
  DateTime? dob;
  String? measurement;
  String? knowledgeLevel;
  String? experience;
  String? address;
  Location? location;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.dob,
    this.measurement,
    this.knowledgeLevel,
    this.experience,
    this.address,
    this.location,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isProfileComplete =>
      firstName != null && lastName != null && username != null && dob != null;
  bool get isExperienceComplete => knowledgeLevel != null && experience != null;
  bool get isLocationComplete => address != null && location != null;

  // Create a copy with method
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    DateTime? dob,
    String? measurement,
    String? knowledgeLevel,
    String? experience,
    String? address,
    Location? location,
  }) => UserModel(
    id: id,
    email: email,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    username: username ?? this.username,
    dob: dob ?? this.dob,
    measurement: measurement ?? this.measurement,
    knowledgeLevel: knowledgeLevel ?? this.knowledgeLevel,
    experience: experience ?? this.experience,
    location: location ?? this.location,
    address: address ?? this.address,
    createdAt: createdAt,
  );

  // factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
  //   id: json[_Json.id] as String,
  //   email: json[_Json.email] as String,
  //   firstName: json[_Json.firstName] as String?,
  //   lastName: json[_Json.lastName] as String?,
  //   username: json[_Json.username] as String?,
  //   dob: json[_Json.dob] == null
  //       ? null
  //       : DateTime.parse(json[_Json.dob] as String).toLocal(),
  //   knowledgeLevel: json[_Json.knowledgeLevel] as String?,
  //   experience: json[_Json.experience] as String?,
  //   location: json[_Json.location] as String?,
  //   locationLatLng: json[_Json.locationLatLng]?.toString(),
  //   createdAt: DateTime.parse(json[_Json.createdAt] as String).toLocal(),
  // );
}

// class _Json {
//   static const String id = 'id';
//   static const String email = 'email';
//   static const String firstName = 'first_name';
//   static const String lastName = 'last_name';
//   static const String username = 'username';
//   static const String dob = 'dob';
//   static const String knowledgeLevel = 'knowledge_level';
//   static const String experience = 'experience';
//   static const String location = 'location';
//   static const String locationLatLng = 'location_lat_lng';
//   static const String createdAt = 'created_at';
// }
