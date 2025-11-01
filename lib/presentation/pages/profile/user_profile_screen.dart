import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/auth/profile_provider.dart';
import '../../widgets/profile/profile_stats_section.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/car_card.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key, required this.id});

  static const String routeName = '/user-profile';

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _currentTabIndex = 0;

  void _initializeTabController(bool isGaragePrivate) {
    final tabLength = isGaragePrivate ? 1 : 2;
    if (_tabController?.length != tabLength) {
      _tabController?.dispose();
      _tabController = TabController(length: tabLength, vsync: this);
      _tabController!.addListener(_handleTabChange);
      _currentTabIndex = 0;
    }
  }

  void _handleTabChange() {
    if (_tabController?.indexIsChanging ?? true) return;
    setState(() {
      _currentTabIndex = _tabController!.index;
    });
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabChange);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: ref
          .watch(profileProvider(widget.id))
          .when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(profileProvider(widget.id).notifier);
              final user = notifier.user;
              final isGaragePrivate = user?.isGaragePrivate ?? false;

              // Initialize tab controller based on garage privacy
              _initializeTabController(isGaragePrivate);

              // Determine which banner to show
              final bannerImage = user?.bannerUrl != null
                  ? FastCachedImageProvider(user!.bannerUrl!) as ImageProvider
                  : AssetImage('assets/carbon/leaderboard-bg.jpg')
                        as ImageProvider;

              return Stack(
                children: [
                  // Banner Background with Gradient
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image(
                          image: bannerImage,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 0.6, 1.0],
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.5),
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable Content
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section with Profile
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                // Back Button
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Back(),
                                ),
                                // Gap(32),
                                // Profile Picture
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 20,
                                        offset: Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        user?.profilePictureUrl == null
                                        ? AssetImage(
                                            'assets/images/user-placeholder.png',
                                          )
                                        : FastCachedImageProvider(
                                                user!.profilePictureUrl!,
                                              )
                                              as ImageProvider,
                                  ),
                                ),
                                Gap(16),
                                // Name
                                Text(
                                  user?.fullName ?? 'Full Name',
                                  style: context.textTheme.headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Gap(4),
                                // Username
                                Text(
                                  '@${user?.username ?? 'username'}',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                // Follow Button
                                if (widget.id !=
                                    Supabase
                                        .instance
                                        .client
                                        .auth
                                        .currentUser
                                        ?.id) ...[
                                  Gap(16),
                                  GestureDetector(
                                    onTap: () async =>
                                        await notifier.followUnfollowUser(),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: notifier.isFollowing
                                              ? [
                                                  Colors.white.withValues(
                                                    alpha: 0.08,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.03,
                                                  ),
                                                ]
                                              : [
                                                  Colors.white.withValues(
                                                    alpha: 0.15,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: 0.08,
                                                  ),
                                                ],
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            notifier.isFollowing
                                                ? Icons.person_remove
                                                : Icons.person_add,
                                            size: 16,
                                            color: Colors.white.withValues(
                                              alpha: 0.9,
                                            ),
                                          ),
                                          Gap(8),
                                          Text(
                                            notifier.isFollowing
                                                ? 'Following'
                                                : 'Follow',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.3,
                                              color: Colors.white.withValues(
                                                alpha: 0.9,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        // Tab Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _tabController?.animateTo(0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'STATS',
                                      style: TextStyle(
                                        color: _currentTabIndex == 0
                                            ? Colors.white
                                            : Colors.white.withValues(
                                                alpha: 0.5,
                                              ),
                                        fontWeight: _currentTabIndex == 0
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        fontSize: 12,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 2,
                                      width: 20,
                                      decoration: BoxDecoration(
                                        color: _currentTabIndex == 0
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!isGaragePrivate) ...[
                                Gap(32),
                                GestureDetector(
                                  onTap: () => _tabController?.animateTo(1),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'GARAGE',
                                        style: TextStyle(
                                          color: _currentTabIndex == 1
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                          fontWeight: _currentTabIndex == 1
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 12,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        height: 2,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: _currentTabIndex == 1
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Gap(24),
                        // Tab Content
                        IndexedStack(
                          index: _currentTabIndex,
                          children: isGaragePrivate
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: ProfileStatsSection(
                                      user: notifier.user,
                                      carSpots: notifier.carSpots,
                                    ),
                                  ),
                                ]
                              : [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: ProfileStatsSection(
                                      user: notifier.user,
                                      carSpots: notifier.carSpots,
                                    ),
                                  ),
                                  _Garages(widget.id),
                                ],
                        ),
                        Gap(100),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

class _Garages extends ConsumerStatefulWidget {
  const _Garages(this.id);

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __GaragesState();
}

class __GaragesState extends ConsumerState<_Garages> {
  SortOptions _selectedSort = SortOptions.recent;

  void _onSortChanged(SortOptions sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

  List<CarSpotModel> _sortCars(
    List<CarSpotModel> cars,
    SortOptions sortBy,
  ) {
    final sortedCars = List<CarSpotModel>.from(cars);

    switch (sortBy) {
      case SortOptions.recent:
        sortedCars.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOptions.oldest:
        sortedCars.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOptions.alphabetical:
        sortedCars.sort((a, b) {
          final carNameA = a.car?.model ?? '';
          final carNameB = b.car?.model ?? '';
          return carNameA.compareTo(carNameB);
        });
        break;
      case SortOptions.alphabeticalReverse:
        sortedCars.sort((a, b) {
          final carNameA = a.car?.model ?? '';
          final carNameB = b.car?.model ?? '';
          return carNameB.compareTo(carNameA);
        });
        break;
    }

    return sortedCars;
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(profileProvider(widget.id))
        .when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (_) {
            final notifier = ref.read(profileProvider(widget.id).notifier);
            final carSpots = notifier.carSpots;
            final sortedCars = _sortCars(carSpots, _selectedSort);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _SortDropdown(
                    selectedSort: _selectedSort,
                    onSortChanged: _onSortChanged,
                  ),
                  const Gap(16),
                  ...List.generate(
                    sortedCars.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: CarCard(
                        carSpot: sortedCars[index],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}

// Sort Dropdown Widget - Luxury Style
class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.selectedSort,
    required this.onSortChanged,
  });

  final SortOptions selectedSort;
  final void Function(SortOptions) onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Sort by',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const Gap(12),
        DropdownButton<SortOptions>(
          isDense: true,
          value: selectedSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
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
          items: SortOptions.values.map((option) {
            return DropdownMenuItem<SortOptions>(
              value: option,
              child: Text(option.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
