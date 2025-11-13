import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../services/feed/feed_service.dart';

part 'feed_provider.g.dart';

@riverpod
class Feed extends _$Feed {
  static const int _pageSize = 20;
  List<CarSpotModel> _allItems = [];
  bool _hasMore = true;
  int _currentPage = 0;
  final _feedService = FeedService();

  @override
  Future<List<CarSpotModel>> build(
    FeedType feedType,
    String? userCountry,
  ) async {
    _currentPage = 0;
    _hasMore = true;
    _allItems = [];
    return await _loadPage();
  }

  Future<List<CarSpotModel>> _loadPage() async {
    try {
      final newSpots = await _feedService.fetchFeed(
        feedType: feedType,
        page: _currentPage,
        pageSize: _pageSize,
        userCountry: userCountry,
      );

      // Check if we have more items
      if (newSpots.length < _pageSize) {
        _hasMore = false;
      }

      _allItems.addAll(newSpots);
      return List.from(_allItems);
    } catch (e) {
      throw Exception('Failed to load feed: $e');
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    state = const AsyncValue.loading();
    _currentPage++;

    state = await AsyncValue.guard(() async {
      return await _loadPage();
    });
  }

  Future<void> refresh() async {
    _currentPage = 0;
    _hasMore = true;
    _allItems = [];
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadPage();
    });
  }

  bool get hasMore => _hasMore;
}
