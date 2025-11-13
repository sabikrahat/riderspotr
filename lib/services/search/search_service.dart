import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/car/car_spot_model.dart';

class SearchService {
  final _supabase = Supabase.instance.client;

  /// Fetch top car spots ordered by most recent
  Future<List<CarSpotModel>> fetchTopSpots({int limit = 100}) async {
    try {
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch top spots: $e');
    }
  }

  /// Search car spots by query
  /// Note: Fetches more results and filters client-side since Supabase
  /// doesn't support filtering on nested relationships directly
  Future<List<CarSpotModel>> searchSpots({
    required String query,
    int limit = 100,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return await fetchTopSpots(limit: limit);
      }

      // Fetch more results than needed to account for client-side filtering
      final response = await _supabase
          .from('car_spots')
          .select(CarSpotModel.query)
          .order('created_at', ascending: false)
          .limit(
            limit * 3,
          ); // Fetch 3x to ensure enough results after filtering

      final allSpots = (response as List)
          .map((json) => CarSpotModel.fromJson(json))
          .toList();

      // Filter client-side
      final searchTermLower = query.toLowerCase();
      final filteredSpots = allSpots
          .where((spot) {
            final model = spot.car?.model?.toLowerCase() ?? '';
            final make = spot.car?.make?.name.toLowerCase() ?? '';

            return model.contains(searchTermLower) ||
                make.contains(searchTermLower);
          })
          .take(limit)
          .toList();

      return filteredSpots;
    } catch (e) {
      throw Exception('Failed to search spots: $e');
    }
  }
}
