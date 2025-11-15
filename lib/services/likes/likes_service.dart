import 'package:supabase_flutter/supabase_flutter.dart';

class LikesService {
  final _supabase = Supabase.instance.client;

  /// Like a car spot
  Future<void> likeCarSpot(String carSpotId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase.from('car_spot_likes').insert({
        'car_spot': carSpotId,
        'user': userId,
      });
    } catch (e) {
      throw Exception('Failed to like car spot: $e');
    }
  }

  /// Unlike a car spot
  Future<void> unlikeCarSpot(String carSpotId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _supabase
          .from('car_spot_likes')
          .delete()
          .eq('car_spot', carSpotId)
          .eq('user', userId);
    } catch (e) {
      throw Exception('Failed to unlike car spot: $e');
    }
  }

  /// Get like count for a car spot
  Future<int> getLikeCount(String carSpotId) async {
    try {
      final response = await _supabase
          .from('car_spot_likes')
          .select('car_spot')
          .eq('car_spot', carSpotId);

      return (response as List).length;
    } catch (e) {
      throw Exception('Failed to get like count: $e');
    }
  }

  /// Check if current user has liked a car spot
  Future<bool> hasLiked(String carSpotId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return false;
    }

    try {
      final response = await _supabase
          .from('car_spot_likes')
          .select('car_spot')
          .eq('car_spot', carSpotId)
          .eq('user', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Get like counts for multiple car spots (batch)
  Future<Map<String, int>> getLikeCounts(List<String> carSpotIds) async {
    if (carSpotIds.isEmpty) {
      return {};
    }

    try {
      final response = await _supabase
          .from('car_spot_likes')
          .select('car_spot')
          .inFilter('car_spot', carSpotIds);

      final Map<String, int> counts = {};
      for (final spotId in carSpotIds) {
        counts[spotId] = 0;
      }

      for (final item in response as List) {
        final spotId = item['car_spot'] as String;
        counts[spotId] = (counts[spotId] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      throw Exception('Failed to get like counts: $e');
    }
  }

  /// Get liked status for multiple car spots (batch)
  Future<Set<String>> getLikedCarSpots(List<String> carSpotIds) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null || carSpotIds.isEmpty) {
      return {};
    }

    try {
      final response = await _supabase
          .from('car_spot_likes')
          .select('car_spot')
          .eq('user', userId)
          .inFilter('car_spot', carSpotIds);

      return (response as List)
          .map((item) => item['car_spot'] as String)
          .toSet();
    } catch (e) {
      return {};
    }
  }
}
