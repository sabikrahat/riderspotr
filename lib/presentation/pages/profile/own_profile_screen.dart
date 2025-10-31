import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/image_process/pick_photo.dart';
import '../../widgets/profile/profile_stats_section.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../settings/settings_screen.dart';

class OwnProfileScreen extends ConsumerStatefulWidget {
  const OwnProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OwnProfileScreenState();
}

class _OwnProfileScreenState extends ConsumerState<OwnProfileScreen> {
  bool _isLoading = false;
  XFile? _pickedProfilePicture;
  XFile? _pickedBannerPicture;

  Future<void> _updateImages(UserNotifier notifier) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await notifier.updateProfileAndBannerPictures(
        profilePicture: _pickedProfilePicture,
        bannerPicture: _pickedBannerPicture,
      );
    } catch (e) {
      // Handle error - maybe show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating images: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      floatingActionButton:
          _pickedProfilePicture == null && _pickedBannerPicture == null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: Colors.white,
              onPressed: () async {
                final notifier = ref.read(userProvider.notifier);
                await _updateImages(notifier);
                setState(() {
                  _pickedProfilePicture = null;
                  _pickedBannerPicture = null;
                });
              },
              icon: Icon(Icons.upload, color: Colors.black),
              label: Text(
                'Update',
                style: TextStyle(color: Colors.black),
              ),
            ),
      body: ref
          .watch(userProvider)
          .when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(userProvider.notifier);
              final user = notifier.user;

              // Determine which banner to show
              final bannerImage = _pickedBannerPicture != null
                  ? FileImage(File(_pickedBannerPicture!.path))
                  : user?.bannerUrl != null
                  ? FastCachedImageProvider(user!.bannerUrl!) as ImageProvider
                  : AssetImage('assets/carbon/leaderboard-bg.jpg')
                        as ImageProvider;

              return LoadingOverlay(
                isLoading: _isLoading,
                child: Stack(
                  children: [
                    // Banner Background with Gradient
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: MediaQuery.of(context).size.height * 0.35,
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
                          // Header Section with Profile
                          SafeArea(
                            bottom: false,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  // Settings & Edit Buttons Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (user == null) return;
                                          await pickPhoto(context).then((
                                            pk,
                                          ) async {
                                            if (pk == null) return;
                                            setState(() {
                                              _pickedBannerPicture = pk;
                                            });
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.03,
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
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
                                                Colors.white.withValues(
                                                  alpha: 0.08,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.03,
                                                ),
                                              ],
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.settings,
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Profile Picture with Edit
                                  Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 20,
                                              offset: Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              _pickedProfilePicture != null
                                              ? FileImage(
                                                  File(
                                                    _pickedProfilePicture!.path,
                                                  ),
                                                )
                                              : user?.profilePictureUrl == null
                                              ? AssetImage(
                                                  'assets/images/user-placeholder.png',
                                                )
                                              : FastCachedImageProvider(
                                                      user!.profilePictureUrl!,
                                                    )
                                                    as ImageProvider,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (user == null) return;
                                            await pickPhoto(context).then((
                                              pk,
                                            ) async {
                                              if (pk == null) return;
                                              setState(() {
                                                _pickedProfilePicture = pk;
                                              });
                                            });
                                          },
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
                                  Gap(16),
                                  // Name
                                  Text(
                                    user?.fullName ?? 'Full Name',
                                    style: context.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                  ),
                                  Gap(4),
                                  // Username
                                  Text(
                                    '@${user?.username ?? 'username'}',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Gap(24),
                          // Stats Section
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: ProfileStatsSection(user: user),
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
