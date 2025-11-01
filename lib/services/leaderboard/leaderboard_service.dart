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
}
