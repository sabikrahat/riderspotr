import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../models/auth/user_model.dart';
import '../../models/user_stats/user_stats_model.dart';

class UserStatsService {
  late SupabaseClient _client;

  UserStatsService() {
    _client = Supabase.instance.client;
  }

  Future<List<UserStatsModel>> getUserStats() async {
    try {
      final res = await _client
          .from('user_stats')
          .select('*')
          .order('total_points', ascending: false);
      debugPrint('Car Spots fetched: ${res.toString()}');
      final ids = res.map((e) => e['id'] as String).toList();
      final usersRes = await _client.from('users').select('*').inFilter('id', ids);
      final users = usersRes.map((e) => UserModel.fromJson(e)).toList();
      final list = res.map((e) {
        UserStatsModel stats = UserStatsModel.fromJson(e);
        stats.user = users.firstWhere(
          (user) => user.id == stats.id,
          orElse: () => throw Exception('User not found'),
        );
        return stats;
      }).toList();
      debugPrint('User Stats fetched: ${list.toString()}');
      return list;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }
}
