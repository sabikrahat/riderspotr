import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/scan_detail_params.dart';
import '../../../models/user/xp_level_model.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../providers/auth/xp_level_provider.dart';
import '../../widgets/capture/xp_progression_card.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/rarity_badge.dart';
import '../garage/garage_screen.dart';
import 'car_detail_screen.dart';
import 'report_car_screen.dart';

class ScanDeatilScreen extends ConsumerStatefulWidget {
  static const String routeName = '/scan-detail';
  const ScanDeatilScreen({
    super.key,
    required this.params,
  });

  final ScanDetailParams params;

  @override
  ConsumerState<ScanDeatilScreen> createState() => _ScanDeatilScreenState();
}

class _ScanDeatilScreenState extends ConsumerState<ScanDeatilScreen> {
  // Calculate XP and level progression using actual level data
  Map<String, dynamic> _calculateXPProgression(
    int currentTotalXP,
    int currentLevel,
    int xpToAdd,
    List<XpLevelModel> xpLevels,
  ) {
    if (xpLevels.isEmpty) {
      return {
        'newLevel': currentLevel,
        'newProgress': 0.0,
        'levelsGained': 0,
        'xpInCurrentLevel': 0,
      };
    }

    int newTotalXP = currentTotalXP + xpToAdd;
    int newLevel = 0;

    // Find the new level based on cumulative XP
    for (var level in xpLevels) {
      if (newTotalXP >= level.xpCumulative) {
        newLevel = level.level;
      } else {
        break;
      }
    }

    int levelsGained = newLevel - currentLevel;

    // Calculate progress to next level
    double newProgress = 0.0;
    int xpInCurrentLevel = 0;
    int xpRequiredForNextLevel = 0;

    // Get cumulative XP at current level (0 if level 0)
    int xpAtLevelStart = 0;
    if (newLevel > 0) {
      final currentLevelData = xpLevels.firstWhere(
        (l) => l.level == newLevel,
        orElse: () => xpLevels.first,
      );
      xpAtLevelStart = currentLevelData.xpCumulative;
    }

    // XP progress within current level
    xpInCurrentLevel = newTotalXP - xpAtLevelStart;

    // Find next level's required XP
    final nextLevelIndex = xpLevels.indexWhere((l) => l.level == newLevel + 1);
    if (nextLevelIndex != -1) {
      xpRequiredForNextLevel = xpLevels[nextLevelIndex].xpRequired;
      if (xpRequiredForNextLevel > 0) {
        newProgress = xpInCurrentLevel / xpRequiredForNextLevel;
      }
    }

    return {
      'newLevel': newLevel,
      'newProgress': newProgress.clamp(0.0, 1.0),
      'levelsGained': levelsGained,
      'xpInCurrentLevel': xpInCurrentLevel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.params.carSpot?.car;
    final rarity = car?.rarity;
    final rarityColor = rarity?.color ?? Colors.grey;
    // If manual upload, XP is 0, otherwise use car's actual points
    final points = widget.params.isManual ? 0 : (car?.points ?? 0);
    final userAsync = ref.watch(userProvider);
    final xpLevelsAsync = ref.watch(xpLevelsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        actions: [
          IconButton(
            icon: Icon(
              Icons.flag,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
            onPressed: () {
              if (widget.params.carSpot != null) {
                context.push(
                  ReportCarScreen.routeName,
                  extra: widget.params.carSpot,
                );
              }
            },
            tooltip: 'Report car',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image with Overlay
          Positioned.fill(
            child: Stack(
              children: [
                Image.network(
                  widget.params.carSpot!.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                // Vignette effect
                Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                // Top gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // Bottom gradient
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.95),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rarity Badge
                      if (rarity != null) RarityBadge(rarity: rarity),
                      Gap(16),
                      // Car Make
                      Text(
                        car?.make?.name.toUpperCase() ?? 'UNKNOWN',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3,
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      Gap(2),
                      // Car Model
                      Text(
                        car?.model?.toUpperCase() ?? '',
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: 28,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                // Bottom Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // XP Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: rarityColor.withValues(alpha: 0.1),
                              blurRadius: 30,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: xpLevelsAsync.when(
                          loading: () => SizedBox(
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: rarityColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          error: (_, __) => SizedBox(
                            height: 60,
                            child: Center(
                              child: Text(
                                'Unable to load XP data',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                          data: (xpLevels) {
                            return userAsync.when(
                              loading: () => SizedBox(
                                height: 60,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: rarityColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              error: (_, __) => SizedBox(
                                height: 60,
                                child: Center(
                                  child: Text(
                                    'Unable to load user data',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              data: (user) {
                                final stats = user?.stats;
                                final currentProgress =
                                    stats?.xpToNextLevelProgress ?? 0.0;
                                final currentLevel = stats?.level ?? 0;
                                final currentTotalXP = stats?.totalXp ?? 0;

                                // Calculate projected progression using real XP levels
                                final progression = _calculateXPProgression(
                                  currentTotalXP,
                                  currentLevel,
                                  points,
                                  xpLevels,
                                );

                                final newLevel = progression['newLevel'] as int;
                                final newProgress =
                                    progression['newProgress'] as double;

                                return XpProgressionCard(
                                  rarityColor: rarityColor,
                                  points: points,
                                  currentLevel: currentLevel,
                                  currentProgress: currentProgress,
                                  newLevel: newLevel,
                                  newProgress: newProgress,
                                  xpLevels: xpLevels,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      Gap(12),

                      // Action Buttons
                      Row(
                        children: [
                          // Retake Button
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.08),
                                    Colors.white.withValues(alpha: 0.03),
                                  ],
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      final garageNotifier = ref.read(
                                        garageProvider(null).notifier,
                                      );
                                      await garageNotifier.deleteCar(
                                        widget.params.carSpot!.id,
                                      );
                                      if (!context.mounted) return;
                                      context.pop();
                                    } catch (e) {
                                      showErrorMessage(
                                        'Error deleting car spot: $e',
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.refresh_rounded,
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          size: 20,
                                        ),
                                        Gap(8),
                                        Text(
                                          'RETAKE',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 1.5,
                                                color: Colors.white.withValues(
                                                  alpha: 0.7,
                                                ),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gap(12),
                          // Claim Button
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    rarityColor,
                                    rarityColor.withValues(alpha: 0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: rarityColor.withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    try {
                                      final garageNotifier = ref.read(
                                        garageProvider(null).notifier,
                                      );
                                      await garageNotifier.claimCar(
                                        widget.params.carSpot!.id,
                                      );
                                      // Refresh user stats
                                      await ref
                                          .read(userProvider.notifier)
                                          .refreshUser();
                                      showSuccessMessage(
                                        'Car spot claimed successfully!',
                                      );
                                      if (!context.mounted) return;
                                      // Pop all screens and navigate to garage
                                      context.go(GarageScreen.routeName);
                                    } catch (e) {
                                      showErrorMessage(
                                        'Error claiming car spot: $e',
                                      );
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        Gap(8),
                                        Text(
                                          'CLAIM',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 2,
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Gap(8),

                      // Details Button
                      Container(
                        width: double.infinity,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.push(
                              CarDetailScreen.routeName,
                              extra: widget.params.carSpot,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Text(
                                'VIEW DETAILS',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.5,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
