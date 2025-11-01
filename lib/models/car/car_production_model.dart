import 'package:json_annotation/json_annotation.dart';

part 'car_production_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarProductionModel {
  final String car;
  final int? yearStart;
  final int? yearEnd;
  final int? totalMade;
  final int? minValue;
  final int? maxValue;
  final int? circulationCount;
  final String? description;
  final int? msrp;

  CarProductionModel({
    required this.car,
    this.yearStart,
    this.yearEnd,
    this.totalMade,
    this.minValue,
    this.maxValue,
    this.circulationCount,
    this.description,
    this.msrp,
  });

  factory CarProductionModel.fromJson(Map<String, dynamic> json) =>
      _$CarProductionModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarProductionModelToJson(this);

  // Create a copy with method
  CarProductionModel copyWith({
    String? car,
    int? yearStart,
    int? yearEnd,
    int? totalMade,
    int? minValue,
    int? maxValue,
    int? circulationCount,
    String? description,
    int? msrp,
  }) {
    return CarProductionModel(
      car: car ?? this.car,
      yearStart: yearStart ?? this.yearStart,
      yearEnd: yearEnd ?? this.yearEnd,
      totalMade: totalMade ?? this.totalMade,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
      circulationCount: circulationCount ?? this.circulationCount,
      description: description ?? this.description,
      msrp: msrp ?? this.msrp,
    );
  }
}
