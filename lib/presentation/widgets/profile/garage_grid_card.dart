import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/widgets/shared/xp_badge.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/car_spot_model.dart';
import '../../pages/capture/car_preview_screen.dart';
import '../../providers/car/garage_provider.dart';

/// Compact grid card for Instagram-style garage display
class GarageGridCard extends ConsumerWidget {
  final CarSpotModel carSpot;

  const GarageGridCard({required this.carSpot, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isOwnCar = currentUserId == carSpot.user;

    return GestureDetector(
      onTap: () {
        context.push(
          CarPreviewScreen.routeName,
          extra: carSpot,
        );
      },
      onLongPress: isOwnCar
          ? () {
              _showDeleteDialog(context, ref);
            }
          : null,
      child: AspectRatio(
        aspectRatio: 5 / 6, // 4:5 aspect ratio
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Car Image
                FastCachedImage(
                  key: Key(carSpot.id),
                  url: carSpot.imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  errorBuilder: (context, exception, stacktrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                          size: 24,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white24,
                          value: progress.progressPercentage.value,
                        ),
                      ),
                    );
                  },
                ),

                // Top Gradient Overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.topRight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: XpBadge(
                      points: carSpot.car?.points ?? 0,
                      iconSize: 10,
                      fontSize: 8,
                    ),
                  ),
                ),

                // Bottom Gradient Overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: Column(
                      spacing: 2,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (carSpot.car?.make?.name ?? '').toUpperCase(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          (carSpot.car?.model ?? '').toUpperCase(),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),

                // Car Make (top left)
                // Positioned(
                //   top: 8,
                //   left: 8,
                //   right: 60,
                //   child: Text(
                //     (carSpot.car?.make?.name ?? '').toUpperCase(),
                //     style: context.textTheme.bodyMedium?.copyWith(
                //       color: Colors.white,
                //       fontSize: 9,
                //       fontWeight: FontWeight.w600,
                //       letterSpacing: 1.2,
                //     ),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),

                // XP Badge (top right)
                // Positioned(
                //   top: 6,
                //   right: 6,
                //   child: _buildXPBadge(carSpot.car?.points ?? 0),
                // ),

                // Car Model (bottom)
                // Positioned(
                //   left: 8,
                //   right: 8,
                //   bottom: 8,
                //   child: Text(
                //     (carSpot.car?.model ?? '').toUpperCase(),
                //     style: context.textTheme.bodyMedium?.copyWith(
                //       color: Colors.white,
                //       fontSize: 11,
                //       fontWeight: FontWeight.w700,
                //       letterSpacing: 0.5,
                //       height: 1.2,
                //     ),
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildXPBadge(int points) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.stars_rounded,
          size: 10,
          color: Colors.white.withValues(alpha: 0.9),
        ),
        const Gap(3),
        Text(
          '$points',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 9,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Delete Car Spot',
            style: context.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this car spot? This action cannot be undone.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                try {
                  await ref
                      .read(garageProvider(carSpot.user).notifier)
                      .deleteCar(carSpot.id);
                  showSuccessMessage('Car spot deleted successfully');
                } catch (e) {
                  showErrorMessage('Failed to delete car spot');
                }
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
