import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/core/extensions.dart';
import 'package:ridespotr/presentation/providers/subscription/subscription_provider.dart';
import 'package:ridespotr/presentation/widgets/shared/back.dart';
import 'package:ridespotr/presentation/widgets/shared/carbon_background.dart';
import 'payment_screen.dart';

class UpgradeRequiredScreen extends ConsumerWidget {
  const UpgradeRequiredScreen({super.key});

  static const String routeName = '/upgrade-required';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscription = ref.watch(subscriptionProvider.notifier);
    final maxSpots = subscription.maxCarSpots;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Back(),
      ),
      body: CarbonBackground(
        imgPath: 'assets/carbon/garage-bg.jpg',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.15),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const Gap(24),
                Text(
                  'GARAGE LIMIT\nREACHED',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w200,
                    letterSpacing: 4,
                    color: Colors.white,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                Text(
                  'You\'ve reached your limit of $maxSpots cars.\nUpgrade to add more to your collection.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.6,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                GestureDetector(
                  onTap: () => context.push(PaymentScreen.routeName),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        'UPGRADE',
                        style: context.textTheme.headlineSmall?.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(12),
                // Back Button - Minimal
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'MAYBE LATER',
                        style: TextStyle(),
                      ),
                    ),
                  ),
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
