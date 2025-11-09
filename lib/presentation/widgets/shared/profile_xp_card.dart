import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/user/user_model.dart';
import '../../../models/user/xp_level_model.dart';
import '../../providers/auth/xp_level_provider.dart';

class ProfileXPCard extends ConsumerWidget {
  const ProfileXPCard({
    super.key,
    required this.user,
  });

  final UserModel? user;

  // Calculate current XP progress based on xp_levels table
  Map<String, dynamic> _calculateProgress(
    int totalXp,
    int currentLevel,
    List<XpLevelModel> xpLevels,
  ) {
    // Find the current level's cumulative XP requirement
    final currentLevelData = xpLevels.firstWhere(
      (level) => level.level == currentLevel,
      orElse: () => xpLevels.first,
    );

    // Find the next level's cumulative XP requirement
    final nextLevelData = xpLevels.firstWhere(
      (level) => level.level == currentLevel + 1,
      orElse: () => xpLevels.last,
    );

    final currentLevelCumulativeXp = currentLevelData.xpCumulative;
    final nextLevelCumulativeXp = nextLevelData.xpCumulative;
    final xpRequiredForNextLevel =
        nextLevelCumulativeXp - currentLevelCumulativeXp;
    final xpInCurrentLevel = totalXp - currentLevelCumulativeXp;
    final progress = (xpInCurrentLevel / xpRequiredForNextLevel).clamp(
      0.0,
      1.0,
    );
    final progressPercent = (progress * 100).toInt();

    return {
      'progress': progress,
      'progressPercent': progressPercent,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpLevelsAsync = ref.watch(xpLevelsProvider);

    return xpLevelsAsync.when(
      loading: () => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.06),
              Colors.white.withValues(alpha: 0.02),
            ],
          ),
        ),
        child: Text('Unable to load XP data'),
      ),
      data: (xpLevels) {
        final totalXp = user?.stats?.totalXp ?? 0;
        final currentLevel = user?.stats?.level ?? 0;
        final progressData = _calculateProgress(
          totalXp,
          currentLevel,
          xpLevels,
        );
        final progress = progressData['progress'] as double;
        final progressPercent = progressData['progressPercent'] as int;

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
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
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // XP Icon and Level
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.15),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.electric_bolt,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Gap(16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LEVEL $currentLevel',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                      Gap(4),
                      Text(
                        '${totalXp.toInt()} XP',
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(20),
              // Progress Bar Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress to Level ${currentLevel + 1}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.3,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                      ),
                      Text(
                        '$progressPercent%',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.9),
                                      Colors.white.withValues(alpha: 0.7),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
