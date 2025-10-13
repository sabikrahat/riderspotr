import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import 'performance_gauge.dart';

class SpecsPart extends StatelessWidget {
  const SpecsPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Gap(8),
          PerformanceGaugeWidget(),
          // TODO: Replace with actual design
          // SizedBox(
          //   height: 200,
          //   child: Center(
          //     child: Text(
          //       'Speed Meter Type Design Coming Soon!',
          //       style: context.textTheme.bodyMedium?.copyWith(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 16,
          //         color: Colors.grey,
          //         fontStyle: FontStyle.italic,
          //       ),
          //     ),
          //   ),
          // ),
          // PerformanceGaugeWidget(
          //   accel1: 2.8,
          //   accel2: 2.8,
          //   accel3: 2.8,
          //   topSpeed: 200.0,
          //   speedUnit: 'km/h',
          // ),
          Gap(8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'ENGINE SPECS',
              style: context.textTheme.headlineSmall,
            ),
          ),
          Gap(16),
          SizedBox(
            height: 250,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/specs.png',
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    height: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SpecsCard(
                          title: 'CONFIGURATION',
                          subtitle: 'v8 Twin Turbo',
                        ),
                        SpecsCard(
                          title: 'CONFIGURATION',
                          subtitle: 'v8 Twin Turbo',
                        ),
                        SpecsCard(
                          title: 'CONFIGURATION',
                          subtitle: 'v8 Twin Turbo',
                        ),
                        SpecsCard(
                          title: 'CONFIGURATION',
                          subtitle: 'v8 Twin Turbo',
                        ),
                      ],
                    ),
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

class SpecsCard extends StatelessWidget {
  const SpecsCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        Gap(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            Text(
              subtitle,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
