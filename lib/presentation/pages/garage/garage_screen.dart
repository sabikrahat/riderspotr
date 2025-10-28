import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/car/garage_provider.dart';
import '../../widgets/garage/animated_privacy_toggle.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/search_text_field.dart';

class GarageScreen extends ConsumerStatefulWidget {
  const GarageScreen({super.key});

  static const String routeName = '/garage';

  @override
  ConsumerState<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends ConsumerState<GarageScreen> {
  // Local state
  late TextEditingController _searchController;
  String _searchQuery = '';
  Rarity? _selectedRarity;
  SortOptions _selectedSort = SortOptions.recent;
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  void _onFilterChanged(Rarity? rarity) {
    setState(() {
      _selectedRarity = rarity;
    });
  }

  void _onSortChanged(SortOptions sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

  void _togglePrivacy() {
    setState(() {
      _isPublic = !_isPublic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarbonBackground(
        imgPath: 'assets/carbon/garage-bg.jpg',
        child: PagePadding(
          child: ref
              .watch(garageProvider(null))
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (data) {
                  final notifier = ref.read(garageProvider(null).notifier);
                  final sortedCars = notifier.getFilteredCars(
                    searchQuery: _searchQuery,
                    rarity: _selectedRarity,
                    sortBy: _selectedSort,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'GARAGE',
                            style: context.textTheme.headlineMedium,
                          ),
                          AnimatedPrivacyToggle(
                            isPublic: _isPublic,
                            onToggle: _togglePrivacy,
                          ),
                        ],
                      ),
                      const Gap(16),
                      // Search Bar
                      SearchTextField(
                        hintText: 'Search by car name, make or model...',
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        showClearButton: _searchQuery.isNotEmpty,
                        onClear: _clearSearch,
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        const Gap(8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Found ${sortedCars.length} car${sortedCars.length != 1 ? 's' : ''} for "$_searchQuery"',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                      const Gap(16),
                      // Choice Chips
                      _FilterChips(
                        allCars: data,
                        selectedRarity: _selectedRarity,
                        onFilterChanged: _onFilterChanged,
                      ),
                      const Gap(16),
                      // Sort Options
                      _SortDropdown(
                        selectedSort: _selectedSort,
                        onSortChanged: _onSortChanged,
                      ),
                      const Gap(16),
                      // Car Cards List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async => await notifier.refresh(),
                          child: sortedCars.isEmpty
                              ? _buildEmptyState(data)
                              : ListView.separated(
                                  itemCount: sortedCars.length,
                                  itemBuilder: (context, index) {
                                    return CarCard(
                                      carSpot: sortedCars[index],
                                    );
                                  },
                                  separatorBuilder: (context, index) => const Gap(24),
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(List<CarSpotModel> allCars) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.5),
          ),
          const Gap(16),
          Text(
            _searchQuery.isNotEmpty || _selectedRarity != null
                ? 'No cars found'
                : allCars.isEmpty
                ? 'No cars in your garage. Pull down to refresh.'
                : 'No cars match your filters',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty || _selectedRarity != null) ...[
            const Gap(8),
            TextButton(
              onPressed: () {
                _clearSearch();
                setState(() {
                  _selectedRarity = null;
                });
              },
              child: Text(
                'Clear filters',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.blue,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Search Bar Widget
// class _SearchBar extends ConsumerWidget {
//   const _SearchBar({required this.controller});

//   final TextEditingController controller;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final garageState = ref.watch(garageStateProvider);
//     final stateNotifier = ref.read(garageStateProvider.notifier);

//     return Row(
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             onChanged: stateNotifier.setSearchQuery,
//             style: const TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: 'Search by car name, make or model...',
//               suffixIcon: garageState.searchQuery.isNotEmpty
//                   ? IconButton(
//                       icon: Icon(
//                         Icons.clear,
//                         color: Colors.white.withOpacity(0.7),
//                       ),
//                       onPressed: () {
//                         stateNotifier.clearSearch();
//                         controller.clear();
//                       },
//                     )
//                   : null,
//               hintStyle: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//               ),
//               filled: true,
//               fillColor: Colors.grey[900],
//               prefixIcon: const Icon(
//                 Icons.search,
//                 color: Colors.white,
//               ),
//               contentPadding: const EdgeInsets.symmetric(
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey[800]!,
//                   width: 1,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey[800]!,
//                   width: 1,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(
//                   color: Colors.grey[800]!,
//                   width: 1,
//                 ),
//               ),
//             ),
//           ),
//         ),
//         const Gap(8),
//         Container(
//           padding: const EdgeInsets.all(11),
//           decoration: BoxDecoration(
//             color: Colors.grey[900],
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: Colors.grey[800]!,
//               width: 1,
//             ),
//           ),
//           child: const Icon(
//             Icons.tune_rounded,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }

// Filter Chips Widget
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.allCars,
    required this.selectedRarity,
    required this.onFilterChanged,
  });

  final List<CarSpotModel> allCars;
  final Rarity? selectedRarity;
  final void Function(Rarity?) onFilterChanged;

  int _getCountForRarity(Rarity? rarity) {
    if (rarity == null) {
      return allCars.length;
    }
    return allCars.where((car) => car.car?.rarity == rarity).length;
  }

  @override
  Widget build(BuildContext context) {
    // Create filter options: null (All) + all rarity values
    final filters = <({String label, Rarity? value})>[
      (label: 'All', value: null),
      ...Rarity.values.map((r) => (label: r.name, value: r)),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedRarity == filter.value;
          final count = _getCountForRarity(filter.value);
          final displayLabel = '${filter.label} ($count)';

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(displayLabel),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onFilterChanged(filter.value);
                }
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              backgroundColor: Colors.grey[900],
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.white : Colors.grey[850]!,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// Sort Dropdown Widget
class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.selectedSort,
    required this.onSortChanged,
  });

  final SortOptions selectedSort;
  final void Function(SortOptions) onSortChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.swap_vert_rounded,
          color: Colors.white,
          size: 16,
        ),
        const Gap(4),
        Text(
          'Sort by',
          style: context.textTheme.bodyMedium,
        ),
        const Gap(16),
        DropdownButton<SortOptions>(
          isDense: true,
          value: selectedSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
            }
          },
          underline: const SizedBox.shrink(),
          dropdownColor: Colors.grey[900],
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 20,
          ),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          items: SortOptions.values.map((option) {
            return DropdownMenuItem<SortOptions>(
              value: option,
              child: Text(
                option.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// // Provider for search controller (disposed automatically)
// final _searchControllerProvider = Provider<TextEditingController>((ref) {
//   final controller = TextEditingController();

//   ref.onDispose(() {
//     controller.dispose();
//   });
//   return controller;
// });
