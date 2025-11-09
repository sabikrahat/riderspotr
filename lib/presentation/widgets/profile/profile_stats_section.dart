import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/user/user_model.dart';
import '../home/stat_card.dart';
import '../shared/profile_xp_card.dart';
import 'garage_value_card.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({
    super.key,
    required this.user,
    required this.carSpots,
  });

  final UserModel? user;
  final List<CarSpotModel> carSpots;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // XP Card
        ProfileXPCard(user: user),
        const Gap(16),

        // Garage Value Card
        GarageValueCard(carSpots: carSpots),
        const Gap(40),

        // Stats Grid Section (from home page)
        Text(
          'STATS',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Gap(16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.directions_car,
                title: 'SPOTTED',
                value: '${user?.stats?.totalSpots ?? 0}',
                subtitle: 'Total spots',
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                title: 'LEGENDARY',
                value: '${user?.stats?.legendarySpots ?? 0}',
                subtitle: 'Legendary spots',
                accentColor: Colors.amber,
              ),
            ),
          ],
        ),
        Gap(16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                icon: Icons.numbers,
                title: 'UNIQUE',
                value: '${user?.stats?.uniqueSpots ?? 0}',
                subtitle: 'Unique car spots',
                accentColor: Colors.purple,
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.location_on,
                title: 'STREAK',
                value: '${user?.stats?.spottingStreak ?? 0}',
                subtitle: 'Spotting streak',
              ),
            ),
          ],
        ),
        // const Gap(40),
      ],
    );
  }
}
