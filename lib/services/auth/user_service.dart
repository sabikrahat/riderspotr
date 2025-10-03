import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../config/constants.dart';
import '../../core/exception.dart';
import '../../models/auth/user_model.dart';

class UserService {
  late SupabaseClient _client;

  UserService() {
    _client = Supabase.instance.client;
  }

  Future<UserModel?> getUserById({String? uid}) async {
    try {
      final id = uid ?? _client.auth.currentUser?.id;
      if (id == null) return null;
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

  Future<UserModel?> getUserByEmail({required String email}) async {
    try {
      final res = await _client.from(usersTbl).select().eq('email', email).maybeSingle();
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
      await _client.from(usersTbl).insert(user.toJosn());
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

  Future<void> update({required UserModel user}) async {
    try {
      await _client.from(usersTbl).update(user.toJosn()).eq('id', user.id);
      debugPrint('Supabase updateUser successful');
      return;
    } on SocketException catch (e) {
      debugPrint('No internet connection. $e');
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      debugPrint('Supabase updateUser error: $e');
      throw KException(e.message);
    } catch (e) {
      debugPrint('Supabase updateUser error: $e');
      throw KException(e.toString());
    }
  }
}
