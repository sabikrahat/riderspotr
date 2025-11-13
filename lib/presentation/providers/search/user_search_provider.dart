import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user/user_simple_model.dart';
import '../../../services/search/user_search_service.dart';

part 'user_search_provider.g.dart';

@riverpod
class UserSearch extends _$UserSearch {
  final _userSearchService = UserSearchService();
  String _currentQuery = '';

  @override
  Future<List<UserSimpleModel>> build() async {
    return await _fetchSuggestedUsers();
  }

  Future<List<UserSimpleModel>> _fetchSuggestedUsers() async {
    try {
      return await _userSearchService.fetchSuggestedUsers(limit: 20);
    } catch (e) {
      throw Exception('Failed to load suggested users: $e');
    }
  }

  Future<void> search(String query) async {
    _currentQuery = query;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (query.trim().isEmpty) {
        return await _fetchSuggestedUsers();
      }
      return await _userSearchService.searchUsers(query: query, limit: 20);
    });
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      if (_currentQuery.trim().isEmpty) {
        return await _fetchSuggestedUsers();
      }
      return await _userSearchService.searchUsers(
        query: _currentQuery,
        limit: 20,
      );
    });
  }
}
