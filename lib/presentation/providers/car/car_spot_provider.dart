import 'dart:async';

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
}
