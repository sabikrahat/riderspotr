import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import 'achievement_card.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECENT ACHIEVEMENTS',
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

