import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/car/car_spot_model.dart';
import '../../../services/search/search_service.dart';

part 'search_provider.g.dart';

@riverpod
class Search extends _$Search {
  final _searchService = SearchService();
  String _currentQuery = '';

  @override
  Future<List<CarSpotModel>> build() async {
    return await _fetchTopSpots();
  }

  Future<List<CarSpotModel>> _fetchTopSpots() async {
    try {
      return await _searchService.fetchTopSpots(limit: 100);
    } catch (e) {
      throw Exception('Failed to load top spots: $e');
    }
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (query.trim().isEmpty) {
        return await _fetchTopSpots();
      }
      return await _searchService.searchSpots(query: query, limit: 100);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (_currentQuery.trim().isEmpty) {
        return await _fetchTopSpots();
      }
      return await _searchService.searchSpots(query: _currentQuery, limit: 100);
    });
  }
}
