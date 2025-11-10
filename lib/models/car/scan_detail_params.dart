import 'car_spot_model.dart';

class ScanDetailParams {
  final CarSpotModel? carSpot;
  final bool isManual;

  const ScanDetailParams({
    required this.carSpot,
    this.isManual = false,
  });
}

