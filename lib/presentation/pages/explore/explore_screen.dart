import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../core/location_utils.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../providers/car/map_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/search_text_field.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  static const String routeName = '/explore';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final searchController = TextEditingController();
  List<String> availableTimes = ['24 HR', '7 DAYS', 'ALL TIME'];
  String selectedTime = '24 HR';
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
    debugPrint('Map created with ${spots.length} spots');
    this.mapboxMap = mapboxMap;
    await _addCircleMarkers(spots);

    // Focus on first car's location if available
    if (spots.isNotEmpty &&
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

  Future<void> _addCircleMarkers(List<CarSpotModel> spots) async {
    if (mapboxMap == null) return;

    // Clear existing markers if they exist
    if (circleAnnotationManager != null) {
      await circleAnnotationManager!.deleteAll();
    } else {
      // Create circle annotation manager if it doesn't exist
      circleAnnotationManager = await mapboxMap!.annotations
          .createCircleAnnotationManager();
    }

    final markers = spots
        .where((s) => s.latitude != null && s.longitude != null)
        .toList()
        .map(
          (spot) {
            // Calculate radius based on rarity for glowing orbs
            final baseRadius = _getRadiusForRarity(spot.car!.rarity);

            // Randomize coordinates for privacy (within ~100m radius)
            final randomizedCoords = LocationUtils.randomizeCoordinates(
              latitude: spot.latitude!,
              longitude: spot.longitude!,
              radiusInMeters: 100.0,
            );

            return MapMarkerModel(
              id: spot.id,
              latitude: randomizedCoords['latitude']!,
              longitude: randomizedCoords['longitude']!,
              borderColor: spot.car!.rarity.color,
              radius: baseRadius,
              carName: spot.car?.model,
            );
          },
        )
        .toList();

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

    // Add simple, minimalistic circles for each marker
    for (var marker in markers) {
      // Simple circle with clean border - all same size
      final circleOptions = CircleAnnotationOptions(
        geometry: Point(
          coordinates: Position(marker.longitude, marker.latitude),
        ),
        circleRadius: 25.0, // Fixed size for all markers
        circleColor: marker.colorToInt(marker.borderColor),
        circleOpacity: 0.25,
        circleStrokeWidth: 2.0,
        circleStrokeColor: marker.colorToInt(marker.borderColor),
        circleStrokeOpacity: 0.7,
      );

      await circleAnnotationManager!.create(circleOptions);
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
        return 16.0;
      case Rarity.uncommon:
        return 13.0;
      case Rarity.common:
        return 10.0;
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

    // Search filtering
    final query = searchController.text.toLowerCase();
    if (query.isNotEmpty && query.length >= 2) {
      filteredList = filteredList.where((spot) {
        final carModel = spot.car?.model?.toLowerCase() ?? '';
        final carMake = spot.car?.make?.name.toLowerCase() ?? '';
        return carModel.contains(query) || carMake.contains(query);
      }).toList();
    }

    _addCircleMarkers(filteredList);

    return filteredList;
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
                          _sortedCarSpots.isNotEmpty &&
                                  _sortedCarSpots.first.longitude != null
                              ? _sortedCarSpots.first.longitude!
                              : notifier.centeredLatLng.longitude,
                          _sortedCarSpots.isNotEmpty &&
                                  _sortedCarSpots.first.latitude != null
                              ? _sortedCarSpots.first.latitude!
                              : notifier.centeredLatLng.latitude,
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
                        MediaQuery.of(context).padding.top +
                        kToolbarHeight +
                        16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Filter Section
                        _FilterSection(
                          selectedTime: selectedTime,
                          availableTimes: availableTimes,
                          onTimeChanged: (value) {
                            setState(() {
                              selectedTime = value;
                            });
                          },
                        ),
                        Gap(16),
                        SearchTextField(
                          controller: searchController,
                          onChanged: (value) {
                            setState(() {});
                          },
                          hintText: 'Search for a car',
                        ),
                      ],
                    ),
                  ),
                  // Draggable Car Cards
                  if (_sortedCarSpots.isNotEmpty)
                    DraggableScrollableSheet(
                      initialChildSize: 0.28,
                      minChildSize: 0.08,
                      maxChildSize: 0.45,
                      snap: true,
                      snapSizes: [0.08, 0.28, 0.45],
                      builder: (context, scrollController) {
                        return SafeArea(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              physics: ClampingScrollPhysics(),
                              child: Column(
                                children: [
                                  // Drag Handle - Always visible
                                  GestureDetector(
                                    onTap: () {
                                      // Tap to expand to default size
                                      if (scrollController.hasClients) {
                                        scrollController.animateTo(
                                          0,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 40,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                            color: Colors.white.withValues(
                                              alpha: 0.4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Car Cards
                                  SizedBox(
                                    height: context.height * 0.25,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      onPageChanged: _onPageChanged,
                                      itemCount: _sortedCarSpots.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          child: CarCard(
                                            carSpot: _sortedCarSpots[index],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),
    );
  }
}

// Filter Section Widget
class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.selectedTime,
    required this.availableTimes,
    required this.onTimeChanged,
  });

  final String selectedTime;
  final List<String> availableTimes;
  final Function(String) onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: availableTimes.map((option) {
        final isSelected = selectedTime == option;
        final isLast = option == availableTimes.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: GestureDetector(
              onTap: () => onTimeChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.15),
                            Colors.white.withValues(alpha: 0.05),
                          ],
                        )
                      : null,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 13,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
