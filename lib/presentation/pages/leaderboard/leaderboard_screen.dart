import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/user_stats/user_stats_provider.dart';
import '../../widgets/leaderboard/comparison_bar.dart';
import '../../widgets/leaderboard/summary_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../profile/profile_screen.dart';
import 'search_friend.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  static const String routeName = '/leaderboard';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String selectedFilter = 'Global';
  final List<String> filters = ['Global', 'Country', 'City', 'Friends', 'Following', 'You'];
  String selectedSort = 'Overall';
  final List<String> sortOptions = ['Overall', 'This Month', 'This Week', 'Today'];

  @override
  Widget build(BuildContext context) {
    return CarbonBackground(
      imgPath: 'assets/carbon/leaderboard-bg.jpg',
      child: PagePadding(
        child: ref
            .watch(userStatsProvider)
            .when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
              data: (data) {
                final notifier = ref.read(userStatsProvider.notifier);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('LEADERBOARD', style: context.textTheme.headlineMedium),
                          InkWell(
                            borderRadius: BorderRadius.circular(45),
                            onTap: () async => await context.push(SearchFriendScreen.routeName),
                            child: Icon(
                              Icons.person_add_alt_1_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      Gap(24),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: filters.map((filter) {
                            final isSelected = selectedFilter == filter;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(filter),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    selectedFilter = filter;
                                  });
                                },
                                labelStyle: TextStyle(
                                  color: isSelected ? Colors.black : Colors.white,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                                backgroundColor: Colors.grey[900],
                                selectedColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                    color: isSelected ? Colors.white : Colors.grey[800]!,
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Gap(16),

                      // Summary Card
                      LeaderboardSummaryCard(),
                      Gap(16),

                      // Learderboard Bar
                      LeaderboardComparisonBar(
                        firstUid: notifier.userStats[0].user?.id ?? '',
                        firstPlaceImage: notifier.userStats[0].user?.profilePictureUrl == null
                            ? 'assets/images/user-placeholder.png'
                            : notifier.userStats[0].user!.profilePictureUrl!,
                        firstPlaceName: notifier.userStats[0].user?.username ?? 'firstuser',
                        secondUid: notifier.userStats[1].user?.id ?? '',
                        secondPlaceImage: notifier.userStats[1].user?.profilePictureUrl == null
                            ? 'assets/images/user-placeholder.png'
                            : notifier.userStats[1].user!.profilePictureUrl!,
                        secondPlaceName: notifier.userStats[1].user?.username ?? 'seconduser',
                        thirdUid: notifier.userStats[2].user?.id ?? '',
                        thirdPlaceImage: notifier.userStats[2].user?.profilePictureUrl == null
                            ? 'assets/images/user-placeholder.png'
                            : notifier.userStats[2].user!.profilePictureUrl!,
                        thirdPlaceName: notifier.userStats[2].user?.username ?? 'thirduser',
                      ),
                      Gap(16),

                      // Sort Options
                      Row(
                        children: [
                          Icon(
                            Icons.swap_vert_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          Gap(4),
                          Text(
                            'Sort by',
                            style: context.textTheme.bodyMedium,
                          ),
                          Gap(16),
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
                            dropdownColor: Colors.grey[900],
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                              size: 20,
                            ),
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            items: sortOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      Gap(16),
                      ...List.generate(
                        notifier.otherStats.length,
                        (i) {
                          final userStat = notifier.otherStats[i];
                          final user = userStat.user;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  user?.bannerUrl == null
                                      ? Image.asset(
                                          'assets/carbon/leaderboard-bg.jpg',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 100,
                                        )
                                      : Image.network(
                                          user?.bannerUrl ?? '',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 100,
                                        ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
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
                                          InkWell(
                                            borderRadius: BorderRadius.circular(30),
                                            onTap: () async {
                                              await context.push(
                                                ProfileScreen.routeName,
                                                extra: userStat.user?.id ?? '',
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: user?.profilePictureUrl == null
                                                  ? AssetImage(
                                                      'assets/images/user-placeholder.png',
                                                    )
                                                  : const NetworkImage(
                                                      'https://picsum.photos/200',
                                                    ),
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
                                                  "@${user?.username ?? 'username'}",
                                                  style: context.textTheme.bodyMedium?.copyWith(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '#',
                                                style: context.textTheme.bodyMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  height: 1.5,
                                                ),
                                              ),
                                              Gap(1),
                                              Text(
                                                '${i + 4}',
                                                style: context.textTheme.bodyMedium?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w600,
                                                  height: 1.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }
}
