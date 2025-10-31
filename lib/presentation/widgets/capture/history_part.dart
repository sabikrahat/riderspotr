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

          Gap(48),

          // Fun Facts Header
          Text(
            'FUN FACTS',
            style: context.textTheme.headlineSmall?.copyWith(
              fontSize: 13,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),

          Gap(20),

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

          Gap(48),

          // Designer Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.08),
                  Colors.white.withValues(alpha: 0.03),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.design_services_outlined,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 22,
                  ),
                ),
                Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DESIGNED BY',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    Gap(6),
                    Text(
                      history!.designerName ?? 'N/A',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 0.3,
                        color: Colors.white.withValues(alpha: 0.9),
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
    return Container(
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              fontSize: 14,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Gap(20),
          Text(
            content,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              height: 1.7,
              fontWeight: FontWeight.w300,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactCard({
    required BuildContext context,
    required String fact,
    required int index,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Center(
              child: Text(
                '$index',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
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
                height: 1.6,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w300,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
