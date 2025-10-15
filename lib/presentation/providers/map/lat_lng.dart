import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../services/google_maps/google_maps_service.dart';

final getLocationBasedOnLatLngPd = FutureProvider.family(
  (_, LatLng latLng) async => await GoogleMapsService().getLocationBasedOnLatLng(latLng),
);
