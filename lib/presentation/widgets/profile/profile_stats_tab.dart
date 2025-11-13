import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/auth/profile_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../home/achievements_section.dart';
import 'profile_stats_section.dart';

class ProfileStatsTab extends ConsumerWidget {
  const ProfileStatsTab({super.key, this.userId});

  /// If userId is null, shows the current user's stats
  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwnProfile = userId == null;

    if (isOwnProfile) {
      return ref.watch(profileProvider(null)).when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text(error.toString())),
            data: (_) {
              final profileNotifier = ref.read(profileProvider(null).notifier);
              final user = ref.read(userProvider.notifier).user;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileStatsSection(
                      user: user,
                      carSpots: profileNotifier.carSpots,
                    ),
                    Gap(40),
                    AchievementsSection(
                      user: user,
                      showAll: true,
                    ),
                  ],
                ),
              );
            },
          );
    }

    final notifier = ref.read(profileProvider(userId!).notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileStatsSection(
            user: notifier.user,
            carSpots: notifier.carSpots,
          ),
          Gap(40),
          AchievementsSection(
            user: notifier.user,
            showAll: true,
          ),
        ],
      ),
    );
  }
}

