import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ridespotr/models/user/user_stats_model.dart';

import '../../../core/extensions.dart';
import 'stat_card.dart';

class StatsGridSection extends StatelessWidget {
  final UserStatsModel? stats;
  const StatsGridSection({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR STATS',
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
                value: '${stats?.totalSpots ?? 0}',
                subtitle: 'Total spots',
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.emoji_events,
                title: 'LEGENDARY',
                value: '${stats?.legendarySpots ?? 0}',
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
                value: '${stats?.uniqueSpots ?? 0}',
                subtitle: 'Unique car spots',
                accentColor: Colors.purple,
              ),
            ),
            Gap(16),
            Expanded(
              child: StatCard(
                icon: Icons.location_on,
                title: 'STREAK',
                value: '${stats?.spottingStreak ?? 0}',
                subtitle: 'Spotting streak',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
