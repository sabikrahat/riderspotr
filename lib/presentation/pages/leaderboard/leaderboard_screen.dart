import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/providers/leaderboard/leaderboard_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/leaderboard/user_current_rank_provider.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/shared/locked_content.dart';
import '../../widgets/leaderboard/comparison_bar.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/filter_chips.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/profile_xp_card.dart';
import '../profile/profile_screen.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  static const String routeName = '/leaderboard';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String selectedFilter = 'Global';
  final List<String> filters = ['Global', 'Country', 'State', 'Friends'];
  String selectedSort = 'Overall';
  final List<String> sortOptions = [
    'Overall',
    'This Month',
    'This Week',
    'Today',
  ];
  bool isLoadingLeaderboard = false;

  Future<void> _handleFilterChange(String value) async {
    setState(() {
      selectedFilter = value;
      isLoadingLeaderboard = true;
    });

    try {
      if (value == 'Global') {
        // Call the global leaderboard method
        await ref
            .read(leaderboardProviderProvider.notifier)
            .getWorldLeaderboard();
      } else if (value == 'Country') {
        // Call the country leaderboard method
        await ref
            .read(leaderboardProviderProvider.notifier)
            .getCountryLeaderboard();
      } else if (value == 'State') {
        // Call the state leaderboard method
        await ref
            .read(leaderboardProviderProvider.notifier)
            .getStateLeaderboard();
      } else if (value == 'Friends') {
        // Call the friends leaderboard method
        await ref
            .read(leaderboardProviderProvider.notifier)
            .getFriendsLeaderboard();
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadingLeaderboard = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final subscription = ref.watch(subscriptionProvider.notifier);
    final hasLeaderboardAccess = subscription.hasLeaderboardAccess;
    final user = ref.watch(userProvider).value;

    // Determine rank icon and title based on filter
    IconData rankIcon;
    String rankTitle;

    switch (selectedFilter) {
      case 'Country':
        rankIcon = Icons.flag_rounded;
        rankTitle = 'Country';
        break;
      case 'State':
        rankIcon = Icons.location_city_rounded;
        rankTitle = 'State';
        break;
      case 'Friends':
        rankIcon = Icons.people_rounded;
        rankTitle = 'Friends';
        break;
      case 'Global':
      default:
        rankIcon = Icons.language;
        rankTitle = 'Global';
        break;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CarbonBackground(
        imgPath: 'assets/carbon/leaderboard-bg.jpg',
        heightPercent: 0.3,
        child: SafeArea(
          child: PagePadding(
            child: SingleChildScrollView(
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
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Gap(4),
                          Text(
                            'Global Rankings',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(
                                alpha: 0.4,
                              ),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      // Rank Badge
                      ref
                          .watch(userCurrentRankProvider(selectedFilter))
                          .when(
                            loading: () => _RankBadge(
                              icon: rankIcon,
                              title: rankTitle,
                              rank: null,
                              isLoading: true,
                            ),
                            error: (_, __) => _RankBadge(
                              icon: rankIcon,
                              title: rankTitle,
                              rank: null,
                              isLoading: false,
                            ),
                            data: (rank) => _RankBadge(
                              icon: rankIcon,
                              title: rankTitle,
                              rank: rank,
                              isLoading: false,
                            ),
                          ),
                    ],
                  ),
                  Gap(32),

                  // Clean Filter Chips
                  FilterChips(
                    options: filters,
                    selectedValue: selectedFilter,
                    onChanged: _handleFilterChange,
                  ),
                  Gap(24),

                  // Profile XP Card
                  ProfileXPCard(user: user),
                  Gap(16),

                  // Leaderboard content with separate loading
                  ref
                      .watch(leaderboardProviderProvider)
                      .when(
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                        data: (_) => const SizedBox.shrink(),
                      ),

                  // Loading or Leaderboard List
                  if (isLoadingLeaderboard)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else
                    ref
                        .watch(leaderboardProviderProvider)
                        .when(
                          loading: () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(40.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          error: (error, stack) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text('Error: $error'),
                            ),
                          ),
                          data: (leaderboardUsers) {
                            if (!hasLeaderboardAccess) {
                              return Column(
                                children: [
                                  const LockedContent(
                                    title: 'LEADERBOARD\nLOCKED',
                                    description:
                                        'Upgrade to view full leaderboard\nand compete with other players.',
                                  ),
                                ],
                              );
                            }

                            // Full leaderboard for paid users
                            return Column(
                              children: [
                                // Leaderboard Bar
                                if (leaderboardUsers.length >= 3)
                                  LeaderboardComparisonBar(
                                    firstPlace: leaderboardUsers[0],
                                    secondPlace: leaderboardUsers[1],
                                    thirdPlace: leaderboardUsers[2],
                                  ),
                                if (leaderboardUsers.length >= 3) const Gap(16),

                                // Leaderboard List
                                ...List.generate(
                                  leaderboardUsers.length > 3
                                      ? leaderboardUsers.length - 3
                                      : 0,
                                  (i) {
                                    final user = leaderboardUsers[i + 3];
                                    final isCurrentUser =
                                        currentUserId != null &&
                                        user.user == currentUserId;
                                    return _LeaderboardUserTile(
                                      rank: user.rank,
                                      name: '${user.firstName} ${user.lastName}'
                                          .trim(),
                                      xp: user.totalXp,
                                      profilePictureUrl: user.profilePictureUrl,
                                      isCurrentUser: isCurrentUser,
                                      onTap: () async {
                                        await context.push(
                                          ProfileScreen.userProfileRouteName,
                                          extra: user.user,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                ],
              ),
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
    this.isCurrentUser = false,
    this.onTap,
  });

  final int rank;
  final String name;
  final int xp;
  final String? profilePictureUrl;
  final bool isCurrentUser;
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
              colors: isCurrentUser
                  ? [
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.06),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.06),
                      Colors.white.withValues(alpha: 0.02),
                    ],
            ),
            border: isCurrentUser
                ? Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: isCurrentUser ? 0.5 : 0.4,
                ),
                blurRadius: isCurrentUser ? 20 : 16,
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

class _RankBadge extends StatelessWidget {
  const _RankBadge({
    required this.icon,
    required this.title,
    required this.rank,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final int? rank;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 8,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
            ),
          ),
          Gap(2),
          isLoading
              ? SizedBox(
                  width: 24,
                  height: 16,
                  child: Center(
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                )
              : Text(
                  rank == null ? 'N/A' : '#$rank',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -0.5,
                  ),
                ),
        ],
      ),
    );
  }
}
