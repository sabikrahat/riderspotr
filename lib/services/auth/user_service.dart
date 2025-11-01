import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../config/constants.dart';
import '../../core/exception.dart';
import '../../models/user/user_model.dart';

class UserService {
  late SupabaseClient _client;

  UserService() {
    _client = Supabase.instance.client;
  }

  Future<UserModel?> getUser([String? uid]) async {
    try {
      final id = uid ?? _client.auth.currentUser?.id;
      if (id == null) return null;
      final res = await _client
          .from(usersTbl)
          .select(UserModel.query)
          .eq('id', id)
          .maybeSingle();
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
        pq = pq.or(
          'username.ilike.%$query%,first_name.ilike.%$query%,last_name.ilike.%$query%',
        );
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
              stats: null,
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

  /// Upload a profile picture to storage
  Future<String?> uploadProfilePictureToStorage(XFile file) async {
    try {
      final path = '${const Uuid().v4()}.jpg';
      // upload to supabase storage bucket 'banner-picture'
      final res = await _client.storage
          .from('profile-picture')
          .upload(
            path,
            File(file.path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      debugPrint('Supabase photo upload in <$res>');
      return '$supabaseStorageUrl/profile-picture/$path';
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  /// Upload a banner picture to storage
  Future<String?> uploadBannerPictureToStorage(XFile file) async {
    try {
      final path = '${const Uuid().v4()}.jpg';
      // upload to supabase storage bucket 'banner-picture'
      final res = await _client.storage
          .from('banner-picture')
          .upload(
            path,
            File(file.path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      debugPrint('Supabase photo upload in <$res>');
      return '$supabaseStorageUrl/banner-picture/$path';
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }

  Future<int> getUserLeaderboardRank() async {
    try {
      final res = await _client
          .from("xp_leaderboard")
          .select('rank')
          .eq('user', _client.auth.currentUser!.id)
          .single();

      return res['rank'];
    } catch (e) {
      throw Exception('Failed to get leaderboard rank');
    }
  }
}
