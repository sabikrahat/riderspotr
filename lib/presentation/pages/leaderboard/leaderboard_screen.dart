import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../widgets/leaderboard/comparison_bar.dart';
import '../../widgets/leaderboard/summary_card.dart';
import '../../widgets/shared/page_padding.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  static const String routeName = '/leaderboard';

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  String selectedFilter = 'Global';
  final List<String> filters = ['Global', 'Country', 'City', 'Friends', 'Following', 'You'];
  String selectedSort = 'Overall';
  final List<String> sortOptions = ['Overall', 'This Month', 'This Week', 'Today'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/carbon/leaderboard-bg.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.topCenter,
            child: PagePadding(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'LEADERBOARD',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(45),
                          onTap: () {},
                          child: Icon(Icons.person_add_alt, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                    Gap(24),
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

                    // Summary Card
                    LeaderboardSummaryCard(),
                    Gap(16),

                    // Learderboard Bar
                    LeaderboardComparisonBar(
                      firstPlaceImage: 'https://picsum.photos/200',
                      firstPlaceName: 'nathfreeman',
                      secondPlaceImage: 'https://picsum.photos/200',
                      secondPlaceName: 'samhung',
                      thirdPlaceImage: 'https://picsum.photos/200',
                      thirdPlaceName: 'sabikrahat',
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
                    ...List.generate(
                      5,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/demo-short.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.0),
                                        Colors.black.withValues(alpha: 0.5),
                                        Colors.black.withValues(alpha: 0.9),
                                      ],
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundImage: const NetworkImage(
                                          'https://picsum.photos/200',
                                        ),
                                      ),
                                      Gap(12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Charlie Crozier',
                                              style: context.textTheme.bodyMedium?.copyWith(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '@charlie',
                                              style: context.textTheme.bodyMedium?.copyWith(
                                                color: Colors.white70,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '#',

                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              height: 1.5,
                                            ),
                                          ),
                                          Gap(1),
                                          Text(
                                            '4',
                                            style: context.textTheme.bodyMedium?.copyWith(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
