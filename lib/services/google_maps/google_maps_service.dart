import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../config/constants.dart';
import '../../models/google_maps/map_prediction_model.dart';
import '../../models/google_maps/place_details_result.dart';

class GoogleMapsService {
  final String _apiKey = googleMapKey;

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
}
