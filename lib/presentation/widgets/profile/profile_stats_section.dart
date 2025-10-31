import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/auth/user_model.dart';
import '../home/achievement_card.dart';
import '../home/stat_card.dart';
import '../shared/profile_xp_card.dart';
import 'garage_value_card.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({
    super.key,
    required this.user,
  });

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
        GarageValueCard(),
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
                value: '247',
                subtitle: '+12 this week',
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                title: 'LEGENDARY',
                value: '8',
                subtitle: 'Top 3%',
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
                icon: Icons.diamond_outlined,
                title: 'RARITY SCORE',
                value: '9.2k',
                subtitle: 'Elite hunter',
                accentColor: Colors.purple,
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.location_on,
                title: 'LOCATIONS',
                value: '34',
                subtitle: '5 countries',
              ),
            ),
          ],
        ),
        const Gap(40),

        // Achievements Section (from home page)
        Text(
          'ACHIEVEMENTS',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Gap(16),
        AchievementCard(
          title: 'Elite Spotter',
          description: 'Spotted 200+ vehicles',
          progress: 0.85,
          icon: Icons.military_tech,
        ),
        Gap(16),
        AchievementCard(
          title: 'Legendary Hunter',
          description: 'Find 10 legendary cars',
          progress: 0.6,
          icon: Icons.star,
        ),
      ],
    );
  }
}
