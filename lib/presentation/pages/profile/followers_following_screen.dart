import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/social/followers_following_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/simple_user_tile.dart';
import 'profile_screen.dart';

enum FollowersFollowingTab { followers, following }

class FollowersFollowingScreen extends ConsumerStatefulWidget {
  const FollowersFollowingScreen({
    super.key,
    required this.userId,
    required this.initialTab,
  });

  static const String routeName = '/followers-following';

  final String userId;
  final FollowersFollowingTab initialTab;

  @override
  ConsumerState<FollowersFollowingScreen> createState() =>
      _FollowersFollowingScreenState();
}

class _FollowersFollowingScreenState
    extends ConsumerState<FollowersFollowingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == FollowersFollowingTab.followers
          ? 0
          : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(25),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(text: 'FOLLOWERS'),
                Tab(text: 'FOLLOWING'),
              ],
            ),
          ),
        ),
      ),
      body: CarbonBackground(
        imgPath: 'assets/carbon/leaderboard-bg.jpg',
        child: PagePadding(
          child: TabBarView(
            controller: _tabController,
            children: [
              _FollowersList(userId: widget.userId),
              _FollowingList(userId: widget.userId),
            ],
          ),
        ),
      ),
    );
  }
}

class _FollowersList extends ConsumerWidget {
  const _FollowersList({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followersAsync = ref.watch(followersProvider(userId));

    return followersAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            Gap(16),
            Text(
              'Failed to load followers',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      data: (followers) {
        if (followers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Gap(16),
                Text(
                  'No followers yet',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: 16),
          itemCount: followers.length,
          separatorBuilder: (context, index) => Gap(8),
          itemBuilder: (context, index) {
            final user = followers[index];
            return SimpleUserTile(
              user: user,
              onTap: () async {
                await context.push(
                  ProfileScreen.userProfileRouteName,
                  extra: user.id,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _FollowingList extends ConsumerWidget {
  const _FollowingList({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followingAsync = ref.watch(followingProvider(userId));

    return followingAsync.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            Gap(16),
            Text(
              'Failed to load following',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      data: (following) {
        if (following.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_outlined,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                Gap(16),
                Text(
                  'Not following anyone yet',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: EdgeInsets.only(top: 16),
          itemCount: following.length,
          separatorBuilder: (context, index) => Gap(8),
          itemBuilder: (context, index) {
            final user = following[index];
            return SimpleUserTile(
              user: user,
              onTap: () async {
                await context.push(
                  ProfileScreen.userProfileRouteName,
                  extra: user.id,
                );
              },
            );
          },
        );
      },
    );
  }
}
