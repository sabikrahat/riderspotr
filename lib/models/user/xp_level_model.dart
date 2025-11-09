import 'package:json_annotation/json_annotation.dart';

part 'xp_level_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class XpLevelModel {
  final int level;
  final int xpRequired;
  final int xpCumulative;

  XpLevelModel({
    required this.level,
    required this.xpRequired,
    required this.xpCumulative,
  });

  factory XpLevelModel.fromJson(Map<String, dynamic> json) =>
      _$XpLevelModelFromJson(json);

  Map<String, dynamic> toJson() => _$XpLevelModelToJson(this);
}
