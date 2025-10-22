import 'package:json_annotation/json_annotation.dart';

part 'car_history_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarHistoryModel {
  final String car;
  final String? significance;
  final String? heritage;
  final List<String>? funFacts;
  final String? designerName;

  CarHistoryModel({
    required this.car,
    this.significance,
    this.heritage,
    this.funFacts,
    this.designerName,
  });

  factory CarHistoryModel.fromJson(Map<String, dynamic> json) => _$CarHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarHistoryModelToJson(this);

  // Create a copy with method
  CarHistoryModel copyWith({
    String? car,
    String? significance,
    String? heritage,
    List<String>? funFacts,
    String? designerName,
  }) {
    return CarHistoryModel(
      car: car ?? this.car,
      significance: significance ?? this.significance,
      heritage: heritage ?? this.heritage,
      funFacts: funFacts ?? this.funFacts,
      designerName: designerName ?? this.designerName,
    );
  }
}
