import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../pages/payment/payment_screen.dart';

class LockedContent extends StatelessWidget {
  const LockedContent({
    super.key,
    this.title = 'CONTENT\nLOCKED',
    this.description = 'Upgrade to unlock this feature.',
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lock Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
              ),
              child: const Icon(
                Icons.lock_outline,
                size: 40,
                color: Colors.white,
              ),
            ),
            const Gap(32),

            // Title
            Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w200,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),

            // Subtitle
            Text(
              description,
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
                height: 1.6,
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),

            // Upgrade Button
            GestureDetector(
              onTap: () => context.push(PaymentScreen.routeName),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'UPGRADE',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(100),
          ],
        ),
      ),
    );
  }
}
