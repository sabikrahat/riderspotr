import 'package:ridespotr/models/leaderboard/user_leaderboard_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardService {
  late SupabaseClient _client;

  LeaderboardService() {
    _client = Supabase.instance.client;
  }

  Future<List<UserLeaderboardModel>> getWorldTop100() async {
    final res = await _client
        .from('xp_leaderboard')
        .select('*')
        .order('rank', ascending: true)
        .limit(100);

    return res.map((x) => UserLeaderboardModel.fromJson(x)).toList();
  }

  Future<List<UserLeaderboardModel>> getCountryLeaderboard({
    required String countryCode,
  }) async {
    final res = await _client.rpc(
      'get_country_leaderboard',
      params: {
        'p_country_code': countryCode,
      },
    );

    return (res as List).map((x) => UserLeaderboardModel.fromJson(x)).toList();
  }

  Future<List<UserLeaderboardModel>> getStateLeaderboard({
    required String countryCode,
    required String state,
  }) async {
    final res = await _client.rpc(
      'get_state_leaderboard',
      params: {
        'p_country_code': countryCode,
        'p_state': state,
      },
    );

    return (res as List).map((x) => UserLeaderboardModel.fromJson(x)).toList();
  }

  Future<List<UserLeaderboardModel>> getFriendsLeaderboard({
    required String userId,
  }) async {
    final res = await _client.rpc(
      'get_friends_leaderboard',
      params: {
        'p_user_id': userId,
      },
    );

    return (res as List).map((x) => UserLeaderboardModel.fromJson(x)).toList();
  }

  // Rank functions
  Future<int?> getGlobalRank({required String userId}) async {
    try {
      final res = await _client
          .from('xp_leaderboard')
          .select('rank')
          .eq('user', userId)
          .maybeSingle();

      if (res == null) return null;
      return res['rank'] as int;
    } catch (e) {
      return null;
    }
  }

  Future<int?> getCountryRank({required String userId}) async {
    try {
      final res = await _client.rpc(
        'get_country_rank',
        params: {'p_user_id': userId},
      );
      return res as int?;
    } catch (e) {
      return null;
    }
  }

  Future<int?> getStateRank({required String userId}) async {
    try {
      final res = await _client.rpc(
        'get_state_rank',
        params: {'p_user_id': userId},
      );
      return res as int?;
    } catch (e) {
      return null;
    }
  }

  Future<int?> getFriendsRank({required String userId}) async {
    try {
      final res = await _client.rpc(
        'get_friends_rank',
        params: {'p_user_id': userId},
      );
      return res as int?;
    } catch (e) {
      return null;
    }
  }
}
