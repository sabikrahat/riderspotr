import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import 'stat_card.dart';

class StatsGridSection extends StatelessWidget {
  const StatsGridSection({super.key});

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
      ],
    );
  }
}

