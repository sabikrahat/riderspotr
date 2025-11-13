import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/user/user_simple_model.dart';

class UserSearchService {
  final _supabase = Supabase.instance.client;

  /// Fetch suggested users (random or based on some criteria)
  Future<List<UserSimpleModel>> fetchSuggestedUsers({int limit = 20}) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      final response = await _supabase
          .from('users')
          .select('id, first_name, last_name, username, profile_picture_url')
          .neq('id', currentUserId ?? '')
          .limit(limit);

      return (response as List)
          .map((json) => UserSimpleModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch suggested users: $e');
    }
  }

  /// Search users by username or name using full-text search
  Future<List<UserSimpleModel>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (query.trim().isEmpty) {
        return await fetchSuggestedUsers(limit: limit);
      }

      final searchTerm = '%${query.toLowerCase()}%';

      final response = await _supabase
          .from('users')
          .select('id, first_name, last_name, username, profile_picture_url')
          .neq('id', currentUserId ?? '')
          .or(
            'username.ilike.$searchTerm,first_name.ilike.$searchTerm,last_name.ilike.$searchTerm',
          )
          .limit(limit);

      return (response as List)
          .map((json) => UserSimpleModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}
