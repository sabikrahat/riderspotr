// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_details_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDetailsResult _$PlaceDetailsResultFromJson(Map<String, dynamic> json) =>
    PlaceDetailsResult(
      addressComponents: (json['address_components'] as List<dynamic>?)
          ?.map((e) => AddressComponents.fromJson(e as Map<String, dynamic>))
          .toList(),
      adrAddress: json['adr_address'] as String?,
      formattedAddress: json['formatted_address'] as String?,
      geometry: json['geometry'] == null
          ? null
          : Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
      icon: json['icon'] as String?,
      iconBackgroundColor: json['icon_background_color'] as String?,
      iconMaskBaseUri: json['icon_mask_base_uri'] as String?,
      name: json['name'] as String?,
      photos: (json['photos'] as List<dynamic>?)
          ?.map((e) => Photos.fromJson(e as Map<String, dynamic>))
          .toList(),
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      url: json['url'] as String?,
      utcOffset: (json['utc_offset'] as num?)?.toInt(),
      vicinity: json['vicinity'] as String?,
    );

Map<String, dynamic> _$PlaceDetailsResultToJson(PlaceDetailsResult instance) =>
    <String, dynamic>{
      'address_components': instance.addressComponents,
      'adr_address': instance.adrAddress,
      'formatted_address': instance.formattedAddress,
      'geometry': instance.geometry,
      'icon': instance.icon,
      'icon_background_color': instance.iconBackgroundColor,
      'icon_mask_base_uri': instance.iconMaskBaseUri,
      'name': instance.name,
      'photos': instance.photos,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'types': instance.types,
      'url': instance.url,
      'utc_offset': instance.utcOffset,
      'vicinity': instance.vicinity,
    };

AddressComponents _$AddressComponentsFromJson(Map<String, dynamic> json) =>
    AddressComponents(
      longName: json['long_name'] as String?,
      shortName: json['short_name'] as String?,
      types: (json['types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AddressComponentsToJson(AddressComponents instance) =>
    <String, dynamic>{
      'long_name': instance.longName,
      'short_name': instance.shortName,
      'types': instance.types,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  viewport: json['viewport'] == null
      ? null
      : Viewport.fromJson(json['viewport'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
  'location': instance.location,
  'viewport': instance.viewport,
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
  lat: (json['lat'] as num?)?.toDouble(),
  lng: (json['lng'] as num?)?.toDouble(),
);

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
  'lat': instance.lat,
  'lng': instance.lng,
};

Viewport _$ViewportFromJson(Map<String, dynamic> json) => Viewport(
  northeast: json['northeast'] == null
      ? null
      : Location.fromJson(json['northeast'] as Map<String, dynamic>),
  southwest: json['southwest'] == null
      ? null
      : Location.fromJson(json['southwest'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ViewportToJson(Viewport instance) => <String, dynamic>{
  'northeast': instance.northeast,
  'southwest': instance.southwest,
};

Photos _$PhotosFromJson(Map<String, dynamic> json) => Photos(
  height: (json['height'] as num?)?.toInt(),
  htmlAttributions: (json['html_attributions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  photoReference: json['photo_reference'] as String?,
  width: (json['width'] as num?)?.toInt(),
);

Map<String, dynamic> _$PhotosToJson(Photos instance) => <String, dynamic>{
  'height': instance.height,
  'html_attributions': instance.htmlAttributions,
  'photo_reference': instance.photoReference,
  'width': instance.width,
};
