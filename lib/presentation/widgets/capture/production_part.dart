import 'dart:math';

import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../core/enums.dart';
import '../../../core/extensions.dart';
import '../../../models/car/car_model.dart';

class ProductionPart extends StatelessWidget {
  const ProductionPart({super.key, required this.car});

  final CarModel car;

  @override
  Widget build(BuildContext context) {
    final production = car.production;
    if (production == null) {
      return Center(
        child: Text(
          'No production data available.',
          style: context.textTheme.bodyMedium,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // height: 360,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    spacing: 16,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductionCard(
                        icon: Icons.calendar_month,
                        title: 'YEARS PRODUCED',
                        subtitle:
                            '${production.yearStart} - ${production.yearEnd ?? DateTime.now().year}',
                      ),
                      ProductionCard(
                        icon: Icons.attach_money_rounded,
                        title: 'ORIGINAL MSRP',
                        subtitle: NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 0,
                        ).format(production.msrp),
                      ),
                      ProductionCard(
                        icon: Icons.numbers_rounded,
                        title: 'TOTAL MADE',
                        subtitle: NumberFormat.decimalPattern().format(
                          production.totalMade,
                        ),
                      ),
                      if (car.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'DESCRIPTION',
                            style: context.textTheme.headlineSmall,
                          ),
                        ),
                    ],
                  ),
                ),
                Gap(16),
                Expanded(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/production.png',
                    height: 360,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
          Gap(8),
          if (car.description != null) ...[
            Text(
              car.description!,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w200,
              ),
            ),
            Gap(16),
          ],
          Stack(
            children: [
              ArcProgressBar(
                percentage: min(production.minValue! / 1000000 * 100, 100),
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                arcThickness: 2,
                handleSize: 12,
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
                      'EST. VALUE',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Gap(12),
                    Text(
                      '${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(production.minValue)} - ${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(production.maxValue)}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ArcProgressBar(
                percentage: min((production.msrp ?? 0) / 1000000 * 100, 100),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.blue,
                arcThickness: 2,
                handleSize: 12,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.blue,
              ),
              const Gap(8),
              Text('MSRP'),
              const Gap(24),
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.white,
              ),
              const Gap(8),
              Text('Current'),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: ProductionCard(
                  title: 'TOTAL PRODUCED',
                  subtitle: NumberFormat.decimalPattern().format(
                    production.totalMade ?? 0,
                  ),
                  icon: Icons.create,
                ),
              ),
              Gap(16),
              Expanded(
                child: ProductionCard(
                  title: 'EST. IN CIRCULATION',
                  subtitle: NumberFormat.decimalPattern().format(
                    production.circulationCount ?? 0,
                  ),
                  icon: Icons.recycling,
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
                width: 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              Gap(16),
              Expanded(
                child: Text(
                  production.description!,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w200,
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
              border: Border.all(color: car.rarity.color),
              boxShadow: [
                BoxShadow(
                  color: car.rarity.color.withValues(alpha: 0.25),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              car.rarity.name.toUpperCase(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: car.rarity.color,
                fontWeight: FontWeight.w500,
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
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
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
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          Gap(4),
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
          Gap(4),
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom triangle painter for arc indicators
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Triangle pointing down
    path.moveTo(size.width / 2, size.height); // Bottom center (point)
    path.lineTo(0, 0); // Top left
    path.lineTo(size.width, 0); // Top right
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
