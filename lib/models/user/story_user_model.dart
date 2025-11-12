import 'package:json_annotation/json_annotation.dart';

part 'story_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StoryUserModel {
  final String id;
  final String? username;
  final String? profilePictureUrl;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool hasRecentSpot;

  StoryUserModel({
    required this.id,
    this.username,
    this.profilePictureUrl,
    this.hasRecentSpot = false,
  });

  factory StoryUserModel.fromJson(Map<String, dynamic> json) =>
      _$StoryUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoryUserModelToJson(this);

  // Copy with method for adding hasRecentSpot flag
  StoryUserModel copyWith({
    String? id,
    String? username,
    String? profilePictureUrl,
    bool? hasRecentSpot,
  }) {
    return StoryUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      hasRecentSpot: hasRecentSpot ?? this.hasRecentSpot,
    );
  }
}
