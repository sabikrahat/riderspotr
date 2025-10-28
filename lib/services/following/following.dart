import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';

class FollowingService {
  late SupabaseClient _client;

  FollowingService() {
    _client = Supabase.instance.client;
  }

  Future<bool> isFollowing(String user) async {
    try {
      final res = await _client
          .from('user_following')
          .select('*')
          .eq('user', _client.auth.currentUser!.id)
          .eq('followed_user', user)
          .maybeSingle();
      return res != null;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  Future<void> followUser(String user) async {
    try {
      await _client.from('user_following').insert({
        'user': _client.auth.currentUser!.id,
        'followed_user': user,
      });
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }

  Future<void> unfollowUser(String user) async {
    try {
      await _client
          .from('user_following')
          .delete()
          .eq('user', _client.auth.currentUser!.id)
          .eq('followed_user', user);
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }
}
