import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../models/user/user_simple_model.dart';

part 'followers_following_provider.g.dart';

@riverpod
class Followers extends _$Followers {
  @override
  Future<List<UserSimpleModel>> build(String userId) async {
    return await _fetchFollowers();
  }

  Future<List<UserSimpleModel>> _fetchFollowers() async {
    try {
      final response = await Supabase.instance.client
          .from('user_following')
          .select('user:users!user_following_user_fkey(id, first_name, last_name, username, profile_picture_url)')
          .eq('followed_user', userId);

      final followers = (response as List)
          .map((item) => UserSimpleModel.fromJson(item['user'] as Map<String, dynamic>))
          .toList();

      return followers;
    } catch (e) {
      throw Exception('Failed to fetch followers: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFollowers());
  }
}

@riverpod
class Following extends _$Following {
  @override
  Future<List<UserSimpleModel>> build(String userId) async {
    return await _fetchFollowing();
  }

  Future<List<UserSimpleModel>> _fetchFollowing() async {
    try {
      final response = await Supabase.instance.client
          .from('user_following')
          .select('followed_user:users!user_following_followed_user_fkey(id, first_name, last_name, username, profile_picture_url)')
          .eq('user', userId);

      final following = (response as List)
          .map((item) => UserSimpleModel.fromJson(item['followed_user'] as Map<String, dynamic>))
          .toList();

      return following;
    } catch (e) {
      throw Exception('Failed to fetch following: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFollowing());
  }
}

