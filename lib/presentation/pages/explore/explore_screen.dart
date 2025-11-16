import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../providers/car/map_provider.dart';
import 'region_detail_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  static const String routeName = '/explore';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen>
    with SingleTickerProviderStateMixin {
  List<String> availableTimes = ['24 HR', '7 DAYS', 'ALL TIME'];
  String selectedTime = '24 HR';
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  PolygonAnnotationManager? polygonAnnotationManager;
  geo.Position? _userPosition;
  List<CarSpotModel> _sortedCarSpots = [];
  late TabController _tabController;
  Map<String, List<CarSpotModel>> _hexagonClusters = {};
  Map<String, Position> _hexagonCenters = {}; // Store center of each hexagon

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {
        selectedTime = availableTimes[_tabController.index];
      });
    });
    _getUserLocation();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
        if (permission == geo.LocationPermission.denied) {
          return;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        return;
      }

      final position = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );

      setState(() {
        _userPosition = position;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  double _calculateDistance(double lat, double lng) {
    if (_userPosition == null) return double.infinity;
    return geo.Geolocator.distanceBetween(
      _userPosition!.latitude,
      _userPosition!.longitude,
      lat,
      lng,
    );
  }

  List<CarSpotModel> _sortCarSpotsByDistance(List<CarSpotModel> spots) {
    final spotsWithCoordinates = spots
        .where((spot) => spot.latitude != null && spot.longitude != null)
        .toList();

    if (_userPosition == null) {
      return spotsWithCoordinates;
    }

    spotsWithCoordinates.sort((a, b) {
      final distanceA = _calculateDistance(a.latitude!, a.longitude!);
      final distanceB = _calculateDistance(b.latitude!, b.longitude!);
      return distanceA.compareTo(distanceB);
    });

    return spotsWithCoordinates;
  }

  Future<void> _onMapCreated(
    MapboxMap mapboxMap,
    List<CarSpotModel> spots,
  ) async {
    debugPrint('Map created with ${spots.length} spots');
    this.mapboxMap = mapboxMap;
    await _addLuxuryMarkers(spots);

    // Hexagons use fixed size for perfect grid alignment - no zoom updates needed

    // Focus on user's location if available, otherwise first car
    if (_userPosition != null) {
      await mapboxMap.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              _userPosition!.longitude,
              _userPosition!.latitude,
            ),
          ),
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 1500, startDelay: 300),
      );
    } else if (spots.isNotEmpty &&
        spots.first.latitude != null &&
        spots.first.longitude != null) {
      await mapboxMap.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(
              spots.first.longitude!,
              spots.first.latitude!,
            ),
          ),
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 1500, startDelay: 300),
      );
    }
  }

  /// Recenter map to user's current location
  Future<void> _recenterToUserLocation() async {
    if (mapboxMap == null || _userPosition == null) return;

    await mapboxMap!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            _userPosition!.longitude,
            _userPosition!.latitude,
          ),
        ),
        zoom: 13.0,
      ),
      MapAnimationOptions(duration: 1000, startDelay: 0),
    );
  }

  Future<void> _addLuxuryMarkers(List<CarSpotModel> spots) async {
    if (mapboxMap == null) return;

    // Clear existing annotations
    if (circleAnnotationManager != null) {
      await circleAnnotationManager!.deleteAll();
    } else {
      circleAnnotationManager = await mapboxMap!.annotations
          .createCircleAnnotationManager();
    }

    if (polygonAnnotationManager != null) {
      await polygonAnnotationManager!.deleteAll();
    } else {
      polygonAnnotationManager = await mapboxMap!.annotations
          .createPolygonAnnotationManager();
    }

    // Create markers using ORIGINAL coordinates for hexagon clustering
    // This ensures hexagons stay in the same place every time
    final originalMarkers = spots
        .where((s) => s.latitude != null && s.longitude != null)
        .toList()
        .map(
          (spot) => MapMarkerModel(
            id: spot.id,
            latitude: spot.latitude!,
            longitude: spot.longitude!,
            borderColor: spot.car!.rarity.color,
            radius: 8.0,
            carName: spot.car?.model,
          ),
        )
        .toList();

    // Create hexagonal regions based on ORIGINAL coordinates
    // This keeps hexagons stable and consistent
    final clusters = _createHexagonalClusters(originalMarkers, spots);
    for (var entry in clusters.entries) {
      await _createHexagonalRegion(entry.value, entry.key);
    }

    // Listen to tap events on polygons (hexagons)
    polygonAnnotationManager!.tapEvents(
      onTap: (annotation) {
        // Get the center of the tapped polygon
        final geometry = annotation.geometry;
        if (geometry.coordinates.isEmpty ||
            geometry.coordinates.first.isEmpty) {
          return;
        }

        // Calculate centroid of the polygon
        final points = geometry.coordinates.first;
        double sumLat = 0;
        double sumLng = 0;
        for (var point in points) {
          sumLat += point.lat;
          sumLng += point.lng;
        }
        final centerLat = sumLat / points.length;
        final centerLng = sumLng / points.length;

        // Find the closest hexagon key
        String? closestHexKey;
        double minDistance = double.infinity;

        for (var entry in _hexagonCenters.entries) {
          final hexCenter = entry.value;
          final distance = sqrt(
            pow(hexCenter.lat - centerLat, 2) +
                pow(hexCenter.lng - centerLng, 2),
          );

          if (distance < minDistance) {
            minDistance = distance;
            closestHexKey = entry.key;
          }
        }

        if (closestHexKey != null) {
          final carsInRegion = _hexagonClusters[closestHexKey] ?? [];
          if (carsInRegion.isNotEmpty) {
            _showRegionDetail(carsInRegion, closestHexKey);
          }
        }
      },
    );

    // Create elegant white dot markers for each spot
    // Dots are placed randomly within their hexagon for privacy
    // (hexagons use original coords, dots are randomized inside)
    for (var entry in clusters.entries) {
      final hexKey = entry.key;
      final markersInHex = entry.value;

      for (var marker in markersInHex) {
        await _createLuxuryDot(marker, hexKey);
      }
    }
  }

  /// Create hexagonal clusters from markers - ALL markers get a hexagon
  Map<String, List<MapMarkerModel>> _createHexagonalClusters(
    List<MapMarkerModel> markers,
    List<CarSpotModel> originalSpots,
  ) {
    if (markers.isEmpty) return {};

    // Use FIXED hexagon size for stable clustering (independent of zoom)
    // This prevents hexagons from changing when zooming
    const double fixedHexSize = 0.006; // Fixed clustering grid size

    // Group markers into hexagonal grid
    final Map<String, List<MapMarkerModel>> hexGrid = {};

    for (var marker in markers) {
      // Calculate hex coordinates using fixed size
      final hexCoord = _getHexCoordinate(
        marker.latitude,
        marker.longitude,
        fixedHexSize,
      );
      final key = '${hexCoord['q']},${hexCoord['r']}';

      if (!hexGrid.containsKey(key)) {
        hexGrid[key] = [];
      }
      hexGrid[key]!.add(marker);
    }

    // Store car spots by hexagon key for later retrieval
    _hexagonClusters.clear();
    for (var entry in hexGrid.entries) {
      final hexKey = entry.key;
      final markersInHex = entry.value;

      // Map markers back to car spots
      final spotsInHex = markersInHex
          .map(
            (marker) => originalSpots.firstWhere(
              (spot) => spot.id == marker.id,
              orElse: () => originalSpots.first,
            ),
          )
          .toList();

      _hexagonClusters[hexKey] = spotsInHex;
    }

    // Return ALL hexagons (even single markers)
    return hexGrid;
  }

  /// Get hexagonal coordinate for a lat/lng point
  Map<String, int> _getHexCoordinate(double lat, double lng, double hexSize) {
    // Simplified cubic hex coordinate system
    final x = lng / hexSize;
    final y = lat / hexSize;

    final q = (x * 2 / 3).round();
    final r = ((-x / 3) + (y * sqrt(3) / 3)).round();

    return {'q': q, 'r': r};
  }

  /// Convert hexagonal coordinates back to lat/lng for perfect grid alignment
  Map<String, double> _hexCoordinateToLatLng(int q, int r, double hexSize) {
    // Reverse the hex coordinate transformation
    final lng = hexSize * (3.0 / 2.0 * q);
    final lat = hexSize * (sqrt(3) / 2.0 * q + sqrt(3) * r);

    return {'lat': lat, 'lng': lng};
  }

  /// Create a hexagonal region polygon
  Future<void> _createHexagonalRegion(
    List<MapMarkerModel> cluster,
    String hexKey,
  ) async {
    if (polygonAnnotationManager == null || cluster.isEmpty) return;

    // Parse hex coordinates from the key
    final coords = hexKey.split(',');
    final q = int.parse(coords[0]);
    final r = int.parse(coords[1]);

    // Use FIXED hex size for perfect grid alignment
    const double fixedHexSize = 0.006;

    // Calculate center position on the hexagonal grid (this ensures no overlap)
    final gridCenter = _hexCoordinateToLatLng(q, r, fixedHexSize);
    final centerLat = gridCenter['lat']!;
    final centerLng = gridCenter['lng']!;

    // Store the center for later tap detection
    _hexagonCenters[hexKey] = Position(centerLng, centerLat);

    // Generate hexagon vertices with proper flat-top orientation
    // Use the SAME fixed size for visual rendering to ensure perfect tiling
    final hexSize = fixedHexSize;

    // Account for latitude/longitude scaling
    // At the equator, 1 degree lat ≈ 1 degree lng
    // As we move away from equator, longitude degrees get smaller
    final latScale = 1.0;
    final lngScale = 1.0 / cos(centerLat * pi / 180);

    final vertices = <Position>[];

    // Generate flat-top hexagon (more natural looking)
    for (int i = 0; i < 6; i++) {
      final angle = (pi / 3) * i + (pi / 6); // Start at 30° for flat-top
      final latOffset = hexSize * sin(angle) * latScale;
      final lngOffset = hexSize * cos(angle) * lngScale;

      vertices.add(
        Position(
          centerLng + lngOffset,
          centerLat + latOffset,
        ),
      );
    }

    // Close the polygon
    vertices.add(vertices.first);

    // Determine dominant rarity color in cluster
    final rarityColors = cluster.map((m) => m.borderColor).toList();
    final dominantColor = rarityColors.first;

    // Create semi-transparent hexagonal region with prominent border
    final polygonOptions = PolygonAnnotationOptions(
      geometry: Polygon(coordinates: [vertices]),
      fillColor: MapMarkerModel.staticColorToInt(
        dominantColor.withValues(alpha: 0.12),
      ),
      fillOutlineColor: MapMarkerModel.staticColorToInt(
        dominantColor.withValues(alpha: 0.65),
      ),
    );

    await polygonAnnotationManager!.create(polygonOptions);
  }

  /// Create an elegant white dot marker at a random position within the hexagon
  Future<void> _createLuxuryDot(MapMarkerModel marker, String hexKey) async {
    if (circleAnnotationManager == null) return;

    // Parse hex coordinates from the key
    final coords = hexKey.split(',');
    final q = int.parse(coords[0]);
    final r = int.parse(coords[1]);

    // Use FIXED hex size to match hexagon boundaries
    const double fixedHexSize = 0.006;

    // Get the center of this hexagon
    final gridCenter = _hexCoordinateToLatLng(q, r, fixedHexSize);
    final centerLat = gridCenter['lat']!;
    final centerLng = gridCenter['lng']!;

    // Generate random position within a CIRCLE inscribed in the hexagon
    // This ensures dots never escape hexagon boundaries
    final random = Random();

    // For a flat-top hexagon, the inscribed circle radius is hexSize * sqrt(3)/2
    // Use 50% of that to give extra margin
    final maxRadius = fixedHexSize * sqrt(3) / 2 * 0.5;

    // Random point within circle
    final randomRadius =
        sqrt(random.nextDouble()) * maxRadius; // sqrt for uniform distribution
    final randomAngle = random.nextDouble() * 2 * pi;

    // Account for latitude/longitude scaling
    final latScale = 1.0;
    final lngScale = 1.0 / cos(centerLat * pi / 180);

    final randomLat = centerLat + (randomRadius * sin(randomAngle) * latScale);
    final randomLng = centerLng + (randomRadius * cos(randomAngle) * lngScale);

    // Use fixed radius for consistency
    const double radius = 4.0;

    // Create outer glow circle
    final glowOptions = CircleAnnotationOptions(
      geometry: Point(
        coordinates: Position(randomLng, randomLat),
      ),
      circleRadius: radius * 2.5,
      circleColor: MapMarkerModel.staticColorToInt(Colors.white),
      circleOpacity: 0.1,
      circleBlur: 1.0,
    );
    await circleAnnotationManager!.create(glowOptions);

    // Create main pure white dot (no colored stroke)
    final dotOptions = CircleAnnotationOptions(
      geometry: Point(
        coordinates: Position(randomLng, randomLat),
      ),
      circleRadius: radius,
      circleColor: MapMarkerModel.staticColorToInt(Colors.white),
      circleOpacity: 0.95,
    );

    await circleAnnotationManager!.create(dotOptions);
  }

  void _showRegionDetail(
    List<CarSpotModel> carsInRegion,
    String hexKey,
  ) {
    // Get the center coordinates for this hexagon
    final hexCenter = _hexagonCenters[hexKey];
    if (hexCenter == null) return;

    context.push(
      RegionDetailScreen.routeName,
      extra: {
        'carsInRegion': carsInRegion,
        'centerLatitude': hexCenter.lat.toDouble(),
        'centerLongitude': hexCenter.lng.toDouble(),
      },
    );
  }

  List<CarSpotModel> filtering(List<CarSpotModel> carSpots) {
    List<CarSpotModel> filteredList = [];

    // Time filtering
    if (selectedTime == availableTimes[0]) {
      // '24 HR'
      filteredList = carSpots
          .where(
            (spot) => DateTime.now().difference(spot.createdAt).inHours <= 24,
          )
          .toList();
    } else if (selectedTime == availableTimes[1]) {
      // '7 DAYS'
      filteredList = carSpots
          .where(
            (spot) => DateTime.now().difference(spot.createdAt).inDays <= 7,
          )
          .toList();
    } else {
      // 'ALL TIME'
      filteredList = carSpots;
    }

    _addLuxuryMarkers(filteredList);

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('EXPLORE', style: context.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: ref
          .watch(mapProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (data) {
              final notifier = ref.read(mapProvider.notifier);
              final filterData = filtering(data);
              _sortedCarSpots = _sortCarSpotsByDistance(filterData);
              return Stack(
                children: [
                  // Map Layer
                  MapWidget(
                    key: const ValueKey('mapbox-explore'),
                    styleUri: MapboxStyles.DARK,
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          // Use user's location if available, otherwise fallback to first car or default
                          _userPosition != null
                              ? _userPosition!.longitude
                              : (_sortedCarSpots.isNotEmpty &&
                                        _sortedCarSpots.first.longitude != null
                                    ? _sortedCarSpots.first.longitude!
                                    : notifier.centeredLatLng.longitude),
                          _userPosition != null
                              ? _userPosition!.latitude
                              : (_sortedCarSpots.isNotEmpty &&
                                        _sortedCarSpots.first.latitude != null
                                    ? _sortedCarSpots.first.latitude!
                                    : notifier.centeredLatLng.latitude),
                        ),
                      ),
                      zoom: 13.0,
                    ),
                    onMapCreated: (MapboxMap map) =>
                        _onMapCreated(map, _sortedCarSpots),
                  ),
                  // Gradient Overlay
                  Positioned(
                    child: IgnorePointer(
                      child: Container(
                        height: context.height * 0.4,
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top:
                              MediaQuery.of(context).padding.top +
                              kToolbarHeight +
                              16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Interactive elements positioned separately
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top + kToolbarHeight + 8,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TabBar Filter Section
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                              insets: EdgeInsets.symmetric(horizontal: 16),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.white.withValues(
                              alpha: 0.4,
                            ),
                            labelStyle: context.textTheme.bodyMedium?.copyWith(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: context.textTheme.bodyMedium
                                ?.copyWith(
                                  fontSize: 11,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w300,
                                ),
                            tabs: const [
                              Tab(text: '24 HR'),
                              Tab(text: '7 DAYS'),
                              Tab(text: 'ALL TIME'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Recenter to user location button
                  if (_userPosition != null)
                    Positioned(
                      right: 16,
                      bottom: 120,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _recenterToUserLocation,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.navigation,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
    );
  }
}
