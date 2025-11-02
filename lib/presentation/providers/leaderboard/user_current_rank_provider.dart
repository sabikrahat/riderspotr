import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/leaderboard/leaderboard_service.dart';

part 'user_current_rank_provider.g.dart';

@riverpod
class UserCurrentRank extends _$UserCurrentRank {
  @override
  Future<int?> build(String filter) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return null;

    final service = LeaderboardService();

    switch (filter) {
      case 'Country':
        return await service.getCountryRank(userId: userId);
      case 'State':
        return await service.getStateRank(userId: userId);
      case 'Friends':
        return await service.getFriendsRank(userId: userId);
      case 'Global':
      default:
        return await service.getGlobalRank(userId: userId);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build(filter));
  }
}
