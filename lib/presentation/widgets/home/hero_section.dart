import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:ridespotr/presentation/providers/leaderboard/user_rank_provider.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../pages/explore/explore_screen.dart';
import '../../providers/car/map_provider.dart';
import '../../providers/car/spot_stat_provider.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key, required this.user});

  final dynamic user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  child: ref
                      .watch(userRankProvider)
                      .when(
                        loading: () => Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            Gap(7),
                            SizedBox(
                              width: 40,
                              height: 14,
                              child: Center(
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        error: (_, __) => Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            Gap(7),
                            Text(
                              'N/A',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        data: (rank) => Row(
                          children: [
                            Icon(
                              Icons.emoji_events,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            Gap(7),
                            Text(
                              '#$rank',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
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
            child: ref
                .watch(spotStatProvider)
                .when(
                  loading: () => Row(
                    children: [
                      Expanded(
                        child: _StatOverlay(
                          value: '...',
                          label: 'Total Spots',
                        ),
                      ),
                      Gap(16),
                      Expanded(
                        child: _StatOverlay(
                          value: '...',
                          label: 'Today',
                        ),
                      ),
                      Gap(16),
                      Expanded(
                        child: _StatOverlay(
                          value: '...',
                          label: 'Last Hour',
                        ),
                      ),
                    ],
                  ),
                  error: (_, __) => Row(
                    children: [
                      Expanded(
                        child: _StatOverlay(
                          value: 'N/A',
                          label: 'Total Spots',
                        ),
                      ),
                      Gap(16),
                      Expanded(
                        child: _StatOverlay(
                          value: 'N/A',
                          label: 'Today',
                        ),
                      ),
                      Gap(16),
                      Expanded(
                        child: _StatOverlay(
                          value: 'N/A',
                          label: 'Last Hour',
                        ),
                      ),
                    ],
                  ),
                  data: (stats) {
                    String formatValue(int value) {
                      if (value >= 1000000) {
                        return '${(value / 1000000).toStringAsFixed(1)}M';
                      } else if (value >= 1000) {
                        return '${(value / 1000).toStringAsFixed(1)}K';
                      }
                      return value.toString();
                    }

                    return Row(
                      children: [
                        Expanded(
                          child: _StatOverlay(
                            value: formatValue(stats.totalSpots),
                            label: 'Total Spots',
                          ),
                        ),
                        Gap(16),
                        Expanded(
                          child: _StatOverlay(
                            value: formatValue(stats.todaysSpots),
                            label: 'Today',
                          ),
                        ),
                        Gap(16),
                        Expanded(
                          child: _StatOverlay(
                            value: '+${stats.lastHourSpots}',
                            label: 'Last Hour',
                          ),
                        ),
                      ],
                    );
                  },
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
class _MapPreview extends ConsumerStatefulWidget {
  const _MapPreview();

  @override
  ConsumerState<_MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends ConsumerState<_MapPreview> {
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  geo.Position? _userPosition;
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      final position = await geo.Geolocator.getCurrentPosition();
      setState(() {
        _userPosition = position;
        _isLoadingLocation = false;
      });

      // Update camera to user location if map is ready
      if (mapboxMap != null && _userPosition != null) {
        await _animateCameraToUserLocation();
      }
    } catch (e) {
      setState(() => _isLoadingLocation = false);
      print('Error getting location: $e');
    }
  }

  Future<void> _animateCameraToUserLocation() async {
    if (mapboxMap == null || _userPosition == null) return;

    await mapboxMap!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _userPosition!.longitude,
            _userPosition!.latitude,
          ),
        ),
        zoom: 12.0,
        pitch: 0.0,
      ),
      MapAnimationOptions(duration: 5000, startDelay: 1000),
    );
  }

  Future<void> _addCircleMarkers(List<CarSpotModel> carSpots) async {
    if (mapboxMap == null || _userPosition == null) return;

    // Clear existing markers
    if (circleAnnotationManager != null) {
      await circleAnnotationManager!.deleteAll();
    }

    // Create circle annotation manager if needed
    circleAnnotationManager ??= await mapboxMap!.annotations
        .createCircleAnnotationManager();

    // Convert car spots to map markers
    List<MapMarkerModel> markers = carSpots
        .where(
          (spot) =>
              spot.latitude != null &&
              spot.longitude != null &&
              spot.car?.rarity != null,
        )
        .map((spot) {
          // Safe to use ! here because we filtered out nulls above
          final rarity = spot.car!.rarity;
          return MapMarkerModel(
            id: spot.id,
            latitude: spot.latitude!,
            longitude: spot.longitude!,
            borderColor: _getBorderColorForRarity(rarity),
            radius: _getRadiusForRarity(rarity),
            carName: spot.car?.model ?? 'Unknown',
          );
        })
        .toList();

    // Add glowing orbs for each marker
    for (var marker in markers) {
      // Outer glow ring
      final outerRingOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(marker.longitude, marker.latitude),
        ),
        circleRadius: marker.radius * 1.5,
        circleColor: marker.colorToInt(marker.borderColor),
        circleBlur: 1.5,
        circleOpacity: 0.15,
        circleStrokeWidth: 0,
      );

      // Inner glowing core
      final coreOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(marker.longitude, marker.latitude),
        ),
        circleRadius: marker.radius,
        circleColor: marker.colorToInt(marker.borderColor),
        circleBlur: 1.0,
        circleOpacity: 0.6,
        circleStrokeWidth: 6.0,
        circleStrokeColor: marker.colorToInt(marker.borderColor),
        circleStrokeOpacity: 0.25,
      );

      await circleAnnotationManager!.create(outerRingOptions);
      await circleAnnotationManager!.create(coreOptions);
    }
  }

  // Get radius based on rarity for consistent sizing
  double _getRadiusForRarity(Rarity rarity) {
    switch (rarity) {
      case Rarity.mythic:
        return 30.0;
      case Rarity.legendary:
        return 25.0;
      case Rarity.epic:
        return 20.0;
      case Rarity.rare:
        return 15.0;
      case Rarity.uncommon:
        return 12.0;
      case Rarity.common:
        return 10.0;
    }
  }

  Color _getBorderColorForRarity(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return Colors.grey.shade300;
      case Rarity.uncommon:
        return Colors.greenAccent;
      case Rarity.rare:
        return Colors.blueAccent;
      case Rarity.epic:
        return Colors.purpleAccent;
      case Rarity.legendary:
        return Colors.orangeAccent;
      case Rarity.mythic:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch car spots from provider
    final carSpotsAsync = ref.watch(mapProvider);

    return carSpotsAsync.when(
      loading: () => _buildMap(),
      error: (error, stack) => _buildMap(),
      data: (carSpots) {
        // Add markers when data is loaded and map is ready
        if (mapboxMap != null && _userPosition != null && carSpots.isNotEmpty) {
          Future.microtask(() => _addCircleMarkers(carSpots));
        }
        return _buildMap();
      },
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        // Actual Mapbox Map - Full bleed
        MapWidget(
          key: const ValueKey('mapbox-hero-preview'),
          styleUri: MapboxStyles.DARK,
          cameraOptions: CameraOptions(
            center: Point(
              coordinates: Position(
                _userPosition?.longitude ?? 10.0,
                _userPosition?.latitude ?? 30.0,
              ),
            ),
            zoom: _userPosition != null ? 12.0 : 2.0,
            pitch: 0.0,
          ),
          onMapCreated: (MapboxMap map) async {
            mapboxMap = map;
            // Disable all user interactions for preview
            await map.gestures.updateSettings(
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

            // Animate to user location if available
            if (_userPosition != null && !_isLoadingLocation) {
              await _animateCameraToUserLocation();
            }
          },
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
                  _userPosition != null ? Icons.location_on : Icons.public,
                  size: 12,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                Gap(5),
                Text(
                  _userPosition != null ? 'Your Area' : 'Global View',
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
