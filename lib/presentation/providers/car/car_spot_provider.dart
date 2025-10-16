import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/car/car_spot_model.dart';
import '../../../services/car/car_spot.dart';

part 'car_spot_provider.g.dart';

@Riverpod(keepAlive: true)
class CarSpotNotifier extends _$CarSpotNotifier {
  List<CarSpotModel> _carSpots = [];

  @override
  FutureOr<List<CarSpotModel>> build() async {
    _carSpots = await CarSpotService().getCarSpots();
    return _carSpots;
  }

  List<CarSpotModel> get carSpots => _carSpots;

  Future<void> refresh() async {
    _carSpots = await CarSpotService().getCarSpots();
    state = AsyncValue.data(_carSpots);
  }

  LatLng get centeredLatLng {
    final filteredList = _carSpots
        .where((spot) => spot.latitude != null && spot.longitude != null)
        .toList();
    if (filteredList.isEmpty) {
      return const LatLng(0.0, 0.0);
    }
    double totalLat = 0.0;
    double totalLng = 0.0;
    for (var spot in filteredList) {
      totalLat += spot.latitude!;
      totalLng += spot.longitude!;
    }
    return LatLng(totalLat / _carSpots.length, totalLng / _carSpots.length);
  }
}
