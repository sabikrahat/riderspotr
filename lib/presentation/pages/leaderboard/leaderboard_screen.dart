import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/user_stats/user_stats_provider.dart';
import '../../widgets/leaderboard/comparison_bar.dart';
import '../../widgets/leaderboard/summary_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/filter_chips.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/user_tile.dart';
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
                .watch(userStatsProvider)
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                  data: (data) {
                    final notifier = ref.read(userStatsProvider.notifier);
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
                                    style: context.textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.4),
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
                                        color: Colors.black.withValues(alpha: 0.3),
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

                          // Learderboard Bar
                          LeaderboardComparisonBar(
                            firstUid: notifier.userStats[0].user?.id ?? '',
                            firstPlaceImage:
                                notifier.userStats[0].user?.profilePictureUrl ==
                                    null
                                ? 'assets/images/user-placeholder.png'
                                : notifier
                                      .userStats[0]
                                      .user!
                                      .profilePictureUrl!,
                            firstPlaceName:
                                notifier.userStats[0].user?.username ??
                                'firstuser',
                            secondUid: notifier.userStats[1].user?.id ?? '',
                            secondPlaceImage:
                                notifier.userStats[1].user?.profilePictureUrl ==
                                    null
                                ? 'assets/images/user-placeholder.png'
                                : notifier
                                      .userStats[1]
                                      .user!
                                      .profilePictureUrl!,
                            secondPlaceName:
                                notifier.userStats[1].user?.username ??
                                'seconduser',
                            thirdUid: notifier.userStats[2].user?.id ?? '',
                            thirdPlaceImage:
                                notifier.userStats[2].user?.profilePictureUrl ==
                                    null
                                ? 'assets/images/user-placeholder.png'
                                : notifier
                                      .userStats[2]
                                      .user!
                                      .profilePictureUrl!,
                            thirdPlaceName:
                                notifier.userStats[2].user?.username ??
                                'thirduser',
                          ),
                          Gap(16),

                          // Sort Section
                          Row(
                            children: [
                              Text(
                                'Sort by',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                              Gap(12),
                              DropdownButton<String>(
                                isDense: true,
                                value: selectedSort,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedSort = value;
                                    });
                                  }
                                },
                                underline: const SizedBox.shrink(),
                                dropdownColor: Color(0xFF0A0A0A),
                                icon: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  size: 20,
                                ),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                items: sortOptions.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Gap(24),
                          ...List.generate(
                            notifier.otherStats.length,
                            (i) {
                              final userStat = notifier.otherStats[i];
                              final user = userStat.user;
                              return UserTile(
                                user: user,
                                rank: i + 4,
                                xp: userStat.totalPoints,
                                onTap: () async {
                                  await context.push(
                                    UserProfileScreen.routeName,
                                    extra: userStat.user?.id ?? '',
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
