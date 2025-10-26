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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Gap(16),
          Stack(
            children: [
              Image.asset(
                'assets/images/history-1.png',
                width: context.width,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: SizedBox(
                  width: context.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SIGNIFICANCE',
                        style: context.textTheme.headlineSmall,
                      ),
                      Gap(8),
                      Text(
                        history!.significance ??
                            'No significance data available.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Gap(16),
          Stack(
            children: [
              Image.asset(
                'assets/images/history-2.png',
                width: context.width,
              ),
              Positioned(
                top: 8,
                left: 8,
                child: SizedBox(
                  width: context.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MOTORSPORT HERITAGE',
                        style: context.textTheme.headlineSmall,
                      ),
                      Gap(8),
                      Text(
                        history!.heritage ??
                            'No motorsport heritage data available.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Gap(48),
                      Text(
                        'FUN FACTS',
                        style: context.textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //  Gap(8),
          ...List.generate(
            history!.funFacts?.length ?? 0,
            (i) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[800]!),
                  color: Colors.grey[800]!.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '💡',
                            style: context.textTheme.headlineSmall,
                          ),
                          Gap(8),
                          // Text(
                          //   history!.funFacts![i],
                          //   style: context.textTheme.bodyMedium?.copyWith(
                          //     fontSize: 14,
                          //     color: Colors.white,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ],
                      ),
                      Gap(8),
                      Expanded(
                        child: Text(
                          history!.funFacts![i],
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Gap(16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'DESIGNED BY',
                  style: context.textTheme.headlineSmall,
                ),
                Gap(8),
                Expanded(
                  child: Text(
                    history!.designerName ?? 'N/A',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Gap(100),
        ],
      ),
    );
  }
}
