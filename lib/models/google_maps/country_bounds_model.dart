import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDetails {
  final String country;
  final String countryCode;
  final String state;

  LocationDetails({
    required this.country,
    required this.countryCode,
    required this.state,
  });
}

class CountryBounds {
  final LatLngBounds bounds;
  final String countryName;
  final String countryCode;

  CountryBounds({
    required this.bounds,
    required this.countryName,
    required this.countryCode,
  });

  @override
  String toString() {
    return 'CountryBounds(countryName: $countryName, countryCode: $countryCode, '
        'northeast: ${bounds.northeast}, southwest: ${bounds.southwest})';
  }
}

class StateBounds {
  final LatLngBounds bounds;
  final String stateName;
  final String countryCode;

  StateBounds({
    required this.bounds,
    required this.stateName,
    required this.countryCode,
  });

  @override
  String toString() {
    return 'StateBounds(stateName: $stateName, countryCode: $countryCode, '
        'northeast: ${bounds.northeast}, southwest: ${bounds.southwest})';
  }
}
