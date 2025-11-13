import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
        aspectRatio: 4 / 5, // 4:5 aspect ratio
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
                // Gradient Overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                      ),
                    ),
                  ),
                ),
                // Car Info (bottom)
                Positioned(
                  left: 6,
                  right: 6,
                  bottom: 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${carSpot.car?.make?.name ?? ''} ${carSpot.car?.model ?? ''}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (carSpot.car?.production?.yearStart != null)
                            Text(
                              '${carSpot.car!.production!.yearStart}',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 8,
                              ),
                            ),
                          if (carSpot.car?.points != null)
                            Text(
                              '${carSpot.car!.points} XP',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
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
      ),
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
