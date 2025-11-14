import 'package:camera/camera.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/toastification.dart';
import '../../providers/auth/profile_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/image_process/pick_photo.dart';
import '../../widgets/profile/profile_banner.dart';
import '../../widgets/profile/profile_garage_tab.dart';
import '../../widgets/profile/profile_stats_tab.dart';
import '../../widgets/shared/loading_overlay.dart';
import 'edit_bio_screen.dart';
import 'edit_socials_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.id});

  static const String routeName = '/profile';
  static const String userProfileRouteName = '/user-profile';

  /// If id is null, shows the current user's profile
  /// If id is provided, shows another user's profile
  final String? id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  TabController? _tabController;
  int _currentTabIndex = 0;

  bool get _isOwnProfile =>
      widget.id == null ||
      widget.id == Supabase.instance.client.auth.currentUser?.id;

  void _initializeTabController(bool isGaragePrivate) {
    // Show tabs unless viewing another user's private garage
    final shouldShowTabs = _isOwnProfile || !isGaragePrivate;
    final tabLength = shouldShowTabs ? 2 : 1;

    if (_tabController?.length != tabLength) {
      _tabController?.dispose();
      _tabController = TabController(length: tabLength, vsync: this);
      _tabController!.addListener(_handleTabChange);
      _currentTabIndex = 0;
    }
  }

  void _handleTabChange() {
    if (_tabController?.indexIsChanging ?? true) return;
    setState(() {
      _currentTabIndex = _tabController!.index;
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _updateProfilePicture(XFile file) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifier = ref.read(userProvider.notifier);
      await notifier.updateProfilePicture(file);

      showSuccessMessage('Profile picture updated successfully!');
    } catch (e) {
      debugPrint('Error updating profile picture: $e');
      showErrorMessage('Failed to update profile picture. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateBannerPicture(XFile file) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifier = ref.read(userProvider.notifier);
      await notifier.updateBannerPicture(file);

      showSuccessMessage('Banner updated successfully!');
    } catch (e) {
      debugPrint('Error updating banner: $e');
      showErrorMessage('Failed to update banner. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEditBio(BuildContext context) {
    context.push(EditBioScreen.routeName);
  }

  void _navigateToEditSocials(BuildContext context) {
    context.push(EditSocialsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the appropriate provider based on whether it's own profile or not
    final profileAsync = _isOwnProfile
        ? ref.watch(userProvider)
        : ref.watch(profileProvider(widget.id!));

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: profileAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (_) {
          final user = _isOwnProfile
              ? ref.read(userProvider.notifier).user
              : ref.read(profileProvider(widget.id!).notifier).user;

          final isGaragePrivate = user?.isGaragePrivate ?? false;

          // Initialize tab controller based on profile type and garage privacy
          _initializeTabController(isGaragePrivate);

          // Determine which banner to show
          final bannerImage = user?.bannerUrl != null
              ? FastCachedImageProvider(user!.bannerUrl!) as ImageProvider
              : AssetImage('assets/carbon/leaderboard-bg.jpg') as ImageProvider;

          final showTabs = _isOwnProfile || !isGaragePrivate;

          return LoadingOverlay(
            isLoading: _isLoading,
            child: Stack(
              children: [
                // Banner Background with Gradient
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: bannerImage,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 0.6, 1.0],
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.5),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Banner
                      ProfileBanner(
                        profilePictureUrl: user?.profilePictureUrl,
                        bannerPictureUrl: user?.bannerUrl,
                        fullName: user?.fullName ?? 'Full Name',
                        username: user?.username ?? 'username',
                        userId: user?.id ?? '',
                        bio: user?.bio,
                        instagramUrl: user?.instagramUrl,
                        tiktokUrl: user?.tiktokUrl,
                        totalSpots: user?.stats?.totalSpots ?? 0,
                        followersCount: user?.followersCount ?? 0,
                        followingCount: user?.followingCount ?? 0,
                        isOwnProfile: _isOwnProfile,
                        isFollowing: _isOwnProfile
                            ? false
                            : ref
                                  .read(profileProvider(widget.id!).notifier)
                                  .isFollowing,
                        onFollowTap: _isOwnProfile
                            ? null
                            : () async => await ref
                                  .read(profileProvider(widget.id!).notifier)
                                  .followUnfollowUser(),
                        onEditProfilePicture: _isOwnProfile
                            ? () async {
                                if (user == null) return;
                                final pk = await pickPhoto(context);
                                if (pk != null) {
                                  await _updateProfilePicture(pk);
                                }
                              }
                            : null,
                        onEditBanner: _isOwnProfile
                            ? () async {
                                if (user == null) return;
                                final pk = await pickPhoto(context);
                                if (pk != null) {
                                  await _updateBannerPicture(pk);
                                }
                              }
                            : null,
                        onEditBio: _isOwnProfile
                            ? () => _navigateToEditBio(context)
                            : null,
                        onEditSocials: _isOwnProfile
                            ? () => _navigateToEditSocials(context)
                            : null,
                      ),

                      // Tab Section (only show for other users' profiles when garage is not private)
                      if (showTabs) ...[
                        Gap(16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _tabController?.animateTo(0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'GARAGE',
                                      style: TextStyle(
                                        color: _currentTabIndex == 0
                                            ? Colors.white
                                            : Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                        fontWeight: _currentTabIndex == 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 2,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: _currentTabIndex == 0
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Gap(32),
                              GestureDetector(
                                onTap: () => _tabController?.animateTo(1),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'STATS',
                                      style: TextStyle(
                                        color: _currentTabIndex == 1
                                            ? Colors.white
                                            : Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                        fontWeight: _currentTabIndex == 1
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 2,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: _currentTabIndex == 1
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      Gap(24),

                      // Content Section
                      if (showTabs)
                        IndexedStack(
                          index: _currentTabIndex,
                          children: [
                            ProfileGarageTab(
                              userId: _isOwnProfile ? null : widget.id!,
                            ),
                            ProfileStatsTab(
                              userId: _isOwnProfile ? null : widget.id!,
                            ),
                          ],
                        )
                      else
                        ProfileStatsTab(
                          userId: _isOwnProfile ? null : widget.id!,
                        ),

                      Gap(100),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
