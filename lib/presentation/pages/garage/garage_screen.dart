import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/car/garage_state_provider.dart';
import '../../widgets/garage/animated_privacy_toggle.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../capture/car_deatil_screen.dart';

class GarageScreen extends ConsumerWidget {
  const GarageScreen({super.key});

  static const String routeName = '/garage';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = ref.watch(_searchControllerProvider);
    final garageState = ref.watch(garageStateProvider);
    final filters = ref.watch(filtersProvider);
    final sortOptions = ref.watch(sortOptionsProvider);
    final searchResultsCount = ref.watch(searchResultsCountProvider);

    return Scaffold(
      body: CarbonBackground(
        imgPath: 'assets/carbon/garage-bg.jpg',
        child: PagePadding(
          child: ref
              .watch(garageProvider)
              .when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error: $error')),
                data: (data) {
                  final notifier = ref.read(garageProvider.notifier);
                  final sortedCars = ref.watch(filteredCarsProvider);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'YOUR GARAGE',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AnimatedPrivacyToggle(
                            isPublic: garageState.isPublic,
                            onToggle: () => ref
                                .read(garageStateProvider.notifier)
                                .togglePrivacy(),
                          ),
                        ],
                      ),
                      const Gap(24),
                      // Search Bar
                      _SearchBar(controller: searchController),
                      if (garageState.searchQuery.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            'Found $searchResultsCount car${searchResultsCount != 1 ? 's' : ''} for "${garageState.searchQuery}"',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Gap(8),
                      ],
                      const Gap(16),
                      // Choice Chips
                      _FilterChips(filters: filters),
                      const Gap(16),
                      // Sort Options
                      _SortDropdown(sortOptions: sortOptions),
                      const Gap(16),
                      // Car Cards List
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async => await notifier.refresh(),
                          child: sortedCars.isEmpty
                              ? Center(
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
                                        garageState.searchQuery.isNotEmpty
                                            ? 'No cars found for "${garageState.searchQuery}"'
                                            : 'No cars in your garage. Pull down to refresh.',
                                        style: context.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (garageState
                                          .searchQuery
                                          .isNotEmpty) ...[
                                        const Gap(8),
                                        TextButton(
                                          onPressed: () => ref
                                              .read(
                                                garageStateProvider.notifier,
                                              )
                                              .clearSearch(),
                                          child: Text(
                                            'Clear search',
                                            style: context.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  itemCount: sortedCars.length,
                                  itemBuilder: (context, index) {
                                    return CarCard(
                                      carSpot: sortedCars[index],
                                      onTap: () async => await context.push(
                                        CarDeatilScreen.routeName,
                                        extra: sortedCars[index],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Gap(24),
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
}

// Search Bar Widget
class _SearchBar extends ConsumerWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final garageState = ref.watch(garageStateProvider);
    final stateNotifier = ref.read(garageStateProvider.notifier);

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            onChanged: stateNotifier.setSearchQuery,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search by car name, make or model...',
              suffixIcon: garageState.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      onPressed: () {
                        stateNotifier.clearSearch();
                        controller.clear();
                      },
                    )
                  : null,
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.grey[900],
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey[800]!,
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Filter Chips Widget
class _FilterChips extends ConsumerWidget {
  const _FilterChips({required this.filters});

  final List<String> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = ref.watch(
      garageStateProvider.select((state) => state.selectedFilter),
    );
    final stateNotifier = ref.read(garageStateProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  stateNotifier.setFilter(filter);
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
                  color: isSelected ? Colors.white : Colors.grey[800]!,
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
class _SortDropdown extends ConsumerWidget {
  const _SortDropdown({required this.sortOptions});

  final List<String> sortOptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSort = ref.watch(
      garageStateProvider.select((state) => state.selectedSort),
    );
    final stateNotifier = ref.read(garageStateProvider.notifier);

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
        DropdownButton<String>(
          isDense: true,
          value: selectedSort,
          onChanged: (value) {
            if (value != null) {
              stateNotifier.setSort(value);
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
          items: sortOptions.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
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

// Provider for search controller (disposed automatically)
final _searchControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();

  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});
