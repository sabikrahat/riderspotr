import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants.dart';
import '../../models/google_maps/country_bounds_model.dart';
import '../../models/google_maps/map_prediction_model.dart';
import '../../models/google_maps/place_details_result.dart';
import '../../models/user/user_model.dart' as user_model;

class GoogleMapsService {
  final String _apiKey = googleMapKey;
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<PlaceDetailsResult?> getLocationBasedOnPlaceId(String place) async {
    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: 'maps/api/place/details/json',
        queryParameters: {
          'placeid': place,
          'key': _apiKey,
          'language': 'en',
          'fields': 'formatted_address,name,geometry,address_components',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = PlaceDetailsResult.fromJson(data['result']);
      return location;
    }
    return null;
  }

  Future<PlaceDetailsResult?> getLocationBasedOnLatLng(LatLng latLng) async {
    final response = await http.get(
      Uri(
        scheme: 'https',
        host: 'maps.googleapis.com',
        path: 'maps/api/geocode/json',
        queryParameters: {
          'latlng': '${latLng.latitude},${latLng.longitude}',
          'key': _apiKey,
          'language': 'en',
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final location = PlaceDetailsResult.fromJson(data['results'][0]);
      return location;
    }
    return null;
  }

  Future<List<MapPredictionModel>> getLocations(String address) async {
    if (address.isEmpty || address.length < 3) return [];

    try {
      final response = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/place/autocomplete/json',
          queryParameters: {
            'input': address,
            'region': 'au',
            'key': _apiKey,
            'components': 'country:au',
            'language': 'en',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final places =
            (data['predictions'] as List)
                .map((e) => MapPredictionModel.fromJson(e))
                .toList()
              ..removeWhere((element) => element.placeId == 'null');
        return places;
      } else {
        return [];
      }
    } on PlatformException {
      return [];
    }
  }

  /// Gets the bounding box for the country based on user's location
  /// Queries the users table and uses Google Maps API to get country bounds
  Future<CountryBounds?> getCountryBoundsFromUserLocation([
    String? userId,
  ]) async {
    try {
      // 1. Query the users table to get the user's location
      final uid = userId ?? _supabase.auth.currentUser?.id;
      if (uid == null) return null;

      final userResponse = await _supabase
          .from(usersTbl)
          .select('location')
          .eq('id', uid)
          .maybeSingle();

      if (userResponse == null || userResponse['location'] == null) {
        return null;
      }

      final location = user_model.Location.fromJson(userResponse['location']);
      final latLng = LatLng(location.latitude, location.longitude);

      // 2. Reverse geocode to get the country information
      final reverseGeocodeResponse = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${latLng.latitude},${latLng.longitude}',
            'key': _apiKey,
            'language': 'en',
            'result_type': 'country',
          },
        ),
      );

      if (reverseGeocodeResponse.statusCode != 200) {
        return null;
      }

      final reverseData = jsonDecode(reverseGeocodeResponse.body);
      if (reverseData['results'] == null ||
          (reverseData['results'] as List).isEmpty) {
        return null;
      }

      final countryResult = reverseData['results'][0];

      // Extract country code and name
      String? countryCode;
      String? countryName;

      for (var component in countryResult['address_components']) {
        if ((component['types'] as List).contains('country')) {
          countryCode = component['short_name'];
          countryName = component['long_name'];
          break;
        }
      }

      if (countryCode == null || countryName == null) {
        return null;
      }

      // 3. Get the country's bounding box by geocoding the country
      final geocodeResponse = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode/json',
          queryParameters: {
            'address': countryName,
            'key': _apiKey,
            'language': 'en',
            'components': 'country:$countryCode',
          },
        ),
      );

      if (geocodeResponse.statusCode != 200) {
        return null;
      }

      final geocodeData = jsonDecode(geocodeResponse.body);
      if (geocodeData['results'] == null ||
          (geocodeData['results'] as List).isEmpty) {
        return null;
      }

      final countryData = geocodeData['results'][0];
      final geometry = countryData['geometry'];

      if (geometry['bounds'] != null) {
        final bounds = geometry['bounds'];
        return CountryBounds(
          bounds: LatLngBounds(
            southwest: LatLng(
              bounds['southwest']['lat'],
              bounds['southwest']['lng'],
            ),
            northeast: LatLng(
              bounds['northeast']['lat'],
              bounds['northeast']['lng'],
            ),
          ),
          countryName: countryName,
          countryCode: countryCode,
        );
      } else if (geometry['viewport'] != null) {
        // Fallback to viewport if bounds not available
        final viewport = geometry['viewport'];
        return CountryBounds(
          bounds: LatLngBounds(
            southwest: LatLng(
              viewport['southwest']['lat'],
              viewport['southwest']['lng'],
            ),
            northeast: LatLng(
              viewport['northeast']['lat'],
              viewport['northeast']['lng'],
            ),
          ),
          countryName: countryName,
          countryCode: countryCode,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Gets the bounding box for the state/province based on user's location
  /// Queries the users table and uses Google Maps API to get state bounds
  Future<StateBounds?> getStateBoundsFromUserLocation([String? userId]) async {
    try {
      // 1. Query the users table to get the user's location
      final uid = userId ?? _supabase.auth.currentUser?.id;
      if (uid == null) return null;

      final userResponse = await _supabase
          .from(usersTbl)
          .select('location')
          .eq('id', uid)
          .maybeSingle();

      if (userResponse == null || userResponse['location'] == null) {
        return null;
      }

      final location = user_model.Location.fromJson(userResponse['location']);
      final latLng = LatLng(location.latitude, location.longitude);

      // 2. Reverse geocode to get the state information
      final reverseGeocodeResponse = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${latLng.latitude},${latLng.longitude}',
            'key': _apiKey,
            'language': 'en',
            'result_type': 'administrative_area_level_1',
          },
        ),
      );

      if (reverseGeocodeResponse.statusCode != 200) {
        return null;
      }

      final reverseData = jsonDecode(reverseGeocodeResponse.body);
      if (reverseData['results'] == null ||
          (reverseData['results'] as List).isEmpty) {
        return null;
      }

      final stateResult = reverseData['results'][0];

      // Extract state name and country code
      String? stateName;
      String? countryCode;

      for (var component in stateResult['address_components']) {
        final types = component['types'] as List;
        if (types.contains('administrative_area_level_1')) {
          stateName = component['long_name'];
        } else if (types.contains('country')) {
          countryCode = component['short_name'];
        }
      }

      if (stateName == null || countryCode == null) {
        return null;
      }

      // 3. Get the state's bounding box by geocoding the state
      final geocodeResponse = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode/json',
          queryParameters: {
            'address': stateName,
            'key': _apiKey,
            'language': 'en',
            'components': 'country:$countryCode',
          },
        ),
      );

      if (geocodeResponse.statusCode != 200) {
        return null;
      }

      final geocodeData = jsonDecode(geocodeResponse.body);
      if (geocodeData['results'] == null ||
          (geocodeData['results'] as List).isEmpty) {
        return null;
      }

      final stateData = geocodeData['results'][0];
      final geometry = stateData['geometry'];

      if (geometry['bounds'] != null) {
        final bounds = geometry['bounds'];
        return StateBounds(
          bounds: LatLngBounds(
            southwest: LatLng(
              bounds['southwest']['lat'],
              bounds['southwest']['lng'],
            ),
            northeast: LatLng(
              bounds['northeast']['lat'],
              bounds['northeast']['lng'],
            ),
          ),
          stateName: stateName,
          countryCode: countryCode,
        );
      } else if (geometry['viewport'] != null) {
        // Fallback to viewport if bounds not available
        final viewport = geometry['viewport'];
        return StateBounds(
          bounds: LatLngBounds(
            southwest: LatLng(
              viewport['southwest']['lat'],
              viewport['southwest']['lng'],
            ),
            northeast: LatLng(
              viewport['northeast']['lat'],
              viewport['northeast']['lng'],
            ),
          ),
          stateName: stateName,
          countryCode: countryCode,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Extracts country, country code, and state from a lat/lng coordinate
  /// Used during registration to store location metadata
  Future<LocationDetails?> getLocationDetails(LatLng latLng) async {
    try {
      final reverseGeocodeResponse = await http.get(
        Uri(
          scheme: 'https',
          host: 'maps.googleapis.com',
          path: 'maps/api/geocode/json',
          queryParameters: {
            'latlng': '${latLng.latitude},${latLng.longitude}',
            'key': _apiKey,
            'language': 'en',
          },
        ),
      );

      if (reverseGeocodeResponse.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(reverseGeocodeResponse.body);
      if (data['results'] == null || (data['results'] as List).isEmpty) {
        return null;
      }

      String? country;
      String? countryCode;
      String? state;

      // Look through all results to find country and state
      for (var result in data['results']) {
        for (var component in result['address_components']) {
          final types = component['types'] as List;
          if (types.contains('country')) {
            country = component['long_name'];
            countryCode = component['short_name'];
          }
          if (types.contains('administrative_area_level_1')) {
            state = component['long_name'];
          }
        }

        // Break early if we found everything
        if (country != null && countryCode != null && state != null) {
          break;
        }
      }

      if (country == null || countryCode == null || state == null) {
        return null;
      }

      return LocationDetails(
        country: country,
        countryCode: countryCode,
        state: state,
      );
    } catch (e) {
      return null;
    }
  }
}
