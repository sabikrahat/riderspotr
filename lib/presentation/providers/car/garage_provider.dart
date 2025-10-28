import 'dart:async';

import 'package:camera/camera.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../services/car/car_service.dart';

part 'garage_provider.g.dart';

@Riverpod(keepAlive: true)
class GarageNotifier extends _$GarageNotifier {
  List<CarSpotModel> _carSpots = [];

  @override
  FutureOr<List<CarSpotModel>> build(String? arg) async {
    _carSpots = await CarService().getCarSpots(arg);
    return _carSpots;
  }

  List<CarSpotModel> get carSpots => _carSpots;

  Future<void> refresh() async {
    _carSpots = await CarService().getCarSpots(arg);
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

  /// Search cars by query (searches model, make name, and full car name)
  List<CarSpotModel> searchCars(List<CarSpotModel> cars, String query) {
    if (query.isEmpty) return cars;

    final lowercaseQuery = query.toLowerCase();
    return cars.where((car) {
      final modelMatch = car.car?.model?.toLowerCase().contains(lowercaseQuery) ?? false;
      final makeName = car.car?.make?.name;
      final makeMatch = makeName?.toLowerCase().contains(lowercaseQuery) ?? false;
      final carName = '${makeName ?? ''} ${car.car?.model ?? ''}'.toLowerCase().trim();
      final nameMatch = carName.contains(lowercaseQuery);

      return modelMatch || makeMatch || nameMatch;
    }).toList();
  }

  /// Filter cars by rarity
  List<CarSpotModel> filterCars(List<CarSpotModel> cars, Rarity? rarity) {
    if (rarity == null) return cars;

    return cars.where((car) => car.car?.rarity == rarity).toList();
  }

  /// Sort cars by the selected sort option
  List<CarSpotModel> sortCars(List<CarSpotModel> cars, SortOptions sortBy) {
    final sortedCars = List<CarSpotModel>.from(cars);

    switch (sortBy) {
      case SortOptions.recent:
        sortedCars.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOptions.oldest:
        sortedCars.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case SortOptions.alphabetical:
        sortedCars.sort((a, b) {
          final carNameA = a.car?.model ?? '';
          final carNameB = b.car?.model ?? '';
          return carNameA.compareTo(carNameB);
        });
        break;
      case SortOptions.alphabeticalReverse:
        sortedCars.sort((a, b) {
          final carNameA = a.car?.model ?? '';
          final carNameB = b.car?.model ?? '';
          return carNameB.compareTo(carNameA);
        });
        break;
    }

    return sortedCars;
  }

  /// Getter to apply search, filter, and sort to car list
  List<CarSpotModel> getFilteredCars({
    required String searchQuery,
    required Rarity? rarity,
    required SortOptions sortBy,
  }) {
    // Apply search
    final searchedCars = searchCars(_carSpots, searchQuery);

    // Apply filter
    final filteredCars = filterCars(searchedCars, rarity);

    // Apply sort
    final sortedCars = sortCars(filteredCars, sortBy);

    return sortedCars;
  }
}
