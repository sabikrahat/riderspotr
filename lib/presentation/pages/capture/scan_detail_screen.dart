import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/rarity_badge.dart';
import 'car_detail_screen.dart';

class ScanDeatilScreen extends ConsumerWidget {
  static const String routeName = '/scan-detail';
  const ScanDeatilScreen({super.key, required this.carSpot});

  final CarSpotModel? carSpot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final car = carSpot?.car;
    final rarity = car?.rarity;
    final rarityColor = rarity?.color ?? Colors.grey;
    final points = car?.points ?? 0;
    final userAsync = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: Stack(
        children: [
          // Background Image with Overlay
          Positioned.fill(
            child: Stack(
              children: [
                Image.network(
                  carSpot!.imageUrl,
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
                        child: userAsync.when(
                          loading: () => SizedBox(
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: rarityColor,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          error: (_, __) => _buildXPContent(
                            context,
                            rarityColor,
                            points,
                            1,
                            0.0,
                          ),
                          data: (user) {
                            final stats = user?.stats;
                            final progress =
                                stats?.xpToNextLevelProgress ?? 0.0;
                            final level = stats?.level ?? 1;

                            return _buildXPContent(
                              context,
                              rarityColor,
                              points,
                              level,
                              progress,
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
                                        carSpot!.id,
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
                                        carSpot!.id,
                                      );
                                      // Refresh user stats
                                      await ref
                                          .read(userProvider.notifier)
                                          .refreshUser();
                                      showSuccessMessage(
                                        'Car spot claimed successfully!',
                                      );
                                      if (!context.mounted) return;
                                      context.pop();
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
                              extra: carSpot,
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

  Widget _buildXPContent(
    BuildContext context,
    Color rarityColor,
    int points,
    int level,
    double progress,
  ) {
    return Column(
      children: [
        // XP Gain
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.electric_bolt_rounded,
              color: rarityColor,
              size: 20,
            ),
            Gap(6),
            Text(
              '+$points XP',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: rarityColor,
                letterSpacing: 1,
                fontSize: 22,
              ),
            ),
          ],
        ),
        Gap(12),
        // Progress Bar
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LEVEL $level',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
                Text(
                  'LEVEL ${level + 1}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            Gap(8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              rarityColor,
                              rarityColor.withValues(alpha: 0.6),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: rarityColor.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
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
    );
  }
}
