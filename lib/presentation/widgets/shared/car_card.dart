import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/core/enums.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/car_spot_model.dart';
import '../../pages/capture/car_detail_screen.dart';
import '../../providers/car/garage_provider.dart';

class CarCard extends ConsumerWidget {
  final CarSpotModel carSpot;
  const CarCard({required this.carSpot, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isOwnCar = currentUserId == carSpot.user;

    return GestureDetector(
      onTap: () {
        context.push(
          CarDetailScreen.routeName,
          extra: carSpot,
        );
      },
      onLongPress: isOwnCar
          ? () {
              _showDeleteDialog(context, ref);
            }
          : null,
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rarity Badge (Top Right)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 3 Dots Menu - Only for owned cars
                        if (isOwnCar)
                          GestureDetector(
                            onTap: () => _showDeleteDialog(context, ref),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withValues(alpha: 0.6),
                              ),
                              child: Icon(
                                Icons.more_vert,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 16,
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        // Rarity Badge
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
                              color: carSpot.car?.rarity.color,
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DELETE CAR',
                style: context.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 3,
                ),
              ),
              const Gap(16),
              Text(
                '${carSpot.car?.make?.name ?? 'This car'} ${carSpot.car?.model ?? ''}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                'This action cannot be undone.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              // Delete Button
              GestureDetector(
                onTap: () async {
                  dialogContext.pop();
                  try {
                    await ref
                        .read(garageProvider(null).notifier)
                        .deleteCar(carSpot.id);
                  } catch (e) {
                    showErrorMessage('Failed to delete car. Please try again.');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'DELETE',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(12),
              // Cancel Button
              GestureDetector(
                onTap: () => dialogContext.pop(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
