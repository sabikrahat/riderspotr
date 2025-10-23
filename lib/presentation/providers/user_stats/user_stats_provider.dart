import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/user_stats/user_stats_model.dart';
import '../../../services/user_stats/user_stats.dart';

part 'user_stats_provider.g.dart';

@Riverpod(keepAlive: true)
class UserStatsNotifier extends _$UserStatsNotifier {
  List<UserStatsModel> _userStats = [];

  @override
  FutureOr<List<UserStatsModel>> build() async {
    _userStats = await UserStatsService().getUserStats();
    return _userStats;
  }

  List<UserStatsModel> get userStats => _userStats;

  Future<void> refresh() async {
    _userStats = await UserStatsService().getUserStats();
    state = AsyncValue.data(_userStats);
  }

  List<UserStatsModel> get topThree =>
      _userStats.length >= 3 ? _userStats.sublist(0, 3) : _userStats;

  List<UserStatsModel> get otherStats => _userStats.length > 3 ? _userStats.sublist(3) : [];
}
