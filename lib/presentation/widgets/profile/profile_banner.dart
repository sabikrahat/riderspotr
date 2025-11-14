import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/profile/followers_following_screen.dart';
import 'package:ridespotr/presentation/pages/settings/settings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileBanner extends StatelessWidget {
  final String? profilePictureUrl;
  final String? bannerPictureUrl;
  final String fullName;
  final String username;
  final String userId;
  final String? bio;
  final String? instagramUrl;
  final String? tiktokUrl;
  final int totalSpots;
  final int followersCount;
  final int followingCount;
  final bool isOwnProfile;
  final bool isFollowing;
  final VoidCallback? onFollowTap;
  final VoidCallback? onEditProfilePicture;
  final VoidCallback? onEditBanner;
  final VoidCallback? onEditBio;
  final VoidCallback? onEditSocials;

  const ProfileBanner({
    super.key,
    required this.profilePictureUrl,
    required this.bannerPictureUrl,
    required this.fullName,
    required this.username,
    required this.userId,
    this.bio,
    this.instagramUrl,
    this.tiktokUrl,
    required this.totalSpots,
    required this.followersCount,
    required this.followingCount,
    this.isOwnProfile = false,
    this.isFollowing = false,
    this.onFollowTap,
    this.onEditProfilePicture,
    this.onEditBanner,
    this.onEditBio,
    this.onEditSocials,
  });

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Buttons Row (Settings/Edit for own profile, Back for others)
            Row(
              mainAxisAlignment: isOwnProfile
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!isOwnProfile)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                    ),
                  ),
                if (isOwnProfile) ...[
                  GestureDetector(
                    onTap: onEditBanner,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                    ),
                  ),
                  Gap(12),
                  GestureDetector(
                    onTap: () async => await context.push(
                      SettingsScreen.routeName,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.08),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Gap(16),
            Row(
              children: [
                // Profile Picture with Edit for own profile
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: profilePictureUrl == null
                            ? AssetImage(
                                'assets/images/user-placeholder.png',
                              )
                            : FastCachedImageProvider(
                                    profilePictureUrl!,
                                  )
                                  as ImageProvider,
                      ),
                    ),
                    if (isOwnProfile && onEditProfilePicture != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onEditProfilePicture,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        _StatItem(label: "Spots", value: totalSpots.toString()),
                        GestureDetector(
                          onTap: () {
                            context.push(
                              FollowersFollowingScreen.routeName,
                              extra: {
                                'userId': userId,
                                'initialTab': FollowersFollowingTab.followers,
                              },
                            );
                          },
                          child: _StatItem(
                            label: "Followers",
                            value: followersCount.toString(),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(
                              FollowersFollowingScreen.routeName,
                              extra: {
                                'userId': userId,
                                'initialTab': FollowersFollowingTab.following,
                              },
                            );
                          },
                          child: _StatItem(
                            label: "Following",
                            value: followingCount.toString(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Gap(12),
            Text(
              '@$username',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Gap(16),
            // Bio section
            if (bio != null && bio!.isNotEmpty)
              Text(
                bio!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              )
            else if (isOwnProfile)
              GestureDetector(
                onTap: onEditBio,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                      Gap(6),
                      Text(
                        'Add bio',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // Edit bio icon for own profile with existing bio
            if (isOwnProfile && bio != null && bio!.isNotEmpty) ...[
              Gap(8),
              GestureDetector(
                onTap: onEditBio,
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    Gap(4),
                    Text(
                      'Edit bio',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Social Links Section
            if ((instagramUrl != null && instagramUrl!.isNotEmpty) ||
                (tiktokUrl != null && tiktokUrl!.isNotEmpty)) ...[
              Gap(12),
              Row(
                children: [
                  if (instagramUrl != null && instagramUrl!.isNotEmpty)
                    GestureDetector(
                      onTap: () => _launchUrl(instagramUrl!),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/instagram.svg',
                          width: 18,
                          height: 18,
                          // colorFilter: ColorFilter.mode(
                          //   Colors.white.withValues(alpha: 0.8),
                          //   BlendMode.srcIn,
                          // ),
                        ),
                      ),
                    ),
                  if (instagramUrl != null &&
                      instagramUrl!.isNotEmpty &&
                      tiktokUrl != null &&
                      tiktokUrl!.isNotEmpty)
                    Gap(12),
                  if (tiktokUrl != null && tiktokUrl!.isNotEmpty)
                    GestureDetector(
                      onTap: () => _launchUrl(tiktokUrl!),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/tiktok.svg',
                          width: 18,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            Colors.white.withValues(alpha: 0.8),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
            // Edit socials button for own profile
            if (isOwnProfile) ...[
              Gap(12),
              GestureDetector(
                onTap: onEditSocials,
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    Gap(4),
                    Text(
                      ((instagramUrl != null && instagramUrl!.isNotEmpty) ||
                              (tiktokUrl != null && tiktokUrl!.isNotEmpty))
                          ? 'Edit socials'
                          : 'Add socials',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (!isOwnProfile) ...[
              Gap(16),
              GestureDetector(
                onTap: onFollowTap,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isFollowing
                          ? [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.white.withValues(alpha: 0.08),
                            ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isFollowing ? Icons.person_remove : Icons.person_add,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      Gap(6),
                      Text(
                        isFollowing ? 'Following' : 'Follow',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            // fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
