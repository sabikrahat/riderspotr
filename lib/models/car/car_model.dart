import 'package:json_annotation/json_annotation.dart';
import 'package:ridespotr/core/enums.dart';

import 'car_history_model.dart';
import 'car_make_model.dart';
import 'car_production_model.dart';
import 'car_specs_model.dart';

part 'car_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarModel {
  final String id;
  DateTime createdAt;
  CarMakeModel? make;
  String? model;
  Rarity rarity;
  int points;
  String? description;
  //
  CarProductionModel? production;
  CarSpecsModel? specs;
  CarHistoryModel? history;

  CarModel({
    required this.id,
    required this.createdAt,
    required this.make,
    required this.model,
    required this.rarity,
    required this.points,
    this.description,
    this.production,
    this.specs,
    this.history,
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
    Rarity? rarity,
    int? points,
    String? description,
    CarProductionModel? production,
    CarSpecsModel? specs,
    CarHistoryModel? history,
  }) {
    return CarModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      make: make ?? this.make,
      model: model ?? this.model,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      description: description ?? this.description,
      production: production ?? this.production,
      specs: specs ?? this.specs,
      history: history ?? this.history,
    );
  }
}
