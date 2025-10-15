import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../core/extensions.dart';
import '../../../models/map/map_marker_model.dart';
import '../../widgets/shared/back.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  static const String routeName = '/explore';

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String? darkMapStyle;
  List<String> availableTimes = ['24 HR', '7 DAYS', 'ALL TIME'];
  String? selectedTime = '24 HR';
  MapboxMap? mapboxMap;
  CircleAnnotationManager? circleAnnotationManager;

  // Sample marker data - replace with your actual data
  List<MapMarkerModel> markers = [
    MapMarkerModel(
      id: '1',
      latitude: 23.772386,
      longitude: 90.431026,
      borderColor: Colors.blue,
      radius: 40,
      carName: 'Tesla Model 3',
    ),
    MapMarkerModel(
      id: '2',
      latitude: 23.774386,
      longitude: 90.433026,
      borderColor: Colors.purple,
      radius: 50,
      carName: 'BMW M3',
    ),
    MapMarkerModel(
      id: '3',
      latitude: 23.770386,
      longitude: 90.429026,
      borderColor: Colors.red,
      radius: 35,
      carName: 'Mercedes AMG',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      darkMapStyle = await rootBundle.loadString(
        'assets/json/map-dark-mode.json',
      );
      setState(() {});
    });
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    await _addCircleMarkers();
  }

  Future<void> _addCircleMarkers() async {
    if (mapboxMap == null) return;

    // Create circle annotation manager
    circleAnnotationManager = await mapboxMap!.annotations
        .createCircleAnnotationManager();

    // Listen to tap events
    circleAnnotationManager!.tapEvents(
      onTap: (annotation) {
        // Find the marker that was tapped
        final tappedMarker = markers.firstWhere(
          (m) =>
              m.latitude == annotation.geometry.coordinates.lat.toDouble() &&
              m.longitude == annotation.geometry.coordinates.lng.toDouble(),
          orElse: () => markers.first,
        );

        // Show info about the tapped marker
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tappedMarker.carName ?? 'Unknown Car'),
            duration: const Duration(seconds: 2),
            backgroundColor: tappedMarker.borderColor,
          ),
        );
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
      body: Stack(
        children: [
          MapWidget(
            key: const ValueKey('mapbox-explore'),
            styleUri: MapboxStyles.DARK,
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(90.43102689655147, 23.772386586668123),
              ),
              zoom: 13.0,
            ),
            onMapCreated: _onMapCreated,
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
                        final isSelected =
                            availableTimes[index] == selectedTime;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(
                              () => selectedTime = availableTimes[index],
                            ),
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                availableTimes[index],
                                style: context.textTheme.bodyMedium?.copyWith(
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
              ],
            ),
          ),
          // TODO: Implement
          // Positioned(
          //   bottom: 32,
          //   left: 16,
          //   right: 16,
          //   child: CarCard(),
          // ),
        ],
      ),
    );
  }
}
