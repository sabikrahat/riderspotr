import 'package:flutter/material.dart';
import 'package:ridespotr/models/leaderboard/user_leaderboard_model.dart';
import 'package:ridespotr/services/leaderboard/leaderboard_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../config/constants.dart';

part 'leaderboard_provider.g.dart';

@Riverpod(keepAlive: true)
class LeaderboardProvider extends _$LeaderboardProvider {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<List<UserLeaderboardModel>> build() async {
    return await LeaderboardService().getWorldTop100();
  }

  Future<List<UserLeaderboardModel>> getWorldLeaderboard() async {
    state = const AsyncValue.loading();

    try {
      final val = await LeaderboardService().getWorldTop100();

      state = AsyncValue.data(val);

      return val;
    } catch (e, stackTrace) {
      debugPrint('Error getting world leaderboard: $e');
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<List<UserLeaderboardModel>> getCountryLeaderboard() async {
    state = const AsyncValue.loading();

    try {
      // Get current user's country code
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('No user logged in');
        state = AsyncValue.data([]);
        return [];
      }

      final userResponse = await _client
          .from(usersTbl)
          .select('country_code')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null || userResponse['country_code'] == null) {
        debugPrint('User has no country code set');
        state = AsyncValue.data([]);
        return [];
      }

      final countryCode = userResponse['country_code'] as String;
      debugPrint('Fetching leaderboard for country: $countryCode');

      // Call the leaderboard service
      final leaderboard = await LeaderboardService().getCountryLeaderboard(
        countryCode: countryCode,
      );

      debugPrint(
        'Country leaderboard retrieved: ${leaderboard.length} users',
      );

      state = AsyncValue.data(leaderboard);
      return leaderboard;
    } catch (e, stackTrace) {
      debugPrint('Error getting country leaderboard: $e');
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<List<UserLeaderboardModel>> getStateLeaderboard() async {
    state = const AsyncValue.loading();

    try {
      // Get current user's country code and state
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('No user logged in');
        state = AsyncValue.data([]);
        return [];
      }

      final userResponse = await _client
          .from(usersTbl)
          .select('country_code, state')
          .eq('id', userId)
          .maybeSingle();

      if (userResponse == null ||
          userResponse['country_code'] == null ||
          userResponse['state'] == null) {
        debugPrint('User has no country/state set');
        state = AsyncValue.data([]);
        return [];
      }

      final countryCode = userResponse['country_code'] as String;
      final stateName = userResponse['state'] as String;
      debugPrint('Fetching leaderboard for: $stateName, $countryCode');

      // Call the leaderboard service
      final leaderboard = await LeaderboardService().getStateLeaderboard(
        countryCode: countryCode,
        state: stateName,
      );

      debugPrint(
        'State leaderboard retrieved: ${leaderboard.length} users',
      );

      state = AsyncValue.data(leaderboard);
      return leaderboard;
    } catch (e, stackTrace) {
      debugPrint('Error getting state leaderboard: $e');
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }

  Future<List<UserLeaderboardModel>> getFriendsLeaderboard() async {
    state = const AsyncValue.loading();

    try {
      // Get current user's ID
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        debugPrint('No user logged in');
        state = AsyncValue.data([]);
        return [];
      }

      debugPrint('Fetching friends leaderboard for user: $userId');

      // Call the leaderboard service
      final leaderboard = await LeaderboardService().getFriendsLeaderboard(
        userId: userId,
      );

      debugPrint(
        'Friends leaderboard retrieved: ${leaderboard.length} users',
      );

      state = AsyncValue.data(leaderboard);
      return leaderboard;
    } catch (e, stackTrace) {
      debugPrint('Error getting friends leaderboard: $e');
      state = AsyncValue.error(e, stackTrace);
      return [];
    }
  }
}
