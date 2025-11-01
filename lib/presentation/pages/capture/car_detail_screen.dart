import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../widgets/capture/car_detail_tab_bar.dart';
import '../../widgets/capture/history_part.dart';
import '../../widgets/capture/production_part.dart';
import '../../widgets/capture/specs_part.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/rarity_badge.dart';

class CarDetailScreen extends StatefulWidget {
  static const String routeName = '/car-detail';
  const CarDetailScreen({super.key, required this.carSpot});

  final CarSpotModel? carSpot;

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: selectedIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != selectedIndex) {
        setState(() {
          selectedIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final carSpot = widget.carSpot;
    if (carSpot == null) {
      return Scaffold(
        appBar: AppBar(
          leading: Back(),
        ),
        body: Center(
          child: Text(
            'No car data available.',
            style: context.textTheme.bodyMedium,
          ),
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background Image
            Stack(
              children: [
                Container(
                  width: context.width,
                  height: context.height * 0.5,
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
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(widget.carSpot!.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ), // Title and rarity
                Positioned(
                  child: Container(
                    width: context.width,
                    height: context.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 1),
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0),
                          Colors.black.withValues(alpha: 1),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RarityBadge(rarity: carSpot.car!.rarity),
                            const Gap(16),
                            Text(
                              carSpot.car!.make!.name.toUpperCase(),
                              style: context.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                                letterSpacing: 3,
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const Gap(2),
                            Text(
                              carSpot.car!.model!.toUpperCase(),
                              style: context.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                fontSize: 28,
                                height: 1.1,
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
                  child: CarDetailTabBar(
                    selectedIndex: selectedIndex,
                    onSelect: (newIndex) {
                      setState(() {
                        selectedIndex = newIndex;
                      });
                    },
                  ),
                ),
              ],
            ),
            // Tab Views
            selectedIndex == 0
                ? ProductionPart(car: widget.carSpot!.car!)
                : selectedIndex == 1
                ? SpecsPart(specs: widget.carSpot!.car!.specs)
                : HistoryPart(history: widget.carSpot!.car!.history),
          ],
        ),
      ),
    );
  }
}
