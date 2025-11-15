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
  /// Filtered to epic, legendary, or mythic rarity only
  Future<List<CarSpotModel>> _fetchGlobalFeed(int page, int pageSize) async {
    try {
      // Fetch more records to account for filtering
      final fetchSize = pageSize * 3;
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('is_claimed', true)
          .order('created_at', ascending: false)
          .range(
            page * fetchSize,
            (page + 1) * fetchSize - 1,
          );

      final allSpots = (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();

      // Client-side filtering to ensure we only show cars with complete data
      final filteredSpots = allSpots.where((spot) {
        final car = spot.car;
        final rarity = car?.rarity;

        // Only include spots that have a car with valid rarity
        return car != null &&
            rarity != null &&
            (rarity == Rarity.epic ||
                rarity == Rarity.legendary ||
                rarity == Rarity.mythic);
      }).toList();

      return filteredSpots.take(pageSize).toList();
    } catch (e) {
      throw Exception('Failed to fetch global feed: $e');
    }
  }

  /// Fetch country feed - spots filtered by country
  /// Filtered to epic, legendary, or mythic rarity only
  Future<List<CarSpotModel>> _fetchCountryFeed(
    int page,
    int pageSize,
    String country,
  ) async {
    try {
      // Fetch more records to account for filtering
      final fetchSize = pageSize * 3;
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('is_claimed', true)
          // TODO: Implement country filter
          // .eq('country', country)
          .order('created_at', ascending: false)
          .range(
            page * fetchSize,
            (page + 1) * fetchSize - 1,
          );

      final allSpots = (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();

      // Client-side filtering to ensure we only show cars with complete data
      final filteredSpots = allSpots.where((spot) {
        final car = spot.car;
        final rarity = car?.rarity;

        // Only include spots that have a car with valid rarity
        return car != null &&
            rarity != null &&
            (rarity == Rarity.epic ||
                rarity == Rarity.legendary ||
                rarity == Rarity.mythic);
      }).toList();

      return filteredSpots.take(pageSize).toList();
    } catch (e) {
      throw Exception('Failed to fetch country feed: $e');
    }
  }

  /// Fetch friends feed - spots from users that the current user follows
  /// Filtered to epic, legendary, or mythic rarity only
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

      // Fetch more records to account for filtering
      final fetchSize = pageSize * 3;
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .eq('is_claimed', true)
          .inFilter('user', followedUserIds)
          .order('created_at', ascending: false)
          .range(
            page * fetchSize,
            (page + 1) * fetchSize - 1,
          );

      final allSpots = (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();

      // Client-side filtering to ensure we only show cars with complete data
      final filteredSpots = allSpots.where((spot) {
        final car = spot.car;
        final rarity = car?.rarity;

        // Only include spots that have a car with valid rarity
        return car != null &&
            rarity != null &&
            (rarity == Rarity.epic ||
                rarity == Rarity.legendary ||
                rarity == Rarity.mythic);
      }).toList();

      return filteredSpots.take(pageSize).toList();
    } catch (e) {
      throw Exception('Failed to fetch friends feed: $e');
    }
  }
}
