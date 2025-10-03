import 'dart:typed_data';

part 'user_model.ext.dart';

class UserModel {
  final String id;
  final String email;
  String? firstName;
  String? lastName;
  String? username;
  DateTime? dob;
  String? knowledgeLevel;
  String? experience;
  String? location;
  dynamic locationLatLng;
  DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.username,
    this.dob,
    this.knowledgeLevel,
    this.experience,
    this.location,
    this.locationLatLng,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[_Json.id] as String,
    email: json[_Json.email] as String,
    firstName: json[_Json.firstName] as String?,
    lastName: json[_Json.lastName] as String?,
    username: json[_Json.username] as String?,
    dob: json[_Json.dob] == null ? null : DateTime.parse(json[_Json.dob] as String).toLocal(),
    knowledgeLevel: json[_Json.knowledgeLevel] as String?,
    experience: json[_Json.experience] as String?,
    location: json[_Json.location] as String?,
    locationLatLng: json[_Json.locationLatLng]?.toString(),
    createdAt: DateTime.parse(json[_Json.createdAt] as String).toLocal(),
  );
}

class _Json {
  static const String id = 'id';
  static const String email = 'email';
  static const String firstName = 'first_name';
  static const String lastName = 'last_name';
  static const String username = 'username';
  static const String dob = 'dob';
  static const String knowledgeLevel = 'knowledge_level';
  static const String experience = 'experience';
  static const String location = 'location';
  static const String locationLatLng = 'location_lat_lng';
  static const String createdAt = 'created_at';
}
