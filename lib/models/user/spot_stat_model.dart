import 'package:json_annotation/json_annotation.dart';

part 'spot_stat_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpotStatModel {
  final int totalSpots;
  final int todaysSpots;
  final int lastHourSpots;

  SpotStatModel({
    required this.totalSpots,
    required this.todaysSpots,
    required this.lastHourSpots,
  });

  factory SpotStatModel.fromJson(Map<String, dynamic> json) =>
      _$SpotStatModelFromJson(json);

  Map<String, dynamic> toJson() => _$SpotStatModelToJson(this);
}

