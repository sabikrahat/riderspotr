import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/user/user_model.dart';
import 'achievement_card.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({
    super.key,
    this.user,
    this.showAll = false,
  });

  final UserModel? user;
  final bool showAll;

  IconData _getAchievementIcon(String type) {
    switch (type.toLowerCase()) {
      case 'spot':
        return Icons.location_on;
      case 'milestone':
        return Icons.military_tech;
      case 'legendary':
        return Icons.star;
      case 'collection':
        return Icons.collections;
      case 'explorer':
        return Icons.explore;
      default:
        return Icons.emoji_events;
    }
  }

  String _getAchievementDescription(String name, String type) {
    // Generate a description based on the achievement name
    switch (name.toLowerCase()) {
      case 'early bird':
        return 'Spotted a car in the early morning';
      case 'first spot':
        return 'Congratulations on your first spot!';
      case 'midnight hunter':
        return 'Spotted a car after midnight';
      default:
        return 'Achievement unlocked';
    }
  }

  @override
  Widget build(BuildContext context) {
    final achievements = user?.achievements;

    if (achievements == null || achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort achievements by most recent first
    final sortedAchievements = [...achievements]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Show all or just top 5
    final displayAchievements = showAll
        ? sortedAchievements
        : sortedAchievements.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showAll ? 'ACHIEVEMENTS' : 'RECENT ACHIEVEMENTS',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            letterSpacing: 3,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Gap(16),
        ...displayAchievements.map((achievement) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AchievementCard(
              title: achievement.name,
              description: _getAchievementDescription(
                achievement.name,
                achievement.type,
              ),
              icon: _getAchievementIcon(achievement.type),
            ),
          );
        }).toList(),
      ],
    );
  }
}
