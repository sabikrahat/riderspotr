import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/payment/payment_screen.dart';
import 'package:ridespotr/presentation/providers/auth/user_provider.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/filter_chips.dart';
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
  String _selectedFilterLabel = 'All (0)'; // Track the display label
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

    // Add "All" with count
    final allLabel = 'All';
    filters.add(allLabel);

    // Update selected label if it was "All"
    if (_selectedRarity == null) {
      _selectedFilterLabel = allLabel;
    }

    // Add each rarity with count
    for (final rarity in Rarity.values) {
      // final count = allCars.where((car) => car.car?.rarity == rarity).length;
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

    // Extract rarity name from "RarityName (count)"
    final rarityName = label.split(' (')[0];
    return Rarity.values.firstWhere(
      (r) => r.name == rarityName,
      orElse: () => Rarity.values.first,
    );
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

                  final subscription = ref.watch(subscriptionProvider.notifier);
                  final currentCarCount = data.length;
                  final maxSpots = subscription.maxCarSpots;
                  final canAddMore = subscription.canAddMoreCars(
                    currentCarCount,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Visibility Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'GARAGE',
                                style: context.textTheme.headlineMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w300,
                                    ),
                              ),
                              const Gap(4),
                              GestureDetector(
                                onTap: () =>
                                    context.push(PaymentScreen.routeName),
                                child: Text(
                                  maxSpots == -1
                                      ? '$currentCarCount cars (Unlimited)'
                                      : '$currentCarCount / $maxSpots cars${!canAddMore ? ' • Upgrade!' : ''}',
                                  style: context.textTheme.bodySmall?.copyWith(
                                    color: !canAddMore
                                        ? Colors.orange
                                        : Colors.white.withValues(alpha: 0.6),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Visibility Toggle Button with Optimistic Updates
                          Consumer(
                            builder: (_, ref, _) {
                              ref.watch(userProvider);
                              final userNotifier = ref.read(
                                userProvider.notifier,
                              );
                              final isPublic =
                                  userNotifier.user?.isGaragePrivate == false;

                              return GestureDetector(
                                onTap: () async {
                                  if (userNotifier.user == null) return;

                                  // Optimistic update - update backend without loading state
                                  await userNotifier.updateUser(
                                    user: userNotifier.user!.copyWith(
                                      isGaragePrivate:
                                          !(userNotifier
                                                  .user
                                                  ?.isGaragePrivate ??
                                              false),
                                    ),
                                  );
                                  await userNotifier.refreshUser();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white.withValues(alpha: 0.08),
                                        Colors.white.withValues(alpha: 0.03),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isPublic ? Icons.public : Icons.lock,
                                        size: 16,
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                      Gap(8),
                                      Text(
                                        isPublic ? 'Public' : 'Private',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.3,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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

  Widget _buildEmptyState(List<CarSpotModel> allCars) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withValues(alpha: 0.5),
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

// Sort Dropdown Widget - Leaderboard Style
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
          items: SortOptions.values.map((option) {
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

// // Provider for search controller (disposed automatically)
// final _searchControllerProvider = Provider<TextEditingController>((ref) {
//   final controller = TextEditingController();

//   ref.onDispose(() {
//     controller.dispose();
//   });
//   return controller;
// });
