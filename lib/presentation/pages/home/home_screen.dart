import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/profile_provider.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(profileProvider(null))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (_) {
            final notifier = ref.read(profileProvider(null).notifier);
            final user = notifier.user;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section with Carbon Fiber
                  _buildHeroSection(context, user),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(16),

                        // XP Progress Section
                        _buildXPSection(context, user),

                        Gap(32),

                        // XP Tasks Preview - HORIZONTAL SCROLLING VERSION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DAILY TASKS',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to tasks page
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                  ),
                                  Gap(4),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(12),
                        SizedBox(
                          height: 180,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _buildHorizontalTaskCard(
                                context,
                                title: 'Spot Your First Car',
                                description: 'Capture any vehicle on the map',
                                xpReward: 50,
                                icon: Icons.camera_alt,
                                isCompleted: false,
                              ),
                              Gap(12),
                              _buildHorizontalTaskCard(
                                context,
                                title: 'Daily Login',
                                description: 'Open the app every day',
                                xpReward: 25,
                                icon: Icons.login,
                                isCompleted: true,
                              ),
                              Gap(12),
                              _buildHorizontalTaskCard(
                                context,
                                title: 'Share a Spot',
                                description: 'Share your capture with friends',
                                xpReward: 100,
                                icon: Icons.share,
                                isCompleted: false,
                              ),
                            ],
                          ),
                        ),

                        Gap(32),

                        // VERTICAL LIST VERSION (COMMENTED OUT)
                        // Uncomment this and comment out the horizontal version above to switch back
                        /*
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DAILY TASKS',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to tasks page
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: context.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                  ),
                                  Gap(4),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Gap(12),
                        _buildTaskCard(
                          context,
                          title: 'Spot Your First Car',
                          description: 'Capture any vehicle on the map',
                          xpReward: 50,
                          icon: Icons.camera_alt,
                          isCompleted: false,
                        ),
                        Gap(10),
                        _buildTaskCard(
                          context,
                          title: 'Daily Login',
                          description: 'Open the app every day',
                          xpReward: 25,
                          icon: Icons.login,
                          isCompleted: true,
                        ),
                        Gap(10),
                        _buildTaskCard(
                          context,
                          title: 'Share a Spot',
                          description: 'Share your capture with friends',
                          xpReward: 100,
                          icon: Icons.share,
                          isCompleted: false,
                        ),
                        Gap(32),
                        */

                        // Quick Stats Grid
                        Text(
                          'YOUR STATS',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        Gap(12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.directions_car,
                                title: 'SPOTTED',
                                value: '247',
                                subtitle: '+12 this week',
                              ),
                            ),
                            Gap(12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.emoji_events,
                                title: 'LEGENDARY',
                                value: '8',
                                subtitle: 'Top 3%',
                                accentColor: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        Gap(12),
                        Row(
                          children: [
                            Expanded(
                              child: _StatCard(
                                icon: Icons.diamond_outlined,
                                title: 'RARITY SCORE',
                                value: '9.2k',
                                subtitle: 'Elite hunter',
                                accentColor: Colors.purple,
                              ),
                            ),
                            Gap(12),
                            Expanded(
                              child: _StatCard(
                                icon: Icons.location_on,
                                title: 'LOCATIONS',
                                value: '34',
                                subtitle: '5 countries',
                              ),
                            ),
                          ],
                        ),

                        Gap(32),

                        // Achievement Section
                        Text(
                          'RECENT ACHIEVEMENTS',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        Gap(12),
                        _buildAchievementCard(
                          context,
                          title: 'Elite Spotter',
                          description: 'Spotted 200+ vehicles',
                          progress: 0.85,
                          icon: Icons.military_tech,
                        ),
                        Gap(12),
                        _buildAchievementCard(
                          context,
                          title: 'Legendary Hunter',
                          description: 'Find 10 legendary cars',
                          progress: 0.6,
                          icon: Icons.star,
                        ),

                        Gap(100),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }

  Widget _buildHeroSection(BuildContext context, dynamic user) {
    return Stack(
      children: [
        // Carbon fiber background
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: Stack(
            children: [
              Image.asset(
                'assets/carbon/47.jpg',
                width: context.width,
                height: context.height * 0.55,
                fit: BoxFit.cover,
              ),
              Container(
                width: context.width,
                height: context.height * 0.55,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content
        Positioned(
          top: MediaQuery.viewPaddingOf(context).top + 16,
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar with Logo and Rank
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/logo/logo-full.svg',
                    width: 160,
                    fit: BoxFit.fitWidth,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: Colors.amber,
                        ),
                        Gap(6),
                        Text(
                          '#142',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Call to action message
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'READY TO HUNT?',
                    style: context.textTheme.headlineMedium?.copyWith(
                      // fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  Gap(12),
                  Text(
                    'Discover rare supercars in your area.\nCapture them, earn XP, and climb the ranks.',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.8),
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Gap(12),

              // Subtle button
              GestureDetector(
                onTap: () => context.push(ExploreScreen.routeName),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 16,
                        color: Colors.black,
                      ),
                      Gap(8),
                      Text(
                        'Explore Map',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Gap(4),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildXPSection(BuildContext context, dynamic user) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withValues(alpha: 0.15),
            Colors.purple.withValues(alpha: 0.15),
          ],
        ),
        border: Border.all(
          color: Colors.grey[850]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withValues(alpha: 0.3),
                      Colors.purple.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.electric_bolt,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              Gap(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LEVEL ${user?.stats?.level ?? 12}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                  Gap(4),
                  Text(
                    '${user?.stats?.totalXp?.toInt() ?? 8450} XP',
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap(20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress to Level ${(user?.stats?.level ?? 12) + 1}',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    '${((user?.stats?.xpToNextLevelProgress ?? 65)).toInt()}%',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Gap(8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (user?.stats?.xpToNextLevelProgress ?? 65) / 100,
                  backgroundColor: Colors.white.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                  minHeight: 8,
                ),
              ),
              Gap(6),
              Text(
                '550 XP to next level',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    BuildContext context, {
    required String title,
    required String description,
    required double progress,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey[850]!,
        ),
        color: Colors.grey[900]!.withValues(alpha: 0.4),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber.withValues(alpha: 0.3),
                  Colors.orange.withValues(alpha: 0.3),
                ],
              ),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              icon,
              color: Colors.amber,
              size: 24,
            ),
          ),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                Gap(8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.amber,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          Gap(8),
          Text(
            '${(progress * 100).toInt()}%',
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildTaskCard(
  //   BuildContext context, {
  //   required String title,
  //   required String description,
  //   required int xpReward,
  //   required IconData icon,
  //   required bool isCompleted,
  // }) {
  //   return Container(
  //     padding: EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: isCompleted
  //             ? Colors.green.withValues(alpha: 0.3)
  //             : Colors.grey[800]!,
  //       ),
  //       color: isCompleted
  //           ? Colors.green.withValues(alpha: 0.1)
  //           : Colors.grey[900]!.withValues(alpha: 0.4),
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           padding: EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             shape: BoxShape.circle,
  //             color: isCompleted
  //                 ? Colors.green.withValues(alpha: 0.2)
  //                 : Colors.blue.withValues(alpha: 0.2),
  //             border: Border.all(
  //               color: isCompleted
  //                   ? Colors.green.withValues(alpha: 0.3)
  //                   : Colors.blue.withValues(alpha: 0.3),
  //             ),
  //           ),
  //           child: Icon(
  //             isCompleted ? Icons.check : icon,
  //             color: isCompleted ? Colors.green : Colors.blue,
  //             size: 20,
  //           ),
  //         ),
  //         Gap(14),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 title,
  //                 style: context.textTheme.bodyMedium?.copyWith(
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                   decoration: isCompleted ? TextDecoration.lineThrough : null,
  //                   color: isCompleted
  //                       ? Colors.white.withValues(alpha: 0.5)
  //                       : Colors.white,
  //                 ),
  //               ),
  //               Gap(4),
  //               Text(
  //                 description,
  //                 style: context.textTheme.bodyMedium?.copyWith(
  //                   fontSize: 11,
  //                   color: Colors.white.withValues(alpha: 0.5),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Gap(12),
  //         Container(
  //           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withValues(alpha: 0.1),
  //             borderRadius: BorderRadius.circular(8),
  //             border: Border.all(
  //               color: Colors.white.withValues(alpha: 0.2),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               Icon(
  //                 Icons.electric_bolt,
  //                 size: 14,
  //                 color: Colors.amber,
  //               ),
  //               Gap(4),
  //               Text(
  //                 '$xpReward',
  //                 style: context.textTheme.bodyMedium?.copyWith(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.amber,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildHorizontalTaskCard(
    BuildContext context, {
    required String title,
    required String description,
    required int xpReward,
    required IconData icon,
    required bool isCompleted,
  }) {
    return Container(
      width: 240,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.grey[850]!,
        ),
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.grey[900]!.withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.blue.withValues(alpha: 0.2),
                  border: Border.all(
                    color: isCompleted
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.blue.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  color: isCompleted ? Colors.green : Colors.blue,
                  size: 22,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.electric_bolt,
                      size: 14,
                      color: Colors.amber,
                    ),
                    Gap(4),
                    Text(
                      '$xpReward',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacer(),
          SizedBox(
            child: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Gap(6),
          SizedBox(
            child: Text(
              description,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                height: 1.4,
                color: Colors.white.withValues(alpha: 0.5),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    this.accentColor,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.white;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey[850]!,
        ),
        color: Colors.grey[900]!.withValues(alpha: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color.withValues(alpha: 0.7),
                size: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: color.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
          ),
          Gap(12),
          Text(
            value,
            style: context.textTheme.headlineLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Gap(4),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
