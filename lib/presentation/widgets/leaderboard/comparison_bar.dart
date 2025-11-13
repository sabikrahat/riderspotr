import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../models/leaderboard/user_leaderboard_model.dart';
import '../../pages/profile/profile_screen.dart';

class LeaderboardComparisonBar extends StatelessWidget {
  final UserLeaderboardModel? firstPlace;
  final UserLeaderboardModel? secondPlace;
  final UserLeaderboardModel? thirdPlace;

  const LeaderboardComparisonBar({
    super.key,
    required this.firstPlace,
    required this.secondPlace,
    required this.thirdPlace,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          Expanded(
            child: _buildPodiumProfile(
              context: context,
              user: secondPlace,
              rank: '2',
              podiumHeight: 140,
            ),
          ),
          SizedBox(width: 12),
          // 1st Place
          Expanded(
            child: _buildPodiumProfile(
              context: context,
              user: firstPlace,
              rank: '1',
              podiumHeight: 180,
            ),
          ),
          SizedBox(width: 12),
          // 3rd Place
          Expanded(
            child: _buildPodiumProfile(
              context: context,
              user: thirdPlace,
              rank: '3',
              podiumHeight: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumProfile({
    required BuildContext context,
    required UserLeaderboardModel? user,
    required String rank,
    required double podiumHeight,
  }) {
    if (user == null) {
      return SizedBox(
        height: podiumHeight + 100,
        child: Center(
          child: Text(
            'N/A',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    final isFirst = rank == '1';
    final profileSize = isFirst ? 70.0 : 60.0;
    final username = '${user.firstName} ${user.lastName}'.trim();
    final imageUrl = user.profilePictureUrl;

    return GestureDetector(
      onTap: () async => await context.push(
        ProfileScreen.userProfileRouteName,
        extra: user.user,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Profile Picture
          Container(
            width: profileSize,
            height: profileSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isFirst
                    ? Color(0xFFFFD700)
                    : Colors.white.withValues(alpha: 0.3),
                width: isFirst ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: profileSize / 2,
              backgroundImage: imageUrl != null
                  ? FastCachedImageProvider(imageUrl) as ImageProvider
                  : AssetImage('assets/images/user-placeholder.png')
                        as ImageProvider,
            ),
          ),
          SizedBox(height: 8),
          // Username
          Text(
            username.isNotEmpty ? username : 'User',
            style: TextStyle(
              fontSize: isFirst ? 12 : 10,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
          // Podium Block
          Container(
            height: podiumHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
            ),
            child: Center(
              child: Text(
                rank,
                style: TextStyle(
                  fontSize: isFirst ? 80 : 60,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.1),
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
