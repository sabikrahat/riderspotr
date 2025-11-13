import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/car/garage_provider.dart';
import '../shared/filter_chips.dart';
import '../shared/search_text_field.dart';
import 'garage_grid_card.dart';

class ProfileGarageTab extends ConsumerStatefulWidget {
  const ProfileGarageTab({super.key, this.userId});

  /// If userId is null, shows the current user's garage
  final String? userId;

  @override
  ConsumerState<ProfileGarageTab> createState() => _ProfileGarageTabState();
}

class _ProfileGarageTabState extends ConsumerState<ProfileGarageTab> {
  // Local state
  late TextEditingController _searchController;
  String _searchQuery = '';
  Rarity? _selectedRarity;
  String _selectedFilterLabel = 'All';
  SortOptions _selectedSort = SortOptions.recent;

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

  void _onSortChanged(SortOptions sort) {
    setState(() {
      _selectedSort = sort;
    });
  }

  List<String> _buildFilterOptions(List<CarSpotModel> allCars) {
    final filters = <String>[];

    // Add "All"
    final allLabel = 'All';
    filters.add(allLabel);

    // Update selected label if it was "All"
    if (_selectedRarity == null) {
      _selectedFilterLabel = allLabel;
    }

    // Add each rarity
    for (final rarity in Rarity.values) {
      final label = rarity.name;
      filters.add(label);

      // Update selected label if this rarity is selected
      if (_selectedRarity == rarity) {
        _selectedFilterLabel = label;
      }
    }

    return filters;
  }

  Rarity? _parseRarityFromLabel(String label) {
    if (label.startsWith('All')) return null;

    // Extract rarity name
    final rarityName = label.split(' (')[0];
    return Rarity.values.firstWhere(
      (r) => r.name == rarityName,
      orElse: () => Rarity.values.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(garageProvider(widget.userId))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (data) {
            final notifier = ref.read(garageProvider(widget.userId).notifier);
            final sortedCars = notifier.getFilteredCars(
              searchQuery: _searchQuery,
              rarity: _selectedRarity,
              sortBy: _selectedSort,
            );

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  const Gap(16),
                  // Filter Chips
                  FilterChips(
                    options: _buildFilterOptions(data),
                    selectedValue: _selectedFilterLabel,
                    onChanged: (value) {
                      setState(() {
                        _selectedFilterLabel = value;
                        _selectedRarity = _parseRarityFromLabel(value);
                      });
                    },
                  ),
                  const Gap(16),
                  // Sort Options
                  _SortDropdown(
                    selectedSort: _selectedSort,
                    onSortChanged: _onSortChanged,
                  ),
                  const Gap(16),
                  // Car Cards Grid
                  if (sortedCars.isEmpty)
                    _buildEmptyState(data)
                  else
                    GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                        childAspectRatio: 4 / 5,
                      ),
                      itemCount: sortedCars.length,
                      itemBuilder: (context, index) {
                        return GarageGridCard(
                          carSpot: sortedCars[index],
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
  }

  Widget _buildEmptyState(List<CarSpotModel> allCars) {
    final isEmptyGarage =
        allCars.isEmpty && _searchQuery.isEmpty && _selectedRarity == null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isEmptyGarage ? Icons.directions_car_outlined : Icons.search_off,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
          ),
          const Gap(16),
          Text(
            _searchQuery.isNotEmpty || _selectedRarity != null
                ? 'No cars found'
                : allCars.isEmpty
                ? 'No cars in garage yet'
                : 'No cars match your filters',
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(20),
          if (_searchQuery.isNotEmpty || _selectedRarity != null) ...[
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

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.selectedSort,
    required this.onSortChanged,
  });

  final SortOptions selectedSort;
  final void Function(SortOptions) onSortChanged;

  @override
  Widget build(BuildContext context) {
    // Only show Most Recent and Rarity options
    final allowedOptions = [SortOptions.recent, SortOptions.rarity];

    return Row(
      children: [
        Text(
          'Sort by',
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        const Gap(12),
        DropdownButton<SortOptions>(
          isDense: true,
          value: selectedSort,
          onChanged: (value) {
            if (value != null) {
              onSortChanged(value);
            }
          },
          underline: const SizedBox.shrink(),
          dropdownColor: Color(0xFF0A0A0A),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withValues(alpha: 0.6),
            size: 20,
          ),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          items: allowedOptions.map((option) {
            return DropdownMenuItem<SortOptions>(
              value: option,
              child: Text(option.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
