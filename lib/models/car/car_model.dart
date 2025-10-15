import 'package:json_annotation/json_annotation.dart';
import 'car_make_model.dart';

part 'car_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarModel {
  final String id;
  DateTime createdAt;
  String make;
  @JsonKey(fromJson: _makeExpandFromJson, toJson: _makeExpandToJson)
  CarMakeModel? makeExpand;
  String? model;
  String rarity;
  int points;
  String? description;

  CarModel({
    required this.id,
    required this.createdAt,
    required this.make,
    this.makeExpand,
    required this.model,
    required this.rarity,
    required this.points,
    this.description,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => _$CarModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarModelToJson(this);

  // Create a copy with method
  CarModel copyWith({
    String? id,
    DateTime? createdAt,
    String? make,
    CarMakeModel? makeExpand,
    String? model,
    String? rarity,
    int? points,
    String? description,
  }) {
    return CarModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      make: make ?? this.make,
      makeExpand: makeExpand ?? this.makeExpand,
      model: model ?? this.model,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      description: description ?? this.description,
    );
  }
}

// Converter functions for makeExpand
CarMakeModel? _makeExpandFromJson(dynamic json) {
  if (json == null) return null;
  if (json is Map<String, dynamic>) {
    return CarMakeModel.fromJson(json);
  }
  return null;
}

Map<String, dynamic>? _makeExpandToJson(CarMakeModel? makeExpand) {
  return makeExpand?.toJson();
}
