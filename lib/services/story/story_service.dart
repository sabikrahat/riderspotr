import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../models/car/car_spot_model.dart';
import '../../models/story/story_model.dart';

class StoryService {
  late SupabaseClient _client;

  StoryService() {
    _client = Supabase.instance.client;
  }

  /// Get recent spots (stories) for a specific user from last 24 hours
  Future<List<StoryItemModel>> getUserStories(
    String userId,
    String? username,
    String? profilePictureUrl,
  ) async {
    try {
      final twentyFourHoursAgo = DateTime.now()
          .subtract(const Duration(hours: 24))
          .toIso8601String();

      final res = await _client
          .from('car_spots')
          .select('id, image_url, address, created_at, car(make(name), model)')
          .eq('user', userId)
          .eq('is_claimed', true)
          .gte('created_at', twentyFourHoursAgo)
          .order('created_at', ascending: false);

      return res.map((e) {
        final carMake = e['car']['make']['name'] as String;
        final carModel = e['car']['model'] as String;
        return StoryItemModel(
          id: e['id'] as String,
          imageUrl: e['image_url'] as String,
          carMake: carMake,
          carModel: carModel,
          address: e['address'] as String,
          createdAt: DateTime.parse(e['created_at'] as String),
        );
      }).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  /// Get stories for multiple users
  Future<Map<String, List<StoryModel>>> getMultipleUsersStories(
    List<String> userIds,
    Map<String, String?> usernames,
    Map<String, String?> profilePictureUrls,
  ) async {
    try {
      final twentyFourHoursAgo = DateTime.now()
          .subtract(const Duration(hours: 24))
          .toIso8601String();

      final res = await _client
          .from('car_spots')
          .select(CarSpotModel.query)
          .inFilter('user', userIds)
          .eq('is_claimed', true)
          .gte('created_at', twentyFourHoursAgo)
          .order('created_at', ascending: false);

      final carSpots = res.map((e) => CarSpotModel.fromJson(e)).toList();

      // Group by user
      final Map<String, List<StoryModel>> storiesByUser = {};
      for (var spot in carSpots) {
        if (!storiesByUser.containsKey(spot.user)) {
          storiesByUser[spot.user] = [];
        }
        storiesByUser[spot.user]!.add(
          StoryModel.fromCarSpot(
            spot,
            usernames[spot.user],
            profilePictureUrls[spot.user],
          ),
        );
      }

      return storiesByUser;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }
}
