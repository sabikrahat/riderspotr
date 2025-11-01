import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/providers/leaderboard/leaderboard_provider.dart';

import '../../../core/extensions.dart';
import '../../widgets/leaderboard/comparison_bar.dart';
import '../../widgets/leaderboard/summary_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/filter_chips.dart';
import '../../widgets/shared/page_padding.dart';
import '../profile/user_profile_screen.dart';
import 'search_friend.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  static const String routeName = '/leaderboard';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String selectedFilter = 'Global';
  final List<String> filters = ['Global', 'Country', 'City', 'Friends'];
  String selectedSort = 'Overall';
  final List<String> sortOptions = [
    'Overall',
    'This Month',
    'This Week',
    'Today',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CarbonBackground(
        imgPath: 'assets/carbon/leaderboard-bg.jpg',
        heightPercent: 0.3,
        child: SafeArea(
          child: PagePadding(
            child: ref
                .watch(leaderboardProviderProvider)
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (leaderboardUsers) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          // Clean Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LEADERBOARD',
                                    style: context.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w300,
                                          // letterSpacing: -0.5,
                                        ),
                                  ),
                                  Gap(4),
                                  Text(
                                    'Global Rankings',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.4,
                                          ),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async => await context.push(
                                  SearchFriendScreen.routeName,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(12),
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.person_add_alt_1_rounded,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gap(32),

                          // Clean Filter Chips
                          FilterChips(
                            options: filters,
                            selectedValue: selectedFilter,
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value;
                              });
                            },
                          ),
                          Gap(24),

                          // Summary Card
                          LeaderboardSummaryCard(),
                          Gap(16),

                          // Leaderboard Bar
                          if (leaderboardUsers.length >= 3)
                            LeaderboardComparisonBar(
                              firstPlace: leaderboardUsers[0],
                              secondPlace: leaderboardUsers[1],
                              thirdPlace: leaderboardUsers[2],
                            ),
                          Gap(16),

                          // Sort Section
                          // Row(
                          //   children: [
                          //     Text(
                          //       'Sort by',
                          //       style: context.textTheme.bodyMedium?.copyWith(
                          //         fontSize: 13,
                          //         color: Colors.white.withValues(alpha: 0.5),
                          //       ),
                          //     ),
                          //     Gap(12),
                          //     DropdownButton<String>(
                          //       isDense: true,
                          //       value: selectedSort,
                          //       onChanged: (value) {
                          //         if (value != null) {
                          //           setState(() {
                          //             selectedSort = value;
                          //           });
                          //         }
                          //       },
                          //       underline: const SizedBox.shrink(),
                          //       dropdownColor: Color(0xFF0A0A0A),
                          //       icon: Icon(
                          //         Icons.keyboard_arrow_down_rounded,
                          //         color: Colors.white.withValues(alpha: 0.6),
                          //         size: 20,
                          //       ),
                          //       style: context.textTheme.bodyMedium?.copyWith(
                          //         color: Colors.white,
                          //         fontSize: 14,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //       items: sortOptions.map((option) {
                          //         return DropdownMenuItem<String>(
                          //           value: option,
                          //           child: Text(option),
                          //         );
                          //       }).toList(),
                          //     ),
                          //   ],
                          // ),
                          // Gap(24),
                          // Leaderboard List
                          ...List.generate(
                            leaderboardUsers.length > 3
                                ? leaderboardUsers.length - 3
                                : 0,
                            (i) {
                              final user = leaderboardUsers[i + 3];
                              return _LeaderboardUserTile(
                                rank: user.rank,
                                name: '${user.firstName} ${user.lastName}'
                                    .trim(),
                                xp: user.totalXp,
                                profilePictureUrl: user.profilePictureUrl,
                                onTap: () async {
                                  await context.push(
                                    UserProfileScreen.routeName,
                                    extra: user.user,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}

class _LeaderboardUserTile extends StatelessWidget {
  const _LeaderboardUserTile({
    required this.rank,
    required this.name,
    required this.xp,
    this.profilePictureUrl,
    this.onTap,
  });

  final int rank;
  final String name;
  final int xp;
  final String? profilePictureUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.06),
                Colors.white.withValues(alpha: 0.02),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Rank Number
              SizedBox(
                width: 40,
                child: Text(
                  '$rank',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // Profile Picture
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 24,
                  backgroundImage: profilePictureUrl != null
                      ? FastCachedImageProvider(profilePictureUrl!)
                            as ImageProvider
                      : AssetImage('assets/images/user-placeholder.png')
                            as ImageProvider,
                ),
              ),
              Gap(16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name.isNotEmpty ? name : 'User',
                      style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Gap(16),
              // XP
              Text(
                '$xp XP',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
