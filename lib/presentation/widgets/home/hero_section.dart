import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/extensions.dart';
import '../../pages/explore/explore_screen.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.viewPaddingOf(context).top;
    final screenHeight = context.height;

    return SizedBox(
      height: screenHeight * 0.65, // First half of the screen
      child: Stack(
        children: [
          // Map - Full Width, No Padding
          Positioned.fill(
            child: _MapPreview(),
          ),

          // Gradient Overlay - Blend into black background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xFF000000).withValues(alpha: 0.6),
                    Color(0xFF000000),
                  ],
                ),
              ),
            ),
          ),

          // Top Bar with Logo and Rank
          Positioned(
            top: topPadding + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/logo/logo-full.svg',
                  width: 140,
                  fit: BoxFit.fitWidth,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      Gap(7),
                      Text(
                        '#142',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Statistics Overlays - Minimal & Elegant
          Positioned(
            left: 20,
            right: 20,
            bottom: 86,
            child: Row(
              children: [
                Expanded(
                  child: _StatOverlay(
                    value: '12.4K',
                    label: 'Total Spots',
                  ),
                ),
                Gap(16),
                Expanded(
                  child: _StatOverlay(
                    value: '1,847',
                    label: 'Active Now',
                  ),
                ),
                Gap(16),
                Expanded(
                  child: _StatOverlay(
                    value: '+156',
                    label: 'Last Hour',
                  ),
                ),
              ],
            ),
          ),

          // Explore Map Button - Bottom Center
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () => context.push(ExploreScreen.routeName),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    Gap(10),
                    Text(
                      'Explore Full Map',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    Gap(6),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Map Preview Widget
class _MapPreview extends StatefulWidget {
  const _MapPreview();

  @override
  State<_MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<_MapPreview> {
  MapboxMap? mapboxMap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Actual Mapbox Map - Full bleed
        MapWidget(
          key: const ValueKey('mapbox-hero-preview'),
          styleUri: MapboxStyles.DARK,
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(
                10.0, // Longitude (centered on Europe/Mediterranean)
                30.0, // Latitude
              ),
            ),
            zoom: 2.0, // World view
            pitch: 0.0,
          ),
          onMapCreated: (MapboxMap map) {
            mapboxMap = map;
            // Disable all user interactions for preview
            map.gestures.updateSettings(
              GesturesSettings(
                rotateEnabled: false,
                pinchToZoomEnabled: false,
                scrollEnabled: false,
                pitchEnabled: false,
                doubleTapToZoomInEnabled: false,
                doubleTouchToZoomOutEnabled: false,
                quickZoomEnabled: false,
              ),
            );
          },
        ),

        // Glowing pins overlay (decorative)
        Positioned(
          top: 40,
          left: 60,
          child: _GlowingPin(),
        ),
        Positioned(
          bottom: 80,
          right: 50,
          child: _GlowingPin(),
        ),
        Positioned(
          top: 100,
          right: 80,
          child: _GlowingPin(color: Colors.purple),
        ),

        // Map indicator
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.public,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                Gap(5),
                Text(
                  'Global View',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Glowing Pin Widget
class _GlowingPin extends StatelessWidget {
  const _GlowingPin({this.color = Colors.blue});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}

// Stat Overlay Widget - Minimal & Borderless
class _StatOverlay extends StatelessWidget {
  const _StatOverlay({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: Colors.white,
              height: 1,
            ),
          ),
          Gap(4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
