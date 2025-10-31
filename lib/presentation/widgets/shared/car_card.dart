import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../pages/capture/car_detail_screen.dart';

class CarCard extends StatelessWidget {
  final CarSpotModel carSpot;
  const CarCard({required this.carSpot, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          CarDetailScreen.routeName,
          extra: carSpot,
        );
      },
      child: Container(
        height: context.height * 0.28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Car Image
              Positioned.fill(
                child: FastCachedImage(
                  key: Key(carSpot.id),
                  url: carSpot.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 500),
                  errorBuilder: (context, exception, stacktrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                          size: 48,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white24,
                          value: progress.progressPercentage.value,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient Overlay - Bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 180,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black.withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rarity Badge (Top Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withValues(alpha: 0.6),
                          ),
                          child: Text(
                            carSpot.car?.rarity.name.toUpperCase() ?? 'COMMON',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: _getRarityColor(carSpot.car?.rarity.name),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    // Car Name
                    Text(
                      (carSpot.car?.make?.name ?? '').toUpperCase(),
                      style: context.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                    Gap(2),
                    Text(
                      (carSpot.car?.model ?? '').toUpperCase(),
                      style: context.textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                    Gap(16),
                    // Stats Row
                    Row(
                      children: [
                        // 0-100 km/h
                        if (carSpot.car?.specs?.acceleration0100 != null)
                          Expanded(
                            child: _StatItem(
                              label: '0-100',
                              value:
                                  '${carSpot.car!.specs!.acceleration0100!.toStringAsFixed(1)}s',
                              icon: Icons.speed,
                            ),
                          ),
                        // Horsepower
                        if (carSpot.car?.specs?.powerKw != null)
                          Expanded(
                            child: _StatItem(
                              label: 'POWER',
                              value:
                                  '${(carSpot.car!.specs!.powerKw! * 1.34102).toInt()}hp',
                              icon: Icons.flash_on,
                            ),
                          ),
                        // Top Speed
                        if (carSpot.car?.specs?.topSpeedKmh != null)
                          Expanded(
                            child: _StatItem(
                              label: 'TOP SPEED',
                              value: '${carSpot.car!.specs!.topSpeedKmh}km/h',
                              icon: Icons.speed,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(String? rarity) {
    switch (rarity?.toLowerCase()) {
      case 'legendary':
        return Color(0xFFFFD700);
      case 'epic':
        return Color(0xFFAB47BC);
      case 'rare':
        return Color(0xFF42A5F5);
      case 'uncommon':
        return Color(0xFF66BB6A);
      default:
        return Colors.white.withValues(alpha: 0.7);
    }
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            Gap(4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
        Gap(4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
