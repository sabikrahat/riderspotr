import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'components/production_part.dart';

import '../../../core/extensions.dart';
import '../../widgets/shared/back.dart';
import 'components/history_part.dart';
import 'components/specs_part.dart';

class CarDeatilScreen extends StatefulWidget {
  static const String routeName = '/car-detail';
  const CarDeatilScreen({super.key});

  @override
  State<CarDeatilScreen> createState() => _CarDeatilScreenState();
}

class _CarDeatilScreenState extends State<CarDeatilScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: Column(
        children: [
          // Background Image
          Stack(
            children: [
              SizedBox(
                width: context.width,
                height: context.height * 0.5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.asset('assets/images/lamborghini-hurcan.png', fit: BoxFit.cover),
                ),
              ), // Title and rarity
              Positioned(
                child: Container(
                  width: context.width,
                  height: context.height * 0.4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 1),
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LAMBORGHINI AVENTADOR',
                            style: context.textTheme.headlineMedium,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purpleAccent),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purpleAccent.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              child: Text(
                                'EPIC',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  color: Colors.purpleAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Bottom Slider
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 55,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    splashBorderRadius: BorderRadius.circular(30),
                    physics: BouncingScrollPhysics(),
                    indicatorColor: Colors.white,
                    automaticIndicatorColorAdjustment: true,
                    unselectedLabelColor: Colors.white70,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    indicator: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Production'),
                      Tab(text: 'Specs'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(16),
          // Tab Views
          selectedIndex == 0
              ? ProductionPart()
              : selectedIndex == 1
              ? SpecsPart()
              : HistoryPart(),
        ],
      ),
    );
  }
}
