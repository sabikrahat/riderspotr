import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../providers/car/car_spot_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/car_card.dart';
import '../leaderboard/search_friend.dart';

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
  CarSpotModel? _selectedSpot;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap, List<CarSpotModel> spots) async {
    this.mapboxMap = mapboxMap;
    await _addCircleMarkers(spots);
  }

  Future<void> _addCircleMarkers(List<CarSpotModel> spots) async {
    if (mapboxMap == null) return;

    final random = Random();
    final markers = spots.where((s) => s.latitude != null && s.longitude != null).toList().map(
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
    ).toList();

    // Create circle annotation manager
    circleAnnotationManager = await mapboxMap!.annotations.createCircleAnnotationManager();

    // Listen to tap events
    circleAnnotationManager!.tapEvents(
      onTap: (annotation) {
        // Find the marker that was tapped
        final tappedMarker = markers.firstWhere(
          (m) =>
              m.latitude == annotation.geometry.coordinates.lat &&
              m.longitude == annotation.geometry.coordinates.lng,
          orElse: () => markers.first,
        );
        setState(() {
          _selectedSpot = spots.firstWhere((s) => s.id == tappedMarker.id);
        });
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
          .watch(carSpotProvider)
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
            data: (data) {
              final notifier = ref.read(carSpotProvider.notifier);
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
                    onMapCreated: (MapboxMap map) => _onMapCreated(map, notifier.carSpots),
                  ),
                  // GoogleMap(
                  //   key: const ValueKey('explore'),
                  //   initialCameraPosition: CameraPosition(
                  //     target: LatLng(23.772347312511954, 90.43097325236988),
                  //     zoom: 12,
                  //   ),
                  //   myLocationEnabled: false,
                  //   myLocationButtonEnabled: false,
                  //   mapType: MapType.normal,
                  //   trafficEnabled: false,
                  //   style: darkMapStyle,
                  //   zoomControlsEnabled: false,
                  // ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
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
                                final isSelected = availableTimes[index] == selectedTime;
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => selectedTime = availableTimes[index],
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25.0),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        availableTimes[index],
                                        style: context.textTheme.bodyMedium?.copyWith(
                                          color: isSelected ? Colors.black : Colors.white,
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
                        InkWell(
                          onTap: () async => await context.push(SearchFriendScreen.routeName),
                          borderRadius: BorderRadius.circular(12),
                          child: TextFormField(
                            enabled: false,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Search your cars',
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
                        ),
                      ],
                    ),
                  ),
                  if (_selectedSpot != null)
                    Positioned(
                      bottom: 32,
                      left: 16,
                      right: 16,
                      child: CarCard(carSpot: _selectedSpot!),
                    ),
                ],
              );
            },
          ),
    );
  }
}
