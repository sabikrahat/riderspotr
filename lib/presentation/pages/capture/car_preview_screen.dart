import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../widgets/shared/back.dart';
import 'car_detail_screen.dart';

class CarPreviewScreen extends ConsumerStatefulWidget {
  static const String routeName = '/car-preview';

  const CarPreviewScreen({
    super.key,
    required this.carSpot,
    this.showDetailsButton = true,
  });

  final CarSpotModel carSpot;
  final bool showDetailsButton;

  @override
  ConsumerState<CarPreviewScreen> createState() => _CarPreviewScreenState();
}

class _CarPreviewScreenState extends ConsumerState<CarPreviewScreen> {
  bool _showInfo = true;

  @override
  Widget build(BuildContext context) {
    final car = widget.carSpot.car;

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
              _showInfo ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _showInfo = !_showInfo;
              });
            },
            tooltip: _showInfo ? 'Hide info' : 'Show info',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showInfo = !_showInfo;
          });
        },
        child: Stack(
          children: [
            // Full screen car image
            Positioned.fill(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: FastCachedImage(
                  key: Key(widget.carSpot.id),
                  url: widget.carSpot.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  fadeInDuration: const Duration(milliseconds: 300),
                  errorBuilder: (context, exception, stacktrace) {
                    return Container(
                      color: Colors.grey.shade900,
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.white24,
                          size: 64,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return Container(
                      color: Colors.black,
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
            ),

            // Top gradient overlay
            if (_showInfo)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 200,
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
                ),
              ),

            // Bottom gradient overlay
            if (_showInfo)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.95),
                        Colors.black.withValues(alpha: 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

            // Car info overlay
            if (_showInfo)
              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    // Bottom info section
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Rarity badge
                          // if (car?.rarity != null)
                          //   RarityBadge(rarity: car!.rarity),
                          // const Gap(16),

                          // Car make
                          Text(
                            car?.make?.name.toUpperCase() ?? 'UNKNOWN',
                            style: context.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              letterSpacing: 3,
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const Gap(4),

                          // Car model
                          Text(
                            car?.model?.toUpperCase() ?? 'UNKNOWN',
                            style: context.textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontSize: 32,
                              height: 1.1,
                            ),
                          ),
                          const Gap(20),

                          // Stats Row
                          Row(
                            children: [
                              // 0-100 km/h
                              if (car?.specs?.acceleration0100 != null)
                                Expanded(
                                  child: _StatItem(
                                    label: '0-100',
                                    value:
                                        '${car!.specs!.acceleration0100!.toStringAsFixed(1)}s',
                                    icon: Icons.speed,
                                  ),
                                ),
                              // Horsepower
                              if (car?.specs?.powerKw != null)
                                Expanded(
                                  child: _StatItem(
                                    label: 'POWER',
                                    value:
                                        '${(car!.specs!.powerKw! * 1.34102).toInt()}hp',
                                    icon: Icons.flash_on,
                                  ),
                                ),
                              // Top Speed
                              if (car?.specs?.topSpeedKmh != null)
                                Expanded(
                                  child: _StatItem(
                                    label: 'TOP SPEED',
                                    value: '${car!.specs!.topSpeedKmh}km/h',
                                    icon: Icons.speed,
                                  ),
                                ),
                            ],
                          ),
                          // View Details Button
                          if (widget.showDetailsButton) ...[
                            const Gap(20),
                            GestureDetector(
                              onTap: () {
                                context.push(
                                  CarDetailScreen.routeName,
                                  extra: widget.carSpot,
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withValues(alpha: 0.08),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        'VIEW DETAILS',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1.5,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
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
            const Gap(4),
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
        const Gap(4),
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
