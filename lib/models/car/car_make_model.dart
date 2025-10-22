import 'package:json_annotation/json_annotation.dart';

part 'car_make_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CarMakeModel {
  final String id;
  DateTime createdAt;
  String name;
  String logoUrl;

  CarMakeModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.logoUrl,
  });

  factory CarMakeModel.fromJson(Map<String, dynamic> json) => _$CarMakeModelFromJson(json);

  Map<String, dynamic> toJson() => _$CarMakeModelToJson(this);

  // Create a copy with method
  CarMakeModel copyWith({
    String? id,
    DateTime? createdAt,
    String? name,
    String? logoUrl,
  }) {
    return CarMakeModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
