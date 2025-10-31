import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import 'task_card.dart';

class DailyTasksSection extends StatelessWidget {
  const DailyTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DAILY TASKS',
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                letterSpacing: 3,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to tasks page
              },
              child: Row(
                children: [
                  Text(
                    'View All',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Gap(6),
                  Icon(
                    Icons.arrow_forward,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(16),
        SizedBox(
          height: 180,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              TaskCard(
                title: 'Spot Your First Car',
                description: 'Capture any vehicle on the map',
                xpReward: 50,
                icon: Icons.camera_alt,
                isCompleted: false,
              ),
              Gap(12),
              TaskCard(
                title: 'Daily Login',
                description: 'Open the app every day',
                xpReward: 25,
                icon: Icons.login,
                isCompleted: true,
              ),
              Gap(12),
              TaskCard(
                title: 'Share a Spot',
                description: 'Share your capture with friends',
                xpReward: 100,
                icon: Icons.share,
                isCompleted: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

