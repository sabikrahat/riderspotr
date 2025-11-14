import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/capture/car_detail_tab_bar.dart';
import '../../widgets/capture/history_part.dart';
import '../../widgets/capture/production_part.dart';
import '../../widgets/capture/specs_part.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/rarity_badge.dart';
import '../../widgets/shared/locked_content.dart';
import 'car_preview_screen.dart';
import 'report_car_screen.dart';

class CarDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = '/car-detail';
  const CarDetailScreen({super.key, required this.carSpot});

  final CarSpotModel? carSpot;

  @override
  ConsumerState<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends ConsumerState<CarDetailScreen>
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
    final subscription = ref.watch(subscriptionProvider.notifier);
    final hasStatsAccess = subscription.hasStatsAccess;
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.flag,
              color: Colors.white.withValues(alpha: 0.9),
              size: 24,
            ),
            onPressed: () {
              context.push(ReportCarScreen.routeName, extra: carSpot);
            },
            tooltip: 'Report car',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background Image
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CarPreviewScreen(
                      carSpot: carSpot,
                      showDetailsButton: false,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    child: SizedBox(
                      width: context.width,
                      height: context.height * 0.5,
                      child: FastCachedImage(
                        key: Key(carSpot.id),
                        url: widget.carSpot!.imageUrl,
                        fit: BoxFit.cover,
                        fadeInDuration: const Duration(milliseconds: 300),
                        errorBuilder: (context, exception, stacktrace) {
                          return Container(
                            color: Colors.grey.shade900,
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.white24,
                                size: 48,
                              ),
                            ),
                          );
                        },
                        loadingBuilder: (context, progress) {
                          return Container(
                            color: Colors.grey.shade900,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Colors.white24,
                                value: progress.progressPercentage.value,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Gradient overlay
                  // Container(
                  //   width: context.width,
                  //   height: context.height * 0.2,
                  //   decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       begin: Alignment.topCenter,
                  //       end: Alignment.bottomCenter,
                  //       colors: [
                  //         // Colors.black.withValues(alpha: 1),
                  //         Colors.black.withValues(alpha: 0),
                  //         Colors.black.withValues(alpha: 0),
                  //       ],
                  //     ),
                  //     borderRadius: const BorderRadius.only(
                  //       bottomLeft: Radius.circular(30),
                  //       bottomRight: Radius.circular(30),
                  //     ),
                  //   ),
                  // ), // Title and rarity
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
                            Colors.black.withValues(alpha: 0.6),
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
                                carSpot.car?.make?.name.toUpperCase() ??
                                    'UNKNOWN',
                                style: context.textTheme.headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 3,
                                      fontSize: 24,
                                    ),
                              ),
                              const Gap(4),

                              // Car Model (Normal weight)
                              Text(
                                carSpot.car?.model?.toUpperCase() ?? 'UNKNOWN',
                                style: context.textTheme.headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w200,
                                      letterSpacing: 1,
                                      fontSize: 16,
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
            ),
            // Tab Views
            hasStatsAccess
                ? (selectedIndex == 0
                      ? ProductionPart(car: widget.carSpot!.car!)
                      : selectedIndex == 1
                      ? SpecsPart(specs: widget.carSpot!.car!.specs)
                      : HistoryPart(history: widget.carSpot!.car!.history))
                : const LockedContent(
                    title: 'CAR DETAILS\nLOCKED',
                    description:
                        'Upgrade to unlock full car details,\nspecifications, and history.',
                  ),
          ],
        ),
      ),
    );
  }
}
