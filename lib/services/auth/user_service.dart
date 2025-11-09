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

      // Check if username is used (only if username is provided)
      if (user.username != null && user.username!.isNotEmpty) {
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
      }

      final updateData = {
        ...user.toJson(),
        'lat_lng': user.location != null
            ? 'POINT(${user.location!.longitude} ${user.location!.latitude})'
            : null,
      };

      debugPrint("Update data being sent: $updateData");

      await _client.from(usersTbl).update(updateData).eq('id', user.id);

      debugPrint("User updated successfully in database");
    } on SocketException catch (e) {
      debugPrint("SocketException: ${e.message}");
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      debugPrint("AuthException: ${e.message}");
      throw KException(e.message);
    } on KException catch (e) {
      debugPrint("KException: ${e.toString()}");
      rethrow;
    } catch (e) {
      debugPrint("Unknown error: ${e.toString()}");
      throw KException(e.toString());
    }
  }

  /// Update profile picture - uploads and saves to database
  Future<String> updateProfilePicture(XFile file) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Upload to storage
      final path = '${const Uuid().v4()}.jpg';
      await _client.storage
          .from('profile-picture')
          .upload(
            path,
            File(file.path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = '$supabaseStorageUrl/profile-picture/$path';
      debugPrint('Profile picture uploaded to: $imageUrl');

      // Update database
      await _client
          .from(usersTbl)
          .update({'profile_picture_url': imageUrl})
          .eq('id', userId);

      debugPrint('Profile picture URL saved to database');
      return imageUrl;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint('Error updating profile picture: $e');
      throw KException('Error updating profile picture: $e');
    }
  }

  /// Update banner picture - uploads and saves to database
  Future<String> updateBannerPicture(XFile file) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Upload to storage
      final path = '${const Uuid().v4()}.jpg';
      await _client.storage
          .from('banner-picture')
          .upload(
            path,
            File(file.path),
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final imageUrl = '$supabaseStorageUrl/banner-picture/$path';
      debugPrint('Banner picture uploaded to: $imageUrl');

      // Update database
      await _client
          .from(usersTbl)
          .update({'banner_url': imageUrl})
          .eq('id', userId);

      debugPrint('Banner picture URL saved to database');
      return imageUrl;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint('Error updating banner picture: $e');
      throw KException('Error updating banner picture: $e');
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

  Future<void> saveFcmToken(String token) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return;

      await _client
          .from(usersTbl)
          .update({'fcm_token': token})
          .eq('id', userId);

      debugPrint('FCM token saved: $token');
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } on AuthException catch (e) {
      throw KException(e.message);
    } catch (e) {
      throw KException(e.toString());
    }
  }
}
