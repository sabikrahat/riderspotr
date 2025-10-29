import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/auth/user_model.dart';
import '../../providers/auth/profile_provider.dart';
import '../../providers/car/garage_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/profile_xp_card.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key, required this.id});

  static const String routeName = '/user-profile';

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref
          .watch(profileProvider(widget.id))
          .when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(profileProvider(widget.id).notifier);
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
                            top: MediaQuery.of(context).padding.top,
                            left: 8,
                            child: Back(),
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
                                  if (widget.id !=
                                      Supabase.instance.client.auth.currentUser?.id) ...[
                                    Gap(8),
                                    ElevatedButton.icon(
                                      onPressed: () async => await notifier.followUnfollowUser(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      icon: notifier.isFollowing
                                          ? const Icon(Icons.person_remove)
                                          : const Icon(Icons.person_add),
                                      label: Text(notifier.isFollowing ? 'Remove' : 'ADD'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //
                    Gap(16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 38,
                            margin: const EdgeInsets.only(bottom: 16),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              color: context.theme.dividerColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(45),
                            ),
                            child: TabBar(
                              controller: _tabController,
                              padding: EdgeInsets.zero,
                              indicatorPadding: EdgeInsets.zero,
                              splashBorderRadius: BorderRadius.circular(45),
                              physics: const BouncingScrollPhysics(),
                              indicatorColor: Colors.white,
                              automaticIndicatorColorAdjustment: true,
                              unselectedLabelColor: context.textTheme.titleMedium!.color,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: Colors.black,
                              indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(45),
                              ),
                              dividerColor: Colors.transparent,
                              tabs: [
                                Tab(text: 'Stats'),
                                Tab(text: 'Garage'),
                              ],
                            ),
                          ),
                          IndexedStack(
                            index: _currentTabIndex,
                            children: [
                              _Stats(notifier.user),
                              _Garages(widget.id),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gap(200),
                  ],
                ),
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

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(garageProvider(widget.id))
        .when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (_) {
            final notifier = ref.read(garageProvider(widget.id).notifier);
            final sortedCars = notifier.sortCars(notifier.carSpots, _selectedSort);
            return Column(
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
            );
          },
        );
  }
}

// Sort Dropdown Widget
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
        const Icon(
          Icons.swap_vert_rounded,
          color: Colors.white,
          size: 16,
        ),
        const Gap(4),
        Text(
          'Sort by',
          style: context.textTheme.bodyMedium,
        ),
        const Gap(16),
        DropdownButton<SortOptions>(
          isDense: true,
          value: selectedSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
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
          items: SortOptions.values.map((option) {
            return DropdownMenuItem<SortOptions>(
              value: option,
              child: Text(
                option.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats(this.user);

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        ProfileXPCard(user: user),
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
      ],
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
