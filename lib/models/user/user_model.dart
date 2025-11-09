import 'package:json_annotation/json_annotation.dart';
import 'package:ridespotr/models/user/user_stats_model.dart';
import 'package:ridespotr/models/user/achievement_model.dart';

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
  final String? country;
  final String? countryCode;
  final String? state;
  final String? profilePictureUrl;
  final String? bannerUrl;
  final DateTime createdAt;
  final bool isGaragePrivate;
  @JsonKey(includeToJson: false)
  final UserStatsModel? stats;
  @JsonKey(includeToJson: false)
  final List<AchievementModel>? achievements;

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
    this.country,
    this.countryCode,
    this.state,
    this.profilePictureUrl,
    this.bannerUrl,
    required this.createdAt,
    required this.isGaragePrivate,
    required this.stats,
    this.achievements,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  bool get isProfileComplete =>
      firstName != null && lastName != null && username != null && dob != null;
  bool get isExperienceComplete => knowledgeLevel != null && experience != null;
  bool get isLocationComplete =>
      address != null &&
      location != null &&
      country != null &&
      countryCode != null &&
      state != null;

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
    String? country,
    String? countryCode,
    String? state,
    String? profilePictureUrl,
    String? bannerUrl,
    DateTime? createdAt,
    bool? isGaragePrivate,
    UserStatsModel? stats,
    List<AchievementModel>? achievements,
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
    country: country ?? this.country,
    countryCode: countryCode ?? this.countryCode,
    state: state ?? this.state,
    profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    bannerUrl: bannerUrl ?? this.bannerUrl,
    createdAt: createdAt ?? this.createdAt,
    isGaragePrivate: isGaragePrivate ?? this.isGaragePrivate,
    stats: stats ?? this.stats,
    achievements: achievements ?? this.achievements,
  );

  String get fullName => "$firstName$lastName";

  static const query = '*, stats: user_stats(*), achievements: achievements(*)';
}
