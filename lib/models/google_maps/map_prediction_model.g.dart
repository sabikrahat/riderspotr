// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_prediction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapPredictionModel _$MapPredictionModelFromJson(Map<String, dynamic> json) =>
    MapPredictionModel(
      description: json['description'] as String?,
      matchedSubstrings: (json['matchedSubstrings'] as List<dynamic>?)
          ?.map((e) => MatchedSubstrings.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] == null
          ? null
          : StructuredFormatting.fromJson(
              json['structured_formatting'] as Map<String, dynamic>,
            ),
      terms: (json['terms'] as List<dynamic>?)
          ?.map((e) => Terms.fromJson(e as Map<String, dynamic>))
          .toList(),
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MapPredictionModelToJson(MapPredictionModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'matchedSubstrings': instance.matchedSubstrings,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'structured_formatting': instance.structuredFormatting,
      'terms': instance.terms,
      'types': instance.types,
      'lat': instance.lat,
      'lng': instance.lng,
    };

MatchedSubstrings _$MatchedSubstringsFromJson(Map<String, dynamic> json) =>
    MatchedSubstrings(
      length: (json['length'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MatchedSubstringsToJson(MatchedSubstrings instance) =>
    <String, dynamic>{'length': instance.length, 'offset': instance.offset};

StructuredFormatting _$StructuredFormattingFromJson(
  Map<String, dynamic> json,
) => StructuredFormatting(
  mainText: json['main_text'] as String?,
  secondaryText: json['secondary_text'] as String?,
);

Map<String, dynamic> _$StructuredFormattingToJson(
  StructuredFormatting instance,
) => <String, dynamic>{
  'main_text': instance.mainText,
  'secondary_text': instance.secondaryText,
};

Terms _$TermsFromJson(Map<String, dynamic> json) => Terms(
  offset: (json['offset'] as num?)?.toInt(),
  value: json['value'] as String?,
);

Map<String, dynamic> _$TermsToJson(Terms instance) => <String, dynamic>{
  'offset': instance.offset,
  'value': instance.value,
};
