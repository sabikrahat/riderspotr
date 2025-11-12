import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/exception.dart';
import '../../models/user/story_user_model.dart';

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

  /// Get all users that current user follows, marking those with recent spots
  Future<List<StoryUserModel>> getFollowedUsersWithRecentSpots() async {
    try {
      final currentUserId = _client.auth.currentUser!.id;

      // Get users that current user follows
      final following = await _client
          .from('user_following')
          .select('followed_user')
          .eq('user', currentUserId);

      if (following.isEmpty) {
        return [];
      }

      final followedUserIds = following
          .map((f) => f['followed_user'] as String)
          .toList();

      // Get all followed users' details
      final allFollowedUsers = await _client
          .from('users')
          .select('id, username, profile_picture_url')
          .inFilter('id', followedUserIds);

      // Get recent spots (last 24 hours) from followed users
      final twentyFourHoursAgo = DateTime.now()
          .subtract(const Duration(hours: 24))
          .toIso8601String();

      final recentSpots = await _client
          .from('car_spots')
          .select('user, created_at')
          .inFilter('user', followedUserIds)
          .gte('created_at', twentyFourHoursAgo)
          .eq('is_claimed', true)
          .order('created_at', ascending: false);

      // Get unique users with their most recent spot time
      final Map<String, DateTime> userLatestSpot = {};
      for (var spot in recentSpots) {
        final userId = spot['user'] as String;
        final createdAt = DateTime.parse(spot['created_at'] as String);

        if (!userLatestSpot.containsKey(userId) ||
            createdAt.isAfter(userLatestSpot[userId]!)) {
          userLatestSpot[userId] = createdAt;
        }
      }

      // Convert all users to StoryUserModel and mark those with recent spots
      final storyUsers = allFollowedUsers.map((user) {
        final userId = user['id'] as String;
        final hasRecentSpot = userLatestSpot.containsKey(userId);

        return StoryUserModel.fromJson(user).copyWith(
          hasRecentSpot: hasRecentSpot,
        );
      }).toList();

      // Sort: users with recent spots first (by most recent), then others alphabetically
      storyUsers.sort((a, b) {
        if (a.hasRecentSpot && b.hasRecentSpot) {
          // Both have spots, sort by most recent
          final aTime = userLatestSpot[a.id]!;
          final bTime = userLatestSpot[b.id]!;
          return bTime.compareTo(aTime);
        } else if (a.hasRecentSpot) {
          // Only a has spot, a comes first
          return -1;
        } else if (b.hasRecentSpot) {
          // Only b has spot, b comes first
          return 1;
        } else {
          // Neither has spot, sort alphabetically by username
          final aName = a.username ?? '';
          final bName = b.username ?? '';
          return aName.compareTo(bName);
        }
      });

      return storyUsers;
    } on SocketException catch (e) {
      throw KException('No internet connection. ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
      throw KException(e.toString());
    }
  }
}
