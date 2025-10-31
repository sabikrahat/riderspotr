import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/providers/auth/user_provider.dart';
import 'package:ridespotr/presentation/widgets/capture/scan_detail_container.dart';
import 'package:ridespotr/presentation/widgets/shared/loading_overlay.dart';
import 'package:ridespotr/services/auth/user_service.dart';

import '../../../core/extensions.dart';
import '../../widgets/image_process/pick_photo.dart';
import '../../widgets/shared/profile_xp_card.dart';
import '../settings/settings_screen.dart';

class OwnProfileScreen extends ConsumerStatefulWidget {
  const OwnProfileScreen({super.key});
  static const String routeName = '/profile';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends ConsumerState<OwnProfileScreen> {
  bool _isLoading = false;
  XFile? _pickedProfilePicture;
  XFile? _pickedBannerPicture;

  Future<void> _updateImages(UserNotifier notifier) async {
    if (_pickedProfilePicture == null && _pickedBannerPicture == null) return;
    if (notifier.user == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      String? profileImagePath;
      String? bannerImagePath;
      if (_pickedProfilePicture != null) {
        profileImagePath = await UserService().uploadProfilePictureToStorage(
          _pickedProfilePicture!,
        );
      }
      if (_pickedBannerPicture != null) {
        bannerImagePath = await UserService().uploadBannerPictureToStorage(
          _pickedBannerPicture!,
        );
      }
      await notifier.updateUser(
        user: notifier.user!.copyWith(
          profilePictureUrl: profileImagePath ?? notifier.user!.profilePictureUrl,
          bannerUrl: bannerImagePath ?? notifier.user!.bannerUrl,
        ),
      );
      await notifier.refreshUser();
    } catch (e) {
      throw Exception('Error updating images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _pickedProfilePicture == null && _pickedBannerPicture == null
          ? null
          : Column(
              children: [
                Gap(340),
                FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    final notifier = ref.read(userProvider.notifier);
                    await _updateImages(notifier);
                    setState(() {
                      _pickedProfilePicture = null;
                      _pickedBannerPicture = null;
                    });
                  },
                  icon: Icon(Icons.upload, color: charcol),
                  label: Text(
                    'Update',
                    style: TextStyle(color: charcol),
                  ),
                ),
              ],
            ),
      body: ref
          .watch(userProvider)
          .when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(userProvider.notifier);
              final user = notifier.user;
              return SingleChildScrollView(
                child: LoadingOverlay(
                  isLoading: _isLoading,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 400,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: _pickedBannerPicture != null
                                  ? Image.file(
                                      File(_pickedBannerPicture!.path),
                                      fit: BoxFit.cover,
                                    )
                                  : user?.bannerUrl == null
                                  ? Image.asset(
                                      'assets/carbon/leaderboard-bg.jpg',
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Image.network(
                                      user!.bannerUrl!,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, lp) {
                                        if (lp == null) return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: lp.expectedTotalBytes != null
                                                ? lp.cumulativeBytesLoaded / lp.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (_, _, _) {
                                        return Image.asset(
                                          'assets/carbon/leaderboard-bg.jpg',
                                          fit: BoxFit.fitHeight,
                                        );
                                      },
                                    ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(
                                  16.0,
                                  48.0,
                                  16.0,
                                  0.0,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withValues(alpha: 0.6),
                                      Colors.black.withValues(alpha: 0.53),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox.shrink(),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () async {
                                        if (user == null) return;
                                        await pickPhoto(context).then((pk) async {
                                          if (pk == null) return;
                                          setState(() {
                                            _pickedBannerPicture = pk;
                                          });
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async => await context.push(
                                        SettingsScreen.routeName,
                                      ),
                                      icon: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                      Colors.black,
                                    ],
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: charcol,
                                          backgroundImage: _pickedProfilePicture != null
                                              ? FileImage(
                                                  File(_pickedProfilePicture!.path),
                                                )
                                              : user?.profilePictureUrl == null
                                              ? AssetImage(
                                                  'assets/images/user-placeholder.png',
                                                )
                                              : NetworkImage(user!.profilePictureUrl!),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: InkWell(
                                            onTap: () async {
                                              if (notifier.user == null) return;
                                              await pickPhoto(context).then((pk) async {
                                                if (pk == null) return;
                                                setState(() {
                                                  _pickedProfilePicture = pk;
                                                });
                                              });
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.grey[300],
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            user?.fullName ?? 'Full Name',
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '@${user?.username ?? 'username'}',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white70,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR STATISTICS',
                              style: context.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Gap(16),
                            //
                            ProfileXPCard(user: notifier.user),
                            //
                            const Gap(16),
                            Row(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: _Tile(
                                    icon: Icons.directions_car_rounded,
                                    title: 'LEGANDARIES',
                                    value: '#14',
                                  ),
                                ),
                                Expanded(
                                  child: _Tile(
                                    icon: Icons.directions_car_rounded,
                                    title: 'LEGANDARIES',
                                    value: '#14',
                                  ),
                                ),
                                Expanded(
                                  child: _Tile(
                                    icon: Icons.directions_car_rounded,
                                    title: 'LEGANDARIES',
                                    value: '#14',
                                  ),
                                ),
                              ],
                            ),
                            Gap(200),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Gap(8),
          Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
