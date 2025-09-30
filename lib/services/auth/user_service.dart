import 'dart:io';

import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/auth/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';

class UserService {
  late SupabaseClient _client;

  UserService() {
    _client = Supabase.instance.client;
  }

  Future<UserModel?> getUser({String? uid}) async {
    try {
      final id = uid ?? _client.auth.currentUser?.id;
      if (id == null) throw KException('User ID is null');
      final res = await _client.from(usersTbl).select().eq('id', id).maybeSingle();
      if (res == null) return null;
      return UserModel.fromJson(res);
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      debugPrint('Supabase getUser error: $e');
      throw KException(e.message);
    } catch (e) {
      debugPrint('Supabase getUser error: $e');
      throw KException(e.toString());
    }
  }

  Future<void> createUser({required UserModel user}) async {
    try {
      await _client.from(usersTbl).insert(user.toJson());
      debugPrint('Supabase createUser successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      debugPrint('Supabase createUser error: $e');
      throw KException(e.message);
    } catch (e) {
      debugPrint('Supabase createUser error: $e');
      throw KException(e.toString());
    }
  }
}
