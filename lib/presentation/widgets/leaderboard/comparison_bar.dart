import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/profile/user_profile_screen.dart';

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
    return SizedBox(
      height: 380,
      child: Stack(
        children: [
          // Podium blocks
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // 2nd Place Podium
                Expanded(
                  child: _buildPodiumBlock(
                    rank: '2',
                    height: 170,
                    color: Colors.grey[850]!,
                  ),
                ),
                const SizedBox(width: 4),
                // 1st Place Podium
                Expanded(
                  child: _buildPodiumBlock(
                    rank: '1',
                    height: 220,
                    color: Colors.grey[800]!,
                  ),
                ),
                const SizedBox(width: 4),
                // 3rd Place Podium
                Expanded(
                  child: _buildPodiumBlock(
                    rank: '3',
                    height: 130,
                    color: Colors.grey[850]!,
                  ),
                ),
              ],
            ),
          ),
          // Profile images and names
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2nd Place Profile
                Expanded(
                  child: _buildProfileSection(
                    context: context,
                    uid: secondUid,
                    image: secondPlaceImage,
                    name: secondPlaceName,
                    topPadding: 90,
                  ),
                ),
                const SizedBox(width: 4),
                // 1st Place Profile
                Expanded(
                  child: _buildProfileSection(
                    context: context,
                    uid: firstUid,
                    image: firstPlaceImage,
                    name: firstPlaceName,
                    topPadding: 30,
                  ),
                ),
                const SizedBox(width: 8),
                // 3rd Place Profile
                Expanded(
                  child: _buildProfileSection(
                    context: context,
                    uid: thirdUid,
                    image: thirdPlaceImage,
                    name: thirdPlaceName,
                    topPadding: 130,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumBlock({
    required String rank,
    required double height,
    required Color color,
  }) {
    return Stack(
      children: [
        // Main podium face
        Container(
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            rank,
            style: TextStyle(
              fontSize: 100,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        // 3D depth effect - right side
        Positioned(
          right: 0,
          bottom: 0,
          child: ClipPath(
            clipper: _RightDepthClipper(),
            child: Container(
              width: 20,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color.withValues(alpha: 0.8),
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
        ),
        // 3D depth effect - top
        Positioned(
          top: 0,
          left: 0,
          right: 20,
          child: ClipPath(
            clipper: _TopDepthClipper(),
            child: Container(
              height: 15,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.9),
                    color,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection({
    required BuildContext context,
    required String uid,
    required String image,
    required String name,
    required double topPadding,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: InkWell(
        onTap: () async => await context.push(UserProfileScreen.routeName, extra: uid),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: _getImageProvider(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Username
            Text(
              '@$name',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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

// Custom clipper for the right side depth effect
class _RightDepthClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height - 15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 15);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom clipper for the top depth effect
class _TopDepthClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width + 20, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
