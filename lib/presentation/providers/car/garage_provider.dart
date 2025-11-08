import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums.dart';
import '../../../core/exception.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../services/car/car_service.dart';
import '../../../services/ml/ml_service.dart';

part 'garage_provider.g.dart';

@Riverpod(keepAlive: true)
class GarageNotifier extends _$GarageNotifier {
  List<CarSpotModel> _carSpots = [];
  final MLService _mlService = MLService();

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

  /// Compresses an image to ensure it's under 3MB
  Future<XFile> _compressImage(XFile imageFile) async {
    final file = File(imageFile.path);
    final fileSize = await file.length();

    // If already under 3MB, return as is
    const maxSize = 3 * 1024 * 1024; // 3MB in bytes
    if (fileSize < maxSize) {
      debugPrint(
        'Image size: ${fileSize / 1024 / 1024}MB - No compression needed',
      );
      return imageFile;
    }

    debugPrint('Image size: ${fileSize / 1024 / 1024}MB - Compressing...');

    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed${path.extension(imageFile.path)}',
      );

      // Start with quality 85 and reduce if needed
      int quality = 85;
      XFile? compressedFile;

      while (quality > 20) {
        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          minWidth: 1920,
          minHeight: 1080,
        );

        if (result != null) {
          final compressedSize = await File(result.path).length();
          debugPrint(
            'Compressed to ${compressedSize / 1024 / 1024}MB at quality $quality',
          );

          if (compressedSize < maxSize) {
            compressedFile = result;
            break;
          }
        }

        quality -= 10;
      }

      if (compressedFile == null) {
        debugPrint('Warning: Could not compress below 3MB, using best attempt');
        return imageFile;
      }

      final finalSize = await File(compressedFile.path).length();
      debugPrint('Final compressed size: ${finalSize / 1024 / 1024}MB');

      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return imageFile; // Return original on error
    }
  }

  /// Scans a car by uploading the image and calling the edge function
  /// Returns a CarSpotModel with is_claimed = false
  /// This method handles compression, blurring, uploading, and scanning
  Future<CarSpotModel> scanCar(XFile file) async {
    try {
      // Step 1: Compress image
      debugPrint('Step 1: Compressing image...');
      final compressedImage = await _compressImage(file);

      // Step 2: Detect and blur sensitive content (license plates and faces)
      debugPrint('Step 2: Detecting and blurring sensitive content...');
      final blurredImage = await _mlService.detectAndBlurSensitiveContent(
        compressedImage,
      );

      // Step 3: Upload image to storage
      debugPrint('Step 3: Uploading image to storage...');
      final imagePath = await CarService().uploadFileToStorage(blurredImage);
      if (imagePath == null) {
        throw Exception('Failed to upload image');
      }

      // Step 4: Scan the car and get the full CarSpotModel from the database
      debugPrint('Step 4: Scanning car...');
      final carSpotModel = await CarService().scanCar(imagePath);

      debugPrint('Car scan completed successfully!');
      return carSpotModel;
    } on EdgeFunctionException {
      // Re-throw EdgeFunctionException as-is
      rethrow;
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
      await refresh();
    } catch (e) {
      throw Exception('Error deleting car: $e');
    }
  }

  /// Search cars by query (searches model, make name, and full car name)
  List<CarSpotModel> searchCars(List<CarSpotModel> cars, String query) {
    if (query.isEmpty) return cars;

    final lowercaseQuery = query.toLowerCase();
    return cars.where((car) {
      final modelMatch =
          car.car?.model?.toLowerCase().contains(lowercaseQuery) ?? false;
      final makeName = car.car?.make?.name;
      final makeMatch =
          makeName?.toLowerCase().contains(lowercaseQuery) ?? false;
      final carName = '${makeName ?? ''} ${car.car?.model ?? ''}'
          .toLowerCase()
          .trim();
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
