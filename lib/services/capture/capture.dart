import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../config/constants.dart';
import '../google_maps/google_maps_service.dart';

class CaptureService {
  late SupabaseClient _client;

  CaptureService() {
    _client = Supabase.instance.client;
  }

  Future<String?> uploadFileToStorage(XFile file) async {
    try {
      final path = '${const Uuid().v4()}.jpg';
      // upload to supabase storage bucket 'car-spots'
      final res = await _client.storage
          .from('car-spots')
          .upload(
            path,
            File(file.path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      debugPrint('Supabase photo upload in <$res>');
      return '$supabaseUrl/storage/v1/object/public/car-spots/$path';
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<Map<String, dynamic>> uploadToEdgeFunction(String url) async {
    try {
      // Take currentLocation latitude and longitude with proper permissions
      // will return latitude and longitude and address string
      final data = await _getLocation();
      // edge function call
      // TODO: Replace the dummy url to actual
      final requestBody = {
        // 'imageUrl': url,
        'imageUrl': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSfjl-oShMovlXEXFkzBCKMGgk8EaeEU-1HlA&s',
        ...data,
      };
      debugPrint('Uploading to edge function with data: $requestBody');
      final response = await _client.functions.invoke('scan-car', body: requestBody);
      debugPrint('Edge function <scan-car> response: ${response.data}');
      await Clipboard.setData(ClipboardData(text: response.data.toString()));
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Error uploading to edge function: $e');
    }
  }

  /// Gets the current location with proper permissions handling
  /// Returns a Map containing latitude, longitude, and formatted address
  Future<Map<String, dynamic>> _getLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled. Please enable location services.',
        );
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      debugPrint('Current position: lat=${position.latitude}, lng=${position.longitude}');

      // Get address from coordinates using GoogleMapsService
      final latLng = LatLng(position.latitude, position.longitude);
      final placeDetails = await GoogleMapsService().getLocationBasedOnLatLng(latLng);

      String formattedAddress = placeDetails?.formattedAddress ?? 'Unknown location';

      // Return location data in the format expected by CarSpotModel
      return {
        'lat': position.latitude,
        'lng': position.longitude,
        'address': formattedAddress,
      };
    } catch (e) {
      debugPrint('Error getting location: $e');
      throw Exception('Error getting location: $e');
    }
  }
}
