import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/exception.dart';
import '../../models/car/car_spot_model.dart';
import '../../models/user/spot_stat_model.dart';
import '../google_maps/google_maps_service.dart';

class CarService {
  late SupabaseClient _client;

  CarService() {
    _client = Supabase.instance.client;
  }

  // ========== Car Spot Methods ==========

  /// Get all car spots for the current user (claimed only)
  Future<List<CarSpotModel>> getCarSpots([String? id]) async {
    try {
      final userId = id ?? _client.auth.currentUser!.id;
      final res = await _client
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('user', userId)
          .eq('is_claimed', true);
      debugPrint('Car Spots fetched: ${res.toString()}');
      return res.map((e) => CarSpotModel.fromJson(e)).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  /// Get all car spots from all users (claimed only)
  Future<List<CarSpotModel>> getAllCarSpots([String? userId]) async {
    try {
      var query = _client
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('is_claimed', true);
      if (userId != null) {
        query = query.eq('user', userId);
      }

      final res = await query;
      return res.map((e) => CarSpotModel.fromJson(e)).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  /// Mark a car spot as claimed
  Future<void> markClaimed(String id) async {
    try {
      // Get the car spot to get the user ID
      final carSpot = await _client
          .from('car_spots')
          .select('user')
          .eq('id', id)
          .single();

      final userId = carSpot['user'] as String;

      // Update is_claimed
      await _client.from('car_spots').update({'is_claimed': true}).eq('id', id);

      // Update user stats
      await _updateUserStats(userId);
    } catch (e) {
      throw Exception('Error marking claimed: $e');
    }
  }

  /// Update user stats when a car is claimed
  Future<void> _updateUserStats(String userId) async {
    try {
      // Get current user stats
      final statsResult = await _client
          .from('user_stats')
          .select()
          .eq('user', userId)
          .maybeSingle();

      // Get all claimed car spots for this user with car data
      final carSpotsResult = await _client
          .from('car_spots')
          .select('car(id, rarity)')
          .eq('user', userId)
          .eq('is_claimed', true);

      // Calculate unique spots (count of unique car IDs)
      final uniqueCarIds = <String>{};
      final legendaryCarIds = <String>{};

      for (final spot in carSpotsResult) {
        final carData = spot['car'] as Map<String, dynamic>?;
        if (carData != null) {
          final carId = carData['id'] as String?;
          final rarity = carData['rarity'] as String?;

          if (carId != null) {
            uniqueCarIds.add(carId);
            if (rarity == 'legendary') {
              legendaryCarIds.add(carId);
            }
          }
        }
      }

      final uniqueSpots = uniqueCarIds.length;
      final legendarySpots = legendaryCarIds.length;

      // Calculate total spots
      final totalSpots = carSpotsResult.length;

      // Update or insert user stats
      if (statsResult != null) {
        await _client
            .from('user_stats')
            .update({
              'total_spots': totalSpots,
              'unique_spots': uniqueSpots,
              'legendary_spots': legendarySpots,
            })
            .eq('user', userId);
      } else {
        await _client.from('user_stats').insert({
          'user': userId,
          'total_spots': totalSpots,
          'unique_spots': uniqueSpots,
          'legendary_spots': legendarySpots,
        });
      }
    } catch (e) {
      debugPrint('Error updating user stats: $e');
      // Don't throw - stats update failure shouldn't block claiming
    }
  }

  /// Delete a car spot
  Future<void> delete(String id) async {
    try {
      await _client.from('car_spots').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting car spot: $e');
    }
  }

  // ========== Car Scanning Methods ==========

  /// Upload a car image to storage
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
      return path;
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  /// Scan a car by calling the edge function and return the full CarSpotModel
  Future<CarSpotModel> scanCar(String imagePath) async {
    try {
      // Take currentLocation latitude and longitude with proper permissions
      // will return latitude and longitude and address string
      final data = await _getLocation();
      final requestBody = {
        'image_path': imagePath,
        ...data,
      };
      debugPrint('Scanning car with data: $requestBody');
      final response = await _client.functions.invoke(
        'scan-car',
        body: requestBody,
      );
      debugPrint('Edge function <scan-car> response: ${response.data}');
      await Clipboard.setData(ClipboardData(text: response.data.toString()));

      final carSpotId = response.data['data']['car_spot']['id'] as String;

      // Query the database for the full CarSpotModel
      final res = await _client
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('id', carSpotId)
          .single();

      debugPrint('Car spot fetched: ${res.toString()}');
      return CarSpotModel.fromJson(res);
    } catch (e) {
      throw Exception('Error scanning car: $e');
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

      debugPrint(
        'Current position: lat=${position.latitude}, lng=${position.longitude}',
      );

      // Get address from coordinates using GoogleMapsService
      final latLng = LatLng(position.latitude, position.longitude);
      final placeDetails = await GoogleMapsService().getLocationBasedOnLatLng(
        latLng,
      );

      String formattedAddress =
          placeDetails?.formattedAddress ?? 'Unknown location';

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

  /// Get spot statistics for a user using the database function
  Future<SpotStatModel> getSpotStats({
    String? userId,
    String timezone = 'Australia/Melbourne',
  }) async {
    try {
      final id = userId ?? _client.auth.currentUser?.id;
      if (id == null) {
        throw KException('User ID is required');
      }

      final res = await _client.rpc(
        'get_spot_counts',
        params: {
          'p_user': id,
          'p_tz': timezone,
        },
      );

      // The function returns a table with a single row
      final resList = res as List<dynamic>?;
      if (resList == null || resList.isEmpty) {
        // Return default values if no data
        return SpotStatModel(
          totalSpots: 0,
          todaysSpots: 0,
          lastHourSpots: 0,
        );
      }

      final stats = resList.first as Map<String, dynamic>;
      return SpotStatModel.fromJson(stats);
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      throw KException(e.toString());
    }
  }
}
