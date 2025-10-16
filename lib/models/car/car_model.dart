import 'package:json_annotation/json_annotation.dart';

import 'car_make_model.dart';

part 'car_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarModel {
  final String id;
  DateTime createdAt;
  CarMakeModel? make;
  String? model;
  String rarity;
  int points;
  String? description;

  CarModel({
    required this.id,
    required this.createdAt,
    required this.make,
    required this.model,
    required this.rarity,
    required this.points,
    this.description,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

  // Create a copy with method
  CarModel copyWith({
    String? id,
    DateTime? createdAt,
    CarMakeModel? make,
    String? model,
    String? rarity,
    int? points,
    String? description,
  }) {
    return CarModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      make: make ?? this.make,
      model: model ?? this.model,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      description: description ?? this.description,
    );
  }
}
