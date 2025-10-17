import 'package:json_annotation/json_annotation.dart';

part 'car_specs_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarSpecsModel {
  final String car;
  @JsonKey(name: 'acceleration_0_100')
  final double? acceleration0100;
  final int? topSpeedKmh;
  @JsonKey(name: 'quarter_mile_s')
  final double? quarterMiles;
  final int? powerKw;
  final String? configuration;
  @JsonKey(name: 'displacement_l')
  final double? displacementl;
  final double? torqueNm;
  final int? weightKg;

  CarSpecsModel({
    required this.car,
    this.acceleration0100,
    this.topSpeedKmh,
    this.quarterMiles,
    this.powerKw,
    this.configuration,
    this.displacementl,
    this.torqueNm,
    this.weightKg,
  });

  factory CarSpecsModel.fromJson(Map<String, dynamic> json) => _$CarSpecsModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarSpecsModelToJson(this);

  // Create a copy with method
  CarSpecsModel copyWith({
    String? car,
    double? acceleration0100,
    int? topSpeedKmh,
    double? quarterMiles,
    int? powerKw,
    String? configuration,
    double? displacementl,
    double? torqueNm,
    int? weightKg,
  }) {
    return CarSpecsModel(
      car: car ?? this.car,
      acceleration0100: acceleration0100 ?? this.acceleration0100,
      topSpeedKmh: topSpeedKmh ?? this.topSpeedKmh,
      quarterMiles: quarterMiles ?? this.quarterMiles,
      powerKw: powerKw ?? this.powerKw,
      configuration: configuration ?? this.configuration,
      displacementl: displacementl ?? this.displacementl,
      torqueNm: torqueNm ?? this.torqueNm,
      weightKg: weightKg ?? this.weightKg,
    );
  }
}
