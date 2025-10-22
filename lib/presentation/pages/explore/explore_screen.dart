import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../providers/car/map_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/car_card.dart';
import '../capture/car_deatil_screen.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  static const String routeName = '/explore';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  List<String> availableTimes = ['24 HR', '7 DAYS', 'ALL TIME'];
  String? selectedTime = '24 HR';
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;
  geo.Position? _userPosition;
  List<CarSpotModel> _sortedCarSpots = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _getUserLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
    this.mapboxMap = mapboxMap;
    await _addCircleMarkers(spots);
  }

  Future<void> _addCircleMarkers(List<CarSpotModel> spots) async {
    if (mapboxMap == null) return;

    final random = Random();
    final markers = spots
        .where((s) => s.latitude != null && s.longitude != null)
        .toList()
        .map(
          (spot) {
            // Calculate radius based on coordinates
            // Using a combination of lat/lng to create variation
            final lat = spot.latitude!.abs();
            final lng = spot.longitude!.abs();
            final baseRadius = 20.0;
            final variation = ((lat + lng) % 60) + 20; // Range: 20-80
            final calculatedRadius = baseRadius + variation;

            return MapMarkerModel(
              id: spot.id,
              latitude: spot.latitude!,
              longitude: spot.longitude!,
              borderColor: Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              ),
              radius: calculatedRadius,
              carName: spot.car?.model,
            );
          },
        )
        .toList();

    // Create circle annotation manager
    circleAnnotationManager = await mapboxMap!.annotations
        .createCircleAnnotationManager();

    // Listen to tap events on circles
    circleAnnotationManager!.tapEvents(
      onTap: (annotation) {
        // Find the marker that was tapped
        final tappedMarker = markers.firstWhere(
          (m) =>
              m.latitude == annotation.geometry.coordinates.lat &&
              m.longitude == annotation.geometry.coordinates.lng,
          orElse: () => markers.first,
        );

        // Find the index in the sorted car spots list
        final index = _sortedCarSpots.indexWhere(
          (s) => s.id == tappedMarker.id,
        );

        if (index != -1) {
          // Animate to the corresponding page
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
    );

    // Add circles for each marker
    for (var marker in markers) {
      final circleAnnotationOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(marker.longitude, marker.latitude),
        ),
        circleRadius: marker.radius,
        circleColor: marker.colorToInt(marker.borderColor),
        circleStrokeWidth: 3.0,
        circleStrokeColor: marker.colorToInt(marker.borderColor),
        circleOpacity: 0.3,
        circleStrokeOpacity: 1.0,
      );

      await circleAnnotationManager!.create(circleAnnotationOptions);
    }
  }

  Future<void> _focusOnCarSpot(CarSpotModel spot) async {
    if (mapboxMap == null || spot.latitude == null || spot.longitude == null) {
      return;
    }

    await mapboxMap!.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(
            spot.longitude!,
            spot.latitude!,
          ),
        ),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 1000, startDelay: 0),
    );
  }

  void _onPageChanged(int page) {
    if (_sortedCarSpots.isNotEmpty && page < _sortedCarSpots.length) {
      _focusOnCarSpot(_sortedCarSpots[page]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        title: Text('EXPLORE', style: context.textTheme.headlineMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.tune_rounded, size: 28, color: Colors.white),
          ),
        ],
      ),
      body: ref
          .watch(mapProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (data) {
              final notifier = ref.read(mapProvider.notifier);
              _sortedCarSpots = _sortCarSpotsByDistance(data);

              return Stack(
                children: [
                  MapWidget(
                    key: const ValueKey('mapbox-explore'),
                    styleUri: MapboxStyles.DARK,
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          notifier.centeredLatLng.longitude,
                          notifier.centeredLatLng.latitude,
                        ),
                      ),
                      zoom: 13.0,
                    ),
                    onMapCreated: (MapboxMap map) =>
                        _onMapCreated(map, _sortedCarSpots),
                  ),
                  Positioned(
                    top:
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        16,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        // Custom Toggle Buttons
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            children: List.generate(
                              availableTimes.length,
                              (index) {
                                final isSelected =
                                    availableTimes[index] == selectedTime;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () =>
                                          selectedTime = availableTimes[index],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          25.0,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        availableTimes[index],
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Gap(16),
                        // Search Bar
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search cars',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_sortedCarSpots.isNotEmpty)
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      height: context.height * 0.25,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        itemCount: _sortedCarSpots.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: CarCard(
                              carSpot: _sortedCarSpots[index],
                              onTap: () async => await context.push(
                                CarDeatilScreen.routeName,
                                extra: _sortedCarSpots[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
    );
  }
}
