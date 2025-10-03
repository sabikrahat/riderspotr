import 'package:json_annotation/json_annotation.dart';

part 'place_details_result.g.dart';

@JsonSerializable()
class PlaceDetailsResult {
  @JsonKey(name: 'address_components')
  final List<AddressComponents>? addressComponents;
  @JsonKey(name: 'adr_address')
  final String? adrAddress;
  @JsonKey(name: 'formatted_address')
  final String? formattedAddress;
  final Geometry? geometry;
  final String? icon;
  @JsonKey(name: 'icon_background_color')
  final String? iconBackgroundColor;
  @JsonKey(name: 'icon_mask_base_uri')
  final String? iconMaskBaseUri;
  final String? name;
  final List<Photos>? photos;
  @JsonKey(name: 'place_id')
  final String? placeId;
  final String? reference;
  final List<String>? types;
  final String? url;
  @JsonKey(name: 'utc_offset')
  final int? utcOffset;
  final String? vicinity;

  const PlaceDetailsResult({
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.name,
    this.photos,
    this.placeId,
    this.reference,
    this.types,
    this.url,
    this.utcOffset,
    this.vicinity,
  });

  factory PlaceDetailsResult.fromJson(Map<String, dynamic> json) =>
      _$PlaceDetailsResultFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDetailsResultToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class AddressComponents {
  @JsonKey(name: 'long_name')
  final String? longName;
  @JsonKey(name: 'short_name')
  final String? shortName;
  final List<String>? types;

  const AddressComponents({this.longName, this.shortName, this.types});

  factory AddressComponents.fromJson(Map<String, dynamic> json) =>
      _$AddressComponentsFromJson(json);

  Map<String, dynamic> toJson() => _$AddressComponentsToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Geometry {
  final Location? location;
  final Viewport? viewport;

  const Geometry({this.location, this.viewport});

  factory Geometry.fromJson(Map<String, dynamic> json) =>
      _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Location {
  final double? lat;
  final double? lng;

  const Location({this.lat, this.lng});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Viewport {
  final Location? northeast;
  final Location? southwest;

  const Viewport({this.northeast, this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) =>
      _$ViewportFromJson(json);

  Map<String, dynamic> toJson() => _$ViewportToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Photos {
  final int? height;
  @JsonKey(name: 'html_attributions')
  final List<String>? htmlAttributions;
  @JsonKey(name: 'photo_reference')
  final String? photoReference;
  final int? width;

  const Photos({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory Photos.fromJson(Map<String, dynamic> json) => _$PhotosFromJson(json);

  Map<String, dynamic> toJson() => _$PhotosToJson(this);

  @override
  String toString() => toJson().toString();
}
