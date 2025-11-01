import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';

class GarageValueCard extends StatelessWidget {
  const GarageValueCard({
    super.key,
    required this.carSpots,
  });

  final List<CarSpotModel> carSpots;

  String _formatValue(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  double _getCarValue(CarSpotModel spot) {
    final production = spot.car?.production;
    if (production == null) return 0;

    // Prefer maxValue, then minValue, then msrp
    if (production.maxValue != null) {
      return production.maxValue!.toDouble();
    } else if (production.minValue != null) {
      return production.minValue!.toDouble();
    } else if (production.msrp != null) {
      return production.msrp!.toDouble();
    }
    return 0;
  }

  double _calculateTotalValue(List<CarSpotModel> spots) {
    double total = 0;
    for (final spot in spots) {
      total += _getCarValue(spot);
    }
    return total;
  }

  List<double> _calculate7DayGraph(List<CarSpotModel> spots) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final dayValues = List<double>.filled(7, 0);

    // Calculate cumulative value for each day
    for (int day = 0; day < 7; day++) {
      final dayEnd = sevenDaysAgo.add(Duration(days: day + 1));

      double dayTotal = 0;
      for (final spot in spots) {
        // Count cars added up to this day
        if (spot.createdAt.isBefore(dayEnd)) {
          dayTotal += _getCarValue(spot);
        }
      }
      dayValues[day] = dayTotal;
    }

    return dayValues;
  }

  double? _calculatePercentageChange(List<CarSpotModel> spots) {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Calculate value at the start of the 7-day period
    double valueAtStart = 0;
    // Calculate value at the end of the 7-day period (now)
    double valueAtEnd = 0;

    for (final spot in spots) {
      final carValue = _getCarValue(spot);

      // Value at end includes all cars
      valueAtEnd += carValue;

      // Value at start includes only cars added before the 7-day period
      if (spot.createdAt.isBefore(sevenDaysAgo)) {
        valueAtStart += carValue;
      }
    }

    // If no value at start, return 0% (or we could return null)
    if (valueAtStart == 0) {
      // If there are any cars in the last 7 days, show 100% growth
      if (valueAtEnd > 0) return 100.0;
      return null;
    }

    // Calculate percentage increase: (end - start) / start * 100
    return ((valueAtEnd - valueAtStart) / valueAtStart) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = _calculateTotalValue(carSpots);
    final formattedValue = _formatValue(totalValue);
    final numberOfCars = carSpots.length;
    final graphData = _calculate7DayGraph(carSpots);
    final maxGraphValue = graphData.isEmpty
        ? 1.0
        : (graphData.reduce((a, b) => a > b ? a : b) * 1.1).clamp(
            1.0,
            double.infinity,
          );
    final percentageChange = _calculatePercentageChange(carSpots);
    final hasValidGraph = graphData.isNotEmpty && maxGraphValue > 0;

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
                        formattedValue,
                        style: context.textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      if (percentageChange != null) ...[
                        Gap(8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${percentageChange >= 0 ? '+' : ''}${percentageChange.toStringAsFixed(0)}%',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              Text(
                '$numberOfCars ${numberOfCars == 1 ? 'Car' : 'Cars'}',
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
          if (hasValidGraph)
            _SimpleLineGraph(
              dataPoints: graphData,
              maxValue: maxGraphValue,
            ),
        ],
      ),
    );
  }
}

// Simple Line Graph Widget
class _SimpleLineGraph extends StatelessWidget {
  const _SimpleLineGraph({
    required this.dataPoints,
    required this.maxValue,
  });

  final List<double> dataPoints;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final graphHeight = 60.0;

    // Generate day labels (last 7 days)
    final dayLabels = List<String>.generate(7, (index) {
      final daysAgo = 6 - index;
      if (daysAgo == 0) return 'Now';
      if (daysAgo == 1) return '1D';
      return '${daysAgo}D';
    });

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
          children: dayLabels.map((label) {
            return Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: label == 'Now'
                    ? Colors.white.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.3),
                fontSize: 10,
                fontWeight: label == 'Now' ? FontWeight.w500 : FontWeight.w400,
              ),
            );
          }).toList(),
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
    if (dataPoints.isEmpty ||
        maxValue <= 0 ||
        maxValue.isNaN ||
        maxValue.isInfinite) {
      return;
    }

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

    final path = Path();
    final fillPath = Path();
    final spacing = dataPoints.length > 1
        ? size.width / (dataPoints.length - 1)
        : size.width;

    // Start paths
    final firstY = size.height - (dataPoints[0] / maxValue * size.height);
    if (!firstY.isNaN && !firstY.isInfinite) {
      path.moveTo(0, firstY.clamp(0.0, size.height));
      fillPath.moveTo(0, size.height);
      fillPath.lineTo(0, firstY.clamp(0.0, size.height));

      // Draw line and fill
      for (int i = 0; i < dataPoints.length; i++) {
        final x = i * spacing;
        final yValue = dataPoints[i] / maxValue;
        final y = size.height - (yValue * size.height);

        if (y.isNaN || y.isInfinite) continue;

        if (i == 0) continue;

        final clampedY = y.clamp(0.0, size.height);
        path.lineTo(x, clampedY);
        fillPath.lineTo(x, clampedY);
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
        final yValue = dataPoints[i] / maxValue;
        final y = size.height - (yValue * size.height);

        if (y.isNaN || y.isInfinite) continue;

        canvas.drawCircle(
          Offset(x, y.clamp(0.0, size.height)),
          3,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
