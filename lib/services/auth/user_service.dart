import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants.dart';
import '../../core/exception.dart';
import '../../models/auth/user_model.dart';
import '../../models/user_stats/user_stats_model.dart';

class UserService {
  late SupabaseClient _client;

  UserService() {
    _client = Supabase.instance.client;
  }

  // Future<UserModel?> getUserById({String? uid}) async {
  //   try {
  //     final id = uid ?? _client.auth.currentUser?.id;
  //     if (id == null) return null;
  //     final res = await _client
  //         .from(usersTbl)
  //         .select()
  //         .eq('id', id)
  //         .maybeSingle();
  //     if (res == null) return null;
  //     return UserModel.fromJson(res);
  //   } on SocketException catch (e) {
  //     debugPrint('No internet connection. $e');
  //     throw KException('No internet connection. ${e.message}');
  //   } on AuthException catch (e) {
  //     debugPrint('Supabase getUser error: $e');
  //     throw KException(e.message);
  //   } catch (e) {
  //     debugPrint('Supabase getUser error: $e');
  //     throw KException(e.toString());
  //   }
  // }

  Future<UserModel?> getUser([String? uid]) async {
    try {
      final id = uid ?? _client.auth.currentUser?.id;
      if (id == null) return null;
      final res = await _client.from(usersTbl).select(UserModel.query).eq('id', id).maybeSingle();
      debugPrint('User fetched: ${res.toString()}');
      if (res == null) return null;
      return UserModel.fromJson(res);
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      throw KException(e.toString());
    }
  }

  Future<List<UserModel>> getUsers([String? query]) async {
    try {
      dynamic pq = _client.from(usersTbl).select(UserModel.query);
      if (query != null && query.isNotEmpty) {
        pq = pq.or('username.ilike.%$query%,first_name.ilike.%$query%,last_name.ilike.%$query%');
      }
      final res = await pq;
      if (res.isEmpty) return [];
      return res.map<UserModel>((e) => UserModel.fromJson(e)).toList();
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      throw KException(e.toString());
    }
  }

  // Future<UserModel?> getUserByEmail({required String email}) async {
  //   try {
  //     final res = await _client
  //         .from(usersTbl)
  //         .select()
  //         .eq('email', email.toLowerCase())
  //         .maybeSingle();
  //     if (res == null) return null;
  //     return UserModel.fromJson(res);
  //   } on SocketException catch (e) {
  //     debugPrint('No internet connection. $e');
  //     throw KException('No internet connection. ${e.message}');
  //   } on AuthException catch (e) {
  //     debugPrint('Supabase getUser error: $e');
  //     throw KException(e.message);
  //   } catch (e) {
  //     debugPrint('Supabase getUser error: $e');
  //     throw KException(e.toString());
  //   }
  // }

  Future<void> createUser() async {
    try {
      await _client
          .from(usersTbl)
          .insert(
            UserModel(
              id: _client.auth.currentUser!.id,
              email: _client.auth.currentUser!.email!.toLowerCase(),
              createdAt: DateTime.now(),
              isGaragePrivate: false,
            ).toJson(),
          );
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      throw KException(e.toString());
    }
  }

  Future<void> update({required UserModel user}) async {
    try {
      debugPrint("Updating user: ${user.toJson()}");
      // Check if username is used
      final username = await _client
          .from('usernames')
          .select()
          .eq('username', user.username!)
          .neq('id', user.id)
          .maybeSingle();

      if (username != null) {
        throw KException(
          'Username already used. Please use a different username.',
        );
      }

      await _client
          .from(usersTbl)
          .update({
            ...user.toJson(),
            'lat_lng': user.location != null
                ? 'POINT(${user.location!.longitude} ${user.location!.latitude})'
                : null,
          })
          .eq('id', user.id);
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } on KException catch (_) {
      rethrow;
    } catch (e) {
      throw KException(e.toString());
    }
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
