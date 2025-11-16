import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/widgets/shared/back.dart';

import '../../../core/extensions.dart';
import '../../providers/search/search_provider.dart';
import '../../providers/search/user_search_provider.dart';
import '../../widgets/shared/search_text_field.dart';
import '../../widgets/shared/simple_user_tile.dart';
import '../capture/car_preview_screen.dart';
import '../profile/profile_screen.dart';

class SearchFriendScreen extends ConsumerStatefulWidget {
  const SearchFriendScreen({super.key});

  static const String routeName = '/search-friend';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchFriendScreenState();
}

class _SearchFriendScreenState extends ConsumerState<SearchFriendScreen>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  late TabController _tabController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _isSearching = value.isNotEmpty;
    });

    // Trigger search based on active tab
    if (_tabController.index == 0) {
      // Cars tab
      ref.read(searchProvider.notifier).search(value);
    } else {
      // Friends tab
      ref.read(userSearchProvider.notifier).search(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'DISCOVER',
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SearchTextField(
              controller: _searchController,
              hintText: 'Search...',
              onChanged: _onSearchChanged,
              showClearButton: _isSearching,
              onClear: () {
                _searchController.clear();
                setState(() {
                  _isSearching = false;
                });
                // Reset to featured content
                _onSearchChanged('');
              },
            ),
          ),
          const Gap(16),
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                insets: EdgeInsets.symmetric(horizontal: 40),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.4),
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
              ),
              tabs: const [
                Tab(text: 'CARS'),
                Tab(text: 'FRIENDS'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCarsTab(),
                _buildFriendsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarsTab() {
    return ref
        .watch(searchProvider)
        .when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.white24,
              strokeWidth: 2,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading spots',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          data: (carSpots) {
            if (carSpots.isEmpty) {
              return Center(
                child: Text(
                  'No car spots found',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.only(top: 2),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1,
              ),
              itemCount: carSpots.length,
              itemBuilder: (context, index) {
                final carSpot = carSpots[index];
                return GestureDetector(
                  onTap: () {
                    context.push(
                      CarPreviewScreen.routeName,
                      extra: carSpot,
                    );
                  },
                  child: FastCachedImage(
                    key: Key(carSpot.id),
                    url: carSpot.imageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    errorBuilder: (context, exception, stacktrace) {
                      return Container(
                        color: Colors.grey.shade900,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                            size: 32,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, progress) {
                      return Container(
                        color: Colors.grey.shade900,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white24,
                            value: progress.progressPercentage.value,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        );
  }

  Widget _buildFriendsTab() {
    return ref
        .watch(userSearchProvider)
        .when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: Colors.white24,
              strokeWidth: 2,
            ),
          ),
          error: (error, stack) => Center(
            child: Text(
              'Error loading users',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
          data: (users) {
            if (users.isEmpty) {
              return Center(
                child: Text(
                  'No users found',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return SimpleUserTile(
                  user: user,
                  onTap: () {
                    context.push(
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
