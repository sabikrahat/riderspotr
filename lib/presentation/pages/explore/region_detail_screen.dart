import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:ridespotr/presentation/widgets/shared/back.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../models/map/map_marker_model.dart';
import '../../widgets/shared/car_card.dart';

class RegionDetailScreen extends ConsumerStatefulWidget {
  const RegionDetailScreen({
    super.key,
    required this.carsInRegion,
    required this.centerLatitude,
    required this.centerLongitude,
  });

  final List<CarSpotModel> carsInRegion;
  final double centerLatitude;
  final double centerLongitude;

  static const String routeName = '/region-detail';

  @override
  ConsumerState<RegionDetailScreen> createState() => _RegionDetailScreenState();
}

class _RegionDetailScreenState extends ConsumerState<RegionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: Colors.black,
            leading: Back(),
            // title: Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'REGION',
            //       style: context.textTheme.titleLarge?.copyWith(
            //         fontWeight: FontWeight.bold,
            //         letterSpacing: 1.5,
            //       ),
            //     ),
            //     Text(
            //       '${widget.carsInRegion.length} ${widget.carsInRegion.length == 1 ? 'CAR' : 'CARS'}',
            //       style: context.textTheme.bodySmall?.copyWith(
            //         color: Colors.white.withValues(alpha: 0.6),
            //         letterSpacing: 1.2,
            //       ),
            //     ),
            //   ],
            // ),
            pinned: true,
            expandedHeight: context.height * 0.35,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Map Preview
                  MapWidget(
                    key: ValueKey(
                      'region-map-${widget.centerLatitude}-${widget.centerLongitude}',
                    ),
                    styleUri: MapboxStyles.DARK,
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(
                          widget.centerLongitude,
                          widget.centerLatitude,
                        ),
                      ),
                      zoom: 14.0,
                    ),
                    onMapCreated: (MapboxMap map) async {
                      // Optionally add markers for the cars in this region
                      final circleManager = await map.annotations
                          .createCircleAnnotationManager();

                      for (var car in widget.carsInRegion) {
                        if (car.latitude != null && car.longitude != null) {
                          final circleOptions = CircleAnnotationOptions(
                            geometry: Point(
                              coordinates: Position(
                                car.longitude!,
                                car.latitude!,
                              ),
                            ),
                            circleRadius: 4.0,
                            circleColor: 0xFFFFFFFF,
                            circleOpacity: 0.9,
                            circleStrokeWidth: 1.5,
                            circleStrokeColor: car.car?.rarity.color != null
                                ? MapMarkerModel.staticColorToInt(
                                    car.car!.rarity.color,
                                  )
                                : 0xFFFFFFFF,
                            circleStrokeOpacity: 1.0,
                          );
                          await circleManager.create(circleOptions);
                        }
                      }
                    },
                  ),
                  // Gradient overlay at bottom for smooth transition
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Car List
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index.isOdd) {
                    return const Gap(16);
                  }
                  final carIndex = index ~/ 2;
                  return CarCard(carSpot: widget.carsInRegion[carIndex]);
                },
                childCount: widget.carsInRegion.length * 2 - 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
