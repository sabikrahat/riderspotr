import 'package:json_annotation/json_annotation.dart';

part 'user_simple_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserSimpleModel {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? profilePictureUrl;

  UserSimpleModel({
    required this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.profilePictureUrl,
  });

  factory UserSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$UserSimpleModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSimpleModelToJson(this);

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
