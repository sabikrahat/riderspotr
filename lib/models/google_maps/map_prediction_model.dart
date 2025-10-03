import 'package:json_annotation/json_annotation.dart';

part 'map_prediction_model.g.dart';

@JsonSerializable()
class MapPredictionModel {
  final String? description;
  final List<MatchedSubstrings>? matchedSubstrings;
  @JsonKey(name: 'place_id')
  final String? placeId;
  final String? reference;
  @JsonKey(name: 'structured_formatting')
  final StructuredFormatting? structuredFormatting;
  final List<Terms>? terms;
  final List<String>? types;
  final double? lat;
  final double? lng;

  const MapPredictionModel({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.lat,
    this.lng,
    this.types,
  });

  factory MapPredictionModel.fromJson(Map<String, dynamic> json) =>
      _$MapPredictionModelFromJson(json);

  Map<String, dynamic> toJson() => _$MapPredictionModelToJson(this);

  @override
  String toString() {
    return 'MapPredictionModel{description: $description, matchedSubstrings: $matchedSubstrings, placeId: $placeId, reference: $reference, structuredFormatting: $structuredFormatting, terms: $terms, types: $types, lat: $lat, lng: $lng}';
  }
}

@JsonSerializable()
class MatchedSubstrings {
  final int? length;
  final int? offset;

  const MatchedSubstrings({this.length, this.offset});

  factory MatchedSubstrings.fromJson(Map<String, dynamic> json) =>
      _$MatchedSubstringsFromJson(json);

  Map<String, dynamic> toJson() => _$MatchedSubstringsToJson(this);

  @override
  String toString() => 'MatchedSubstrings{length: $length, offset: $offset}';
}

@JsonSerializable()
class StructuredFormatting {
  @JsonKey(name: 'main_text')
  final String? mainText;
  @JsonKey(name: 'secondary_text')
  final String? secondaryText;

  const StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      _$StructuredFormattingFromJson(json);

  Map<String, dynamic> toJson() => _$StructuredFormattingToJson(this);

  @override
  String toString() =>
      'StructuredFormatting{mainText: $mainText, secondaryText: $secondaryText}';
}

@JsonSerializable()
class Terms {
  final int? offset;
  final String? value;

  const Terms({this.offset, this.value});

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsToJson(this);

  @override
  String toString() => 'Terms{offset: $offset, value: $value}';
}
