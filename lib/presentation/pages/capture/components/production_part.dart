import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions.dart';

class ProductionPart extends StatelessWidget {
  const ProductionPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(
            height: 360,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductionCard(
                        title: 'YEARS PRODUCED',
                        subtitle: '2018 - 2020',
                      ),
                      ProductionCard(
                        title: 'ORIGINAL MSRP',
                        subtitle: '\$958,966',
                      ),
                      ProductionCard(
                        title: 'TOTAL MADE',
                        subtitle: '500',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Description',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(16),
                Expanded(
                  child: Image.asset(
                    'assets/images/production.png',
                    height: 360,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Gap(16),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam id efficitur ligula. Vivamus quis ligula urna. Nullam suscipit magna quis eleifend ultrices.',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
          Gap(16),
          Stack(
            children: [
              ArcProgressBar(
                percentage: 85,
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                arcThickness: 5,
                handleSize: 20,
                centerWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '\$',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    Gap(12),
                    Text(
                      'EST. Value',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Gap(12),
                    Text(
                      '\$1,200,000 - \$2,000,000',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              ArcProgressBar(
                percentage: 70,
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                arcThickness: 5,
                handleSize: 20,
              ),
            ],
          ),
          // TweenAnimationBuilder<double>(
          //   tween: Tween(begin: 0.0, end: 1.0),
          //   duration: const Duration(milliseconds: 1500),
          //   curve: Curves.easeOutCubic,
          //   builder: (_, value, __) => ArcProgressBar(
          //     progress: value, // Animated progress (0.0 to 1.0)
          //     msrp: 0.65, // MSRP marker at ~65%
          //     current: 0.85, // Current marker at ~85%
          //     size: const Size(380, 200),
          //     stroke: 5.0,
          //   ),
          // ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: ProductionCard(
                  title: 'TOTAL PRODUCED',
                  subtitle: '500',
                ),
              ),
              Gap(16),
              Expanded(
                child: ProductionCard(
                  title: 'EST. IN CIRCULATION',
                  subtitle: '300',
                ),
              ),
            ],
          ),
          Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                width: 3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Gap(16),
              Expanded(
                child: Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam id efficitur ligula. Vivamus quis ligula urna. Nullam suscipit magna quis eleifend ultrices.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Gap(24),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 8),
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
            child: Text(
              'EPIC',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.purpleAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Gap(100),
        ],
      ),
    );
  }
}

class ProductionCard extends StatelessWidget {
  const ProductionCard({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade900, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.calendar_today, size: 18, color: Colors.white),
          ),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Gap(8),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
