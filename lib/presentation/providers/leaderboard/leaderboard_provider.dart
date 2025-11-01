import 'package:ridespotr/models/leaderboard/user_leaderboard_model.dart';
import 'package:ridespotr/services/leaderboard/leaderboard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leaderboard_provider.g.dart';

@Riverpod(keepAlive: true)
class LeaderboardProvider extends _$LeaderboardProvider {
  @override
  Future<List<UserLeaderboardModel>> build() async {
    return await LeaderboardService().getWorldTop100();
  }
}
