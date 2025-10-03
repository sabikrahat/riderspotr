import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../../config/constants.dart';
import 'map_prediction_model.dart';
import 'place_details_result.dart';

class GoogleMapsHelper {
  final String _apiKey = googleMapKey;

  Future<PlaceDetailsResult?> getLocationBasedOnPlaceId(String place) async {
    final localPlaceDetails = await MapHelperLocal.getPlaceDetails(place);
    if (localPlaceDetails != null) {
      return localPlaceDetails;
    }
    var response = await http.get(
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
      debugPrint(data.toString());
      debugPrint(response.statusCode.toString());
      final location = PlaceDetailsResult.fromJson(data['result']);
      await MapHelperLocal.savePlaceDetails(place, location); // save to local
      return location;
    }
    return null;
  }

  Future<PlaceDetailsResult?> getLocationBasedOnLatLng(LatLng latLng) async {
    final localPlaceDetails = await MapHelperLocal.getPlaceDetails(
        latLng.toString()); // get from local
    if (localPlaceDetails != null) {
      return localPlaceDetails;
    }
    var response = await http.get(
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
      debugPrint('getLocationBasedOnLatLng: ${data.toString()}');
      debugPrint(response.statusCode.toString());
      final location = PlaceDetailsResult.fromJson(data['results'][0]);
      await MapHelperLocal.savePlaceDetails(
          latLng.toString(), location); // save to local
      return location;
    }
    return null;
  }

  Future<List<MapPredictionModel>> getLocations(String address) async {
    if (address.isEmpty || address.length < 3) return [];
    final localPredictions = await MapHelperLocal.getPredictions(address);
    if (localPredictions.isNotEmpty) return localPredictions;
    try {
      var response = await http.get(
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
        log('searchLocation: ${data.toString()}');
        debugPrint(response.statusCode.toString());
        final places = (data['predictions'] as List)
            .map((e) => MapPredictionModel.fromJson(e))
            .toList()
          ..removeWhere((element) => element.placeId == 'null');
        await MapHelperLocal.savePredictions(address, places); // save to local
        return places;
      } else {
        log(response.body, name: 'RequestTripSend.getLocations');
        return [];
      }
    } on PlatformException catch (e) {
      log(e.toString(), name: 'RequestTripSend.getLocations');
      return [];
    }
  }
}

class MapHelperLocal {
  static const predictionKey = 'predictionKey';
  static const placeDetailsKey = 'placeDetailsKey';

  static Future<List<MapPredictionModel>> getPredictions(String address) async {
    final box = await Hive.openBox<List>(predictionKey);
    final data = box.get(address, defaultValue: []);
    final predictions = data!.map((e) {
      final data = jsonDecode(jsonEncode(e));
      return MapPredictionModel.fromJson(data);
    }).toList();
    return predictions;
  }

  static Future<void> savePredictions(
      String address, List<MapPredictionModel> predictions) async {
    if (predictions.isEmpty) return;
    final box = await Hive.openBox<List>(predictionKey);
    if (box.containsKey(address)) return;
    final data = predictions.map((e) => e.toJson()).toList();
    await box.put(address, data);
  }

  static Future<PlaceDetailsResult?> getPlaceDetails(String placeId) async {
    final box = await Hive.openBox<Map>(placeDetailsKey);
    final data = box.get(placeId, defaultValue: {});
    if (data!.isEmpty) return null;
    final placeDetails =
        PlaceDetailsResult.fromJson(jsonDecode(jsonEncode(data)));
    return placeDetails;
  }

  static Future<void> savePlaceDetails(
      String placeId, PlaceDetailsResult placeDetails) async {
    if (placeDetails.placeId == null) return;
    final box = await Hive.openBox<Map<String, dynamic>>(placeDetailsKey);
    if (box.containsKey(placeId)) return;
    final data = placeDetails.toJson();
    await box.put(placeId, data);
  }

  // static Future<void> clear() async {
  //   final box = await Hive.openBox<List<Map<String, dynamic>>>(predictionKey);
  //   await box.clear();
  //   final box2 = await Hive.openBox<Map<String, dynamic>>(placeDetailsKey);
  //   await box2.clear();
  // }
}
