import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/auth/profile_provider.dart';
import '../../providers/car/map_provider.dart';
import '../../widgets/home/feed_card.dart';
import '../../widgets/home/stories_row.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/logo.dart';
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
    final carSpotsAsync = ref.watch(mapProvider);
    final profileAsync = ref.watch(profileProvider(null));

    return Scaffold(
      body: CarbonBackground(
        imgPath: 'assets/carbon/47.jpg',
        heightPercent: 0.35,
        opacity: 0.25,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 20,
              //     vertical: 16,
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       // Logo
              //       SizedBox(width: 200, child: Logo()),
              //       // const Gap(20),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 200, child: Logo()),
                    Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Stories Row
              const StoriesRow(),

              const Gap(16),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTabBar(),
              ),
              const Gap(0),

              // Feed Content
              Expanded(
                child: carSpotsAsync.when(
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
                          'No spots yet',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    }

                    return profileAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white24,
                          strokeWidth: 2,
                        ),
                      ),
                      error: (_, __) => _buildTabBarView(carSpots, null),
                      data: (_) {
                        final profile = ref
                            .read(profileProvider(null).notifier)
                            .user;
                        return _buildTabBarView(carSpots, profile?.country);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarView(List<CarSpotModel> carSpots, String? userCountry) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildFeedList(carSpots, 'global', userCountry),
        _buildFeedList(carSpots, 'country', userCountry),
        _buildFeedList(carSpots, 'friends', userCountry),
      ],
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 44,
      child: TabBar(
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
    );
  }

  Widget _buildFeedList(
    List<CarSpotModel> allCarSpots,
    String feedType,
    String? userCountry,
  ) {
    // Filter based on tab
    List<CarSpotModel> filteredSpots;

    switch (feedType) {
      case 'country':
        // Filter by user's country if available
        if (userCountry != null) {
          filteredSpots = allCarSpots.where((spot) {
            final spotCountry = spot.location?['country'];
            return spotCountry != null && spotCountry == userCountry;
          }).toList();
        } else {
          filteredSpots = allCarSpots;
        }
        break;
      case 'friends':
        // TODO: Implement friends filtering when friends feature is ready
        // For now, show user's own spots
        filteredSpots = allCarSpots;
        break;
      case 'global':
      default:
        filteredSpots = allCarSpots;
        break;
    }

    // Sort by most recent
    filteredSpots.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (filteredSpots.isEmpty) {
      return Center(
        child: Text(
          feedType == 'country'
              ? 'No spots in your country yet'
              : feedType == 'friends'
              ? 'No spots from friends yet'
              : 'No spots yet',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(mapProvider.notifier).refresh();
      },
      backgroundColor: Colors.grey.shade900,
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: filteredSpots.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: FeedCard(
              carSpot: filteredSpots[index],
              onLike: () {
                // TODO: Implement like functionality with backend
              },
            ),
          );
        },
      ),
    );
  }
}
