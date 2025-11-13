import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/enums.dart';
import '../../models/car/car_spot_model.dart';

class FeedService {
  final _supabase = Supabase.instance.client;

  /// Fetch feed items with pagination
  /// Returns a list of car spots based on feed type
  Future<List<CarSpotModel>> fetchFeed({
    required FeedType feedType,
    required int page,
    required int pageSize,
    String? userCountry,
  }) async {
    final userId = _supabase.auth.currentUser?.id;

    switch (feedType) {
      case FeedType.global:
        return await _fetchGlobalFeed(page, pageSize);

      case FeedType.country:
        if (userCountry == null) {
          // If no country, fall back to global
          return await _fetchGlobalFeed(page, pageSize);
        }
        return await _fetchCountryFeed(page, pageSize, userCountry);

      case FeedType.friends:
        if (userId == null) {
          return [];
        }
        return await _fetchFriendsFeed(page, pageSize, userId);
    }
  }

  /// Fetch global feed - all car spots ordered by most recent
  Future<List<CarSpotModel>> _fetchGlobalFeed(int page, int pageSize) async {
    try {
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .order('created_at', ascending: false)
          .range(
            page * pageSize,
            (page + 1) * pageSize - 1,
          );

      return (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch global feed: $e');
    }
  }

  /// Fetch country feed - spots filtered by country
  Future<List<CarSpotModel>> _fetchCountryFeed(
    int page,
    int pageSize,
    String country,
  ) async {
    try {
      // First, get the user's country from the users table
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          // TODO: Implement country filter
          // .eq('country', country)
          .order('created_at', ascending: false)
          .range(
            page * pageSize,
            (page + 1) * pageSize - 1,
          );

      return (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch country feed: $e');
    }
  }

  /// Fetch friends feed - spots from users that the current user follows
  Future<List<CarSpotModel>> _fetchFriendsFeed(
    int page,
    int pageSize,
    String userId,
  ) async {
    try {
      // Get list of followed users
      final followingResponse = await _supabase
          .from('user_following')
          .select('followed_user')
          .eq('user', userId);

      final followedUserIds = (followingResponse as List)
          .map((item) => item['followed_user'] as String)
          .toList();

      if (followedUserIds.isEmpty) {
        return [];
      }

      // Fetch car spots from followed users
      // We need to use a raw query or construct the query properly
      // For Supabase, we can use the 'in' operator
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .inFilter('user', followedUserIds)
          .order('created_at', ascending: false)
          .range(
            page * pageSize,
            (page + 1) * pageSize - 1,
          );

      return (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch friends feed: $e');
    }
  }
}
