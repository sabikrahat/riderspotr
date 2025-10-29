import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/profile_provider.dart';
// import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/profile_xp_card.dart';
import '../settings/settings_screen.dart';

class OwnProfileScreen extends ConsumerWidget {
  const OwnProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(profileProvider(null))
          .when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(profileProvider(null).notifier);
              final user = notifier.user;
              return SingleChildScrollView(
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
                            child: user?.bannerUrl == null
                                ? Image.asset(
                                    'assets/carbon/leaderboard-bg.jpg',
                                    fit: BoxFit.fitHeight,
                                  )
                                : Image.network(
                                    user!.bannerUrl!,
                                    fit: BoxFit.cover,
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox.shrink(),
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
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: user?.profilePictureUrl == null
                                        ? AssetImage(
                                            'assets/images/user-placeholder.png',
                                          )
                                        : const NetworkImage(
                                            'https://picsum.photos/200',
                                          ),
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
