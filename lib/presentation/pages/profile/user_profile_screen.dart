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
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/profile_xp_card.dart';

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
              return CarbonBackground(
                imgPath: 'assets/carbon/leaderboard-bg.jpg',
                heightPercent: 0.35,
                child: SingleChildScrollView(
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
                              Gap(32),
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
                                      : NetworkImage(user!.profilePictureUrl!)
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
                      Gap(24),
                      // Tab Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Custom Tab Bar
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _tabController.animateTo(0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Stats',
                                        style: TextStyle(
                                          color: _currentTabIndex == 0
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                          fontWeight: _currentTabIndex == 0
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 14,
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
                                Gap(32),
                                GestureDetector(
                                  onTap: () => _tabController.animateTo(1),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Garage',
                                        style: TextStyle(
                                          color: _currentTabIndex == 1
                                              ? Colors.white
                                              : Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                          fontWeight: _currentTabIndex == 1
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          fontSize: 14,
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
                            ),
                            Gap(32),
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
                      Gap(100),
                    ],
                  ),
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
            final sortedCars = notifier.sortCars(
              notifier.carSpots,
              _selectedSort,
            );
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

class _Stats extends StatelessWidget {
  const _Stats(this.user);

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // XP Card
        ProfileXPCard(user: user),
        const Gap(16),

        // Garage Value Card
        _GarageValueCard(),
        const Gap(24),

        // Core Stats Row
        Row(
          children: [
            Expanded(
              child: _Tile(
                icon: Icons.stars_rounded,
                title: 'Total Spots',
                value: '247',
              ),
            ),
            Gap(12),
            Expanded(
              child: _Tile(
                icon: Icons.emoji_events_rounded,
                title: 'Global Rank',
                value: '#14',
              ),
            ),
            Gap(12),
            Expanded(
              child: _Tile(
                icon: Icons.local_fire_department_rounded,
                title: 'Day Streak',
                value: '12',
              ),
            ),
          ],
        ),
        const Gap(32),

        // Achievements Section
        Text(
          'Achievements',
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
        const Gap(16),

        // Achievement Cards
        _AchievementCard(
          icon: Icons.diamond_rounded,
          title: 'Legendary Spotter',
          description: 'Spotted 3 legendary vehicles',
          value: '3/10',
          accentColor: Color(0xFFFFD700),
        ),
        const Gap(12),
        _AchievementCard(
          icon: Icons.favorite_rounded,
          title: 'Social Butterfly',
          description: '1.2K followers and counting',
          value: '1.2K',
          accentColor: Color(0xFFFF4B8B),
        ),
        const Gap(12),
        _AchievementCard(
          icon: Icons.directions_car_rounded,
          title: 'Car Collector',
          description: '28 cars in your garage',
          value: '28',
          accentColor: Color(0xFF4B9EF3),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white.withValues(alpha: 0.8),
            size: 24,
          ),
          Gap(8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          Gap(4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Garage Value Card Widget
class _GarageValueCard extends StatelessWidget {
  const _GarageValueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Garage Value',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Gap(4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$2.5M',
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Gap(8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '+12%',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '28 Cars',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Gap(20),

          // Simple Line Graph
          _SimpleLineGraph(),
        ],
      ),
    );
  }
}

// Simple Line Graph Widget
class _SimpleLineGraph extends StatelessWidget {
  const _SimpleLineGraph();

  @override
  Widget build(BuildContext context) {
    // Mock data points (6 months)
    final dataPoints = [1.8, 2.0, 1.9, 2.2, 2.3, 2.5];
    final maxValue = 3.0;
    final graphHeight = 60.0;

    return Column(
      children: [
        SizedBox(
          height: graphHeight,
          child: CustomPaint(
            painter: _LineGraphPainter(dataPoints, maxValue),
            child: Container(),
          ),
        ),
        Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '6M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '5M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '4M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '3M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '2M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Now',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Line Graph Painter
class _LineGraphPainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxValue;

  _LineGraphPainter(this.dataPoints, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    if (dataPoints.isEmpty) return;

    final path = Path();
    final fillPath = Path();
    final spacing = size.width / (dataPoints.length - 1);

    // Start paths
    final firstY = size.height - (dataPoints[0] / maxValue * size.height);
    path.moveTo(0, firstY);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, firstY);

    // Draw line and fill
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = size.height - (dataPoints[i] / maxValue * size.height);

      if (i == 0) continue;

      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Close fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill then line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots on line
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = size.height - (dataPoints[i] / maxValue * size.height);

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Achievement Card Widget
class _AchievementCard extends StatelessWidget {
  const _AchievementCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.value,
    this.accentColor,
  });

  final IconData icon;
  final String title;
  final String description;
  final String value;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with circular background
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (accentColor ?? Colors.white).withValues(alpha: 0.2),
                  (accentColor ?? Colors.white).withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: accentColor ?? Colors.white.withValues(alpha: 0.9),
              size: 28,
            ),
          ),
          Gap(16),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                Gap(4),
                Text(
                  description,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Gap(12),
          // Value badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: (accentColor ?? Colors.white).withValues(alpha: 0.15),
            ),
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(
                color: accentColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
