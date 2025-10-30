import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_history_model.dart';

class HistoryPart extends StatelessWidget {
  const HistoryPart({super.key, required this.history});

  final CarHistoryModel? history;

  @override
  Widget build(BuildContext context) {
    if (history == null) {
      return Center(
        child: Text(
          'No history data available.',
          style: context.textTheme.bodyMedium,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(16),

          // Significance Section
          _buildSectionCard(
            context: context,
            title: 'SIGNIFICANCE',
            content: history!.significance ?? 'No significance data available.',
            backgroundImage: 'assets/carbon/49.jpg',
          ),

          Gap(24),

          // Motorsport Heritage Section
          _buildSectionCard(
            context: context,
            title: 'MOTORSPORT HERITAGE',
            content:
                history!.heritage ?? 'No motorsport heritage data available.',
            backgroundImage: 'assets/carbon/47.jpg',
          ),

          Gap(32),

          // Fun Facts Header
          Row(
            children: [
              Container(
                height: 1,
                width: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Gap(12),
              Text(
                'FUN FACTS',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 20,
                  letterSpacing: 2,
                ),
              ),
              Gap(12),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),

          Gap(24),

          // Fun Facts List
          ...List.generate(
            history!.funFacts?.length ?? 0,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildFunFactCard(
                context: context,
                fact: history!.funFacts![i],
                index: i + 1,
              ),
            ),
          ),

          Gap(32),

          // Designer Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[900]!.withValues(alpha: 0.5),
                  Colors.grey[800]!.withValues(alpha: 0.3),
                ],
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.design_services_outlined,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: 24,
                ),
                Gap(16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESIGNED BY',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1.5,
                        color: Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                    Gap(4),
                    Text(
                      history!.designerName ?? 'N/A',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Gap(100),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required String content,
    required String backgroundImage,
  }) {
    return Stack(
      children: [
        // Carbon fiber background with edge fade
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.asset(
                backgroundImage,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
              ),
              // Vignette effect - darker in center, fades at edges
              Container(
                height: 250,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Edge fade for seamless blending
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content with text shadow for readability
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              Gap(16),
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              Gap(16),
              Text(
                content,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.95),
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.8),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFunFactCard({
    required BuildContext context,
    required String fact,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey[800]!,
          width: 1,
        ),
        color: Colors.grey[900]!.withValues(alpha: 0.4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.withValues(alpha: 0.3),
                  Colors.purple.withValues(alpha: 0.3),
                ],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Gap(16),
          Expanded(
            child: Text(
              fact,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 15,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
