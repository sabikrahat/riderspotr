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
          // TODO: Replace with actual design
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Speed Meter Type Design Coming Soon!',
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
          // TweenAnimationBuilder<double>(
          //   tween: Tween(begin: 0, end: 0.82),
          //   duration: const Duration(milliseconds: 900),
          //   builder: (_, value, __) => ArcProgressBar(
          //     progress: value, // length of blue arc (0..1)
          //     msrp: 0.76, // blue pointer position (0..1)
          //     current: 0.84, // white pointer position (0..1)
          //     size: const Size(420, 220),
          //     bgColor: Colors.grey,
          //     primary: Colors.red,
          //     secondary: Colors.green,
          //     stroke: 4,
          //   ),
          // ),
          Row(
            children: [
              Expanded(
                child: ProductionCard(title: 'TOTAL PRODUCED', subtitle: '500'),
              ),
              Gap(16),
              Expanded(
                child: ProductionCard(title: 'EST. IN CIRCULATION', subtitle: '300'),
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
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
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
