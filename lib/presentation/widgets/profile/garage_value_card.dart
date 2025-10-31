import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';

class GarageValueCard extends StatelessWidget {
  const GarageValueCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Garage Value',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Gap(4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$2.5M',
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Gap(8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '+12%',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '28 Cars',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Gap(20),

          // Simple Line Graph
          _SimpleLineGraph(),
        ],
      ),
    );
  }
}

// Simple Line Graph Widget
class _SimpleLineGraph extends StatelessWidget {
  const _SimpleLineGraph();

  @override
  Widget build(BuildContext context) {
    // Mock data points (6 months)
    final dataPoints = [1.8, 2.0, 1.9, 2.2, 2.3, 2.5];
    final maxValue = 3.0;
    final graphHeight = 60.0;

    return Column(
      children: [
        SizedBox(
          height: graphHeight,
          child: CustomPaint(
            painter: _LineGraphPainter(dataPoints, maxValue),
            child: Container(),
          ),
        ),
        Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '6M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '5M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '4M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '3M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '2M',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Now',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Line Graph Painter
class _LineGraphPainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxValue;

  _LineGraphPainter(this.dataPoints, this.maxValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    if (dataPoints.isEmpty) return;

    final path = Path();
    final fillPath = Path();
    final spacing = size.width / (dataPoints.length - 1);

    // Start paths
    final firstY = size.height - (dataPoints[0] / maxValue * size.height);
    path.moveTo(0, firstY);
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, firstY);

    // Draw line and fill
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = size.height - (dataPoints[i] / maxValue * size.height);

      if (i == 0) continue;

      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }

    // Close fill path
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Draw fill then line
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots on line
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = size.height - (dataPoints[i] / maxValue * size.height);

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

