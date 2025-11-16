import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../providers/auth/profile_provider.dart';
import '../../providers/feed/feed_provider.dart';
import '../../widgets/home/feed_card.dart';
import '../../widgets/home/stories_row.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/logo.dart';
import '../leaderboard/leaderboard_screen.dart';
import '../payment/payment_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.isFinishRegister = false});

  static const String routeName = '/home';
  final bool isFinishRegister;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    if (widget.isFinishRegister) {
      // Show payment screen after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.push(PaymentScreen.routeName);
        }
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider(null));

    return Scaffold(
      body: CarbonBackground(
        imgPath: 'assets/carbon/47.jpg',
        heightPercent: 0.35,
        opacity: 0.25,
        child: SafeArea(
          child: profileAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Colors.white24,
                strokeWidth: 2,
              ),
            ),
            error: (_, __) => _buildNestedScrollView(null),
            data: (_) {
              final profile = ref.read(profileProvider(null).notifier).user;
              return _buildNestedScrollView(profile?.country);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNestedScrollView(String? userCountry) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 200, child: Logo()),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push(LeaderboardScreen.routeName),
                        child: Icon(
                          Icons.leaderboard_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const Gap(16),
                      Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                const Gap(16),

                // Stories Row
                const StoriesRow(),

                const Gap(16),
              ],
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 16),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
                labelStyle: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w300,
                ),
                tabs: const [
                  Tab(text: 'GLOBAL'),
                  Tab(text: 'COUNTRY'),
                  Tab(text: 'FRIENDS'),
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedList(FeedType.global, userCountry),
          _buildFeedList(FeedType.country, userCountry),
          _buildFeedList(FeedType.friends, userCountry),
        ],
      ),
    );
  }

  Widget _buildFeedList(FeedType feedType, String? userCountry) {
    final feedAsync = ref.watch(feedProvider(feedType, userCountry));

    return feedAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(
          color: Colors.white24,
          strokeWidth: 2,
        ),
      ),
      error: (error, stack) => Center(
        child: Text(
          'Error loading feed',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
      data: (carSpots) {
        if (carSpots.isEmpty) {
          return Center(
            child: Text(
              feedType == FeedType.country
                  ? 'No spots in your country yet'
                  : feedType == FeedType.friends
                  ? 'No spots from friends yet'
                  : 'No spots yet',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          );
        }

        final feedNotifier = ref.read(
          feedProvider(feedType, userCountry).notifier,
        );
        final hasMore = feedNotifier.hasMore;

        return RefreshIndicator(
          onRefresh: () async {
            await feedNotifier.refresh();
          },
          backgroundColor: Colors.grey.shade900,
          color: Colors.white,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
                if (hasMore && !feedAsync.isLoading) {
                  feedNotifier.loadMore();
                }
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: carSpots.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                // Show loading indicator at the end
                if (index == carSpots.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white24,
                        strokeWidth: 2,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: FeedCard(
                    carSpot: carSpots[index],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
