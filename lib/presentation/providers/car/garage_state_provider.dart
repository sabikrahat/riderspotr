// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// import 'package:ridespotr/models/car/car_spot_model.dart';
// import 'garage_provider.dart';

// // State class to hold all garage UI state
// class GarageState {
//   final bool isPublic;
//   final String selectedFilter;
//   final String selectedSort;
//   final String searchQuery;

//   const GarageState({
//     this.isPublic = true,
//     this.selectedFilter = 'All (24)',
//     this.selectedSort = 'Most Recent',
//     this.searchQuery = '',
//   });

//   GarageState copyWith({
//     bool? isPublic,
//     String? selectedFilter,
//     String? selectedSort,
//     String? searchQuery,
//   }) {
//     return GarageState(
//       isPublic: isPublic ?? this.isPublic,
//       selectedFilter: selectedFilter ?? this.selectedFilter,
//       selectedSort: selectedSort ?? this.selectedSort,
//       searchQuery: searchQuery ?? this.searchQuery,
//     );
//   }
// }

// // Garage state provider
// final garageStateProvider =
//     StateNotifierProvider<GarageStateNotifier, GarageState>(
//       (ref) => GarageStateNotifier(),
//     );

// class GarageStateNotifier extends StateNotifier<GarageState> {
//   GarageStateNotifier() : super(const GarageState());

//   void togglePrivacy() {
//     state = state.copyWith(isPublic: !state.isPublic);
//   }

//   void setFilter(String filter) {
//     state = state.copyWith(selectedFilter: filter);
//   }

//   void setSort(String sort) {
//     state = state.copyWith(selectedSort: sort);
//   }

//   void setSearchQuery(String query) {
//     state = state.copyWith(searchQuery: query);
//   }

//   void clearSearch() {
//     state = state.copyWith(searchQuery: '');
//   }
// }

// // Filter and sort constants
// final filtersProvider = Provider<List<String>>(
//   (ref) => [
//     'All (24)',
//     'Legendary (1)',
//     'Sports (12)',
//     'Luxury (5)',
//     'Electric (6)',
//   ],
// );

// final sortOptionsProvider = Provider<List<String>>(
//   (ref) => [
//     'Most Recent',
//     'Oldest',
//     'A-Z',
//     'Z-A',
//   ],
// );

// // Provider for filtered and sorted cars
// final filteredCarsProvider = Provider<List<CarSpotModel>>((ref) {
//   final cars = ref.watch(garageProvider).value ?? [];
//   final state = ref.watch(garageStateProvider);

//   // Apply search
//   final searchedCars = _searchCars(cars, state.searchQuery);

//   // Apply filter
//   final filteredCars = _filterCars(searchedCars, state.selectedFilter);

//   // Apply sort
//   final sortedCars = _sortCars(filteredCars, state.selectedSort);

//   return sortedCars;
// });

// // Provider for search results count
// final searchResultsCountProvider = Provider<int>((ref) {
//   return ref.watch(filteredCarsProvider).length;
// });

// // Search function
// List<CarSpotModel> _searchCars(List<CarSpotModel> cars, String query) {
//   if (query.isEmpty) return cars;

//   final lowercaseQuery = query.toLowerCase();
//   return cars.where((car) {
//     final modelMatch =
//         car.car?.model?.toLowerCase().contains(lowercaseQuery) ?? false;
//     final makeName = car.car?.make?.name;
//     final makeMatch = makeName?.toLowerCase().contains(lowercaseQuery) ?? false;
//     final carName = '${makeName ?? ''} ${car.car?.model ?? ''}'
//         .toLowerCase()
//         .trim();
//     final nameMatch = carName.contains(lowercaseQuery);

//     return modelMatch || makeMatch || nameMatch;
//   }).toList();
// }

// // Filter function
// List<CarSpotModel> _filterCars(List<CarSpotModel> cars, String filter) {
//   if (filter == 'All (24)') return cars;

//   switch (filter) {
//     case 'Legendary (1)':
//       return cars.where((car) {
//         return car.car?.model?.toLowerCase().contains('legendary') ?? false;
//       }).toList();
//     case 'Sports (12)':
//       return cars.where((car) {
//         return car.car?.model?.toLowerCase().contains('sports') ?? false;
//       }).toList();
//     case 'Luxury (5)':
//       return cars.where((car) {
//         return car.car?.model?.toLowerCase().contains('luxury') ?? false;
//       }).toList();
//     case 'Electric (6)':
//       return cars.where((car) {
//         return car.car?.model?.toLowerCase().contains('electric') ?? false;
//       }).toList();
//     default:
//       return cars;
//   }
// }

// // Sort function
// List<CarSpotModel> _sortCars(List<CarSpotModel> cars, String sortBy) {
//   final sortedCars = List<CarSpotModel>.from(cars);

//   switch (sortBy) {
//     case 'Most Recent':
//       sortedCars.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//       break;
//     case 'Oldest':
//       sortedCars.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//       break;
//     case 'A-Z':
//       sortedCars.sort((a, b) {
//         final carNameA = a.car?.model ?? '';
//         final carNameB = b.car?.model ?? '';
//         return carNameA.compareTo(carNameB);
//       });
//       break;
//     case 'Z-A':
//       sortedCars.sort((a, b) {
//         final carNameA = a.car?.model ?? '';
//         final carNameB = b.car?.model ?? '';
//         return carNameB.compareTo(carNameA);
//       });
//       break;
//   }

//   return sortedCars;
// }
