import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../pages/profile/user_profile_screen.dart';

class LeaderboardComparisonBar extends StatelessWidget {
  final String firstUid;
  final String firstPlaceImage;
  final String firstPlaceName;
  final String secondUid;
  final String secondPlaceImage;
  final String secondPlaceName;
  final String thirdUid;
  final String thirdPlaceImage;
  final String thirdPlaceName;

  const LeaderboardComparisonBar({
    super.key,
    required this.firstUid,
    required this.firstPlaceImage,
    required this.firstPlaceName,
    required this.secondUid,
    required this.secondPlaceImage,
    required this.secondPlaceName,
    required this.thirdUid,
    required this.thirdPlaceImage,
    required this.thirdPlaceName,
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
              uid: secondUid,
              image: secondPlaceImage,
              name: secondPlaceName,
              rank: '2',
              podiumHeight: 140,
            ),
          ),
          SizedBox(width: 12),
          // 1st Place
          Expanded(
            child: _buildPodiumProfile(
              context: context,
              uid: firstUid,
              image: firstPlaceImage,
              name: firstPlaceName,
              rank: '1',
              podiumHeight: 180,
            ),
          ),
          SizedBox(width: 12),
          // 3rd Place
          Expanded(
            child: _buildPodiumProfile(
              context: context,
              uid: thirdUid,
              image: thirdPlaceImage,
              name: thirdPlaceName,
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
    required String uid,
    required String image,
    required String name,
    required String rank,
    required double podiumHeight,
  }) {
    final isFirst = rank == '1';
    final profileSize = isFirst ? 70.0 : 60.0;

    return GestureDetector(
      onTap: () async =>
          await context.push(UserProfileScreen.routeName, extra: uid),
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
              backgroundImage: _getImageProvider(image),
            ),
          ),
          SizedBox(height: 8),
          // Username
          Text(
            '@$name',
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

  ImageProvider _getImageProvider(String imagePath) {
    // Check if the path is a network URL
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    // Otherwise, treat it as an asset image
    return AssetImage(imagePath);
  }
}
