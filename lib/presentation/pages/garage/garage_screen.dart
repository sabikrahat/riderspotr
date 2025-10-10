import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../widgets/garage/animated_privacy_toggle.dart';
import '../../widgets/shared/car_card.dart';
import '../../widgets/shared/page_padding.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  static const String routeName = '/garage';

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  bool isPublic = true;
  String selectedFilter = 'All (24)';
  String selectedSort = 'Most Recent';

  final List<String> filters = [
    'All (24)',
    'Legendary (1)',
    'Sports (12)',
    'Luxury (5)',
    'Electric (6)',
  ];
  final List<String> sortOptions = ['Most Recent', 'Oldest', 'A-Z', 'Z-A'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/carbon/garage-bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: PagePadding(
              child: Column(
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
                        isPublic: isPublic,
                        onToggle: () => setState(() => isPublic = !isPublic),
                      ),
                    ],
                  ),
                  Gap(24),
                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search your cars',
                            hintStyle: TextStyle(color: Colors.white, fontSize: 14),
                            filled: true,
                            fillColor: Colors.grey[900],
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
                            ),
                          ),
                        ),
                      ),
                      Gap(8),
                      Container(
                        padding: const EdgeInsets.all(11),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[800]!, width: 1),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Colors.white),
                      ),
                    ],
                  ),
                  Gap(16),

                  // Choice Chips
                  SingleChildScrollView(
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
                              setState(() {
                                selectedFilter = filter;
                              });
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
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Gap(16),

                  // Sort Options
                  Row(
                    children: [
                      Icon(Icons.swap_vert_rounded, color: Colors.white, size: 22),
                      Gap(4),
                      Text(
                        'Sort by',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gap(16),
                      DropdownButton<String>(
                        isDense: true,
                        value: selectedSort,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedSort = value;
                            });
                          }
                        },
                        underline: const SizedBox.shrink(),
                        dropdownColor: Colors.grey[900],
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
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
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Gap(16),

                  // Car Cards List
                  Expanded(
                    child: ListView.separated(
                      itemCount: 10, // Demo data
                      itemBuilder: (context, index) {
                        return CarCard();
                      },
                      separatorBuilder: (context, index) => Gap(24),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
