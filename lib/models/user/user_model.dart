import 'package:json_annotation/json_annotation.dart';
import 'package:ridespotr/models/user/user_stats_model.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? username;
  final DateTime? dob;
  final String? measurement;
  final String? knowledgeLevel;
  final String? experience;
  final String? address;
  final Location? location;
  final String? profilePictureUrl;
  final String? bannerUrl;
  final DateTime createdAt;
  final bool isGaragePrivate;
  @JsonKey(includeToJson: false)
  final UserStatsModel? stats;

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
    this.profilePictureUrl,
    this.bannerUrl,
    required this.createdAt,
    required this.isGaragePrivate,
    required this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

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
    String? profilePictureUrl,
    String? bannerUrl,
    DateTime? createdAt,
    bool? isGaragePrivate,
    UserStatsModel? stats,
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
    profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    bannerUrl: bannerUrl ?? this.bannerUrl,
    createdAt: createdAt ?? this.createdAt,
    isGaragePrivate: isGaragePrivate ?? this.isGaragePrivate,
    stats: stats ?? this.stats,
  );

  String get fullName => "$firstName$lastName";

  static const query = '*, stats: user_stats(*)';
}
