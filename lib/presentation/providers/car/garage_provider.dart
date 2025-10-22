import 'dart:async';

import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/car/car_spot_model.dart';
import '../../../services/car/car_service.dart';

part 'garage_provider.g.dart';

@Riverpod(keepAlive: true)
class GarageNotifier extends _$GarageNotifier {
  List<CarSpotModel> _carSpots = [];

  @override
  FutureOr<List<CarSpotModel>> build() async {
    _carSpots = await CarService().getCarSpots();
    return _carSpots;
  }

  List<CarSpotModel> get carSpots => _carSpots;

  Future<void> refresh() async {
    _carSpots = await CarService().getCarSpots();
    state = AsyncValue.data(_carSpots);
  }

  /// Scans a car by uploading the image and calling the edge function
  /// Returns a CarSpotModel with is_claimed = false
  Future<CarSpotModel> scanCar(XFile file) async {
    try {
      // Upload image to storage
      final imagePath = await CarService().uploadFileToStorage(file);
      if (imagePath == null) {
        throw Exception('Failed to upload image');
      }

      // Scan the car and get the full CarSpotModel from the database
      final carSpotModel = await CarService().scanCar(imagePath);

      return carSpotModel;
    } catch (e) {
      throw Exception('Error scanning car: $e');
    }
  }

  /// Claims a car spot by setting is_claimed to true and refreshing the garage
  Future<void> claimCar(String carSpotId) async {
    try {
      await CarService().markClaimed(carSpotId);
      // Refresh the garage to include the newly claimed car
      await refresh();
    } catch (e) {
      throw Exception('Error claiming car: $e');
    }
  }

  /// Deletes a car spot from the database
  Future<void> deleteCar(String carSpotId) async {
    try {
      await CarService().delete(carSpotId);
    } catch (e) {
      throw Exception('Error deleting car: $e');
    }
  }
}
