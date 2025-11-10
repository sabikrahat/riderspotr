import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth/profile_provider.dart';
import '../../widgets/home/achievements_section.dart';
// import '../../widgets/home/daily_tasks_section.dart';
import '../../widgets/home/hero_section.dart';
import '../../widgets/home/stats_grid_section.dart';
import '../../widgets/home/upgrade_promo_section.dart';
import '../../widgets/home/xp_progress_section.dart';
import '../payment/payment_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.isFinishRegister = false});

  static const String routeName = '/home';
  final bool isFinishRegister;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.isFinishRegister) {
      // Show payment screen after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.push(PaymentScreen.routeName);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(profileProvider(null))
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text(error.toString())),
          data: (_) {
            final notifier = ref.read(profileProvider(null).notifier);
            final user = notifier.user;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section with Carbon Fiber
                  HeroSection(user: user),

                  const Gap(24),

                  // Upgrade Promo Section
                  const UpgradePromoSection(),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // XP Progress Section
                        if (user != null) XPProgressSection(user: user),

                        // Gap(40),

                        // // Daily Tasks Section
                        // DailyTasksSection(),
                        Gap(40),

                        // Stats Grid Section
                        StatsGridSection(
                          stats: user?.stats,
                        ),

                        Gap(40),

                        // Achievements Section
                        AchievementsSection(user: user),

                        Gap(100),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
  }
}
