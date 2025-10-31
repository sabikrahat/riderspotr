import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
          // Key Production Stats
          Row(
            children: [
              Expanded(
                child: ProductionCard(
                  icon: Icons.calendar_month_outlined,
                  title: 'YEARS PRODUCED',
                  subtitle:
                      '${production.yearStart} - ${production.yearEnd ?? DateTime.now().year}',
                ),
              ),
              Gap(16),
              Expanded(
                child: ProductionCard(
                  icon: Icons.numbers_rounded,
                  title: 'TOTAL MADE',
                  subtitle: production.totalMade == null
                      ? "Unknown"
                      : NumberFormat.decimalPattern().format(
                          production.totalMade,
                        ),
                ),
              ),
            ],
          ),
          Gap(16),
          Row(
            children: [
              Expanded(
                child: ProductionCard(
                  icon: Icons.attach_money_rounded,
                  title: 'ORIGINAL MSRP',
                  subtitle: production.msrp == null
                      ? "Unknown"
                      : NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 0,
                        ).format(production.msrp),
                ),
              ),
              Gap(16),
              Expanded(
                child: ProductionCard(
                  icon: Icons.local_shipping_outlined,
                  title: 'IN CIRCULATION',
                  subtitle: production.circulationCount == null
                      ? 'Unknown'
                      : NumberFormat.decimalPattern().format(
                          production.circulationCount,
                        ),
                ),
              ),
            ],
          ),
          Gap(32),

          // Description Section
          if (car.description != null) ...[
            Text(
              'ABOUT',
              style: context.textTheme.headlineSmall?.copyWith(
                fontSize: 13,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            Gap(16),
            Container(
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
              child: Text(
                car.description!,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Gap(32),
          ],
          // Value Comparison Section
          Text(
            'VALUE COMPARISON',
            style: context.textTheme.headlineSmall?.copyWith(
              fontSize: 13,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Gap(16),
          Container(
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
            child: Column(
              children: [
                // MSRP Bar
                _ValueBar(
                  label: 'ORIGINAL MSRP',
                  value: (production.msrp ?? 0).toDouble(),
                  maxValue: (production.maxValue ?? 0) > 0
                      ? (production.maxValue ?? 0).toDouble()
                      : (production.msrp ?? 1).toDouble(),
                  color: Colors.blue.withValues(alpha: 0.7),
                ),
                Gap(24),
                // Current Value Bar
                _ValueBar(
                  label: 'CURRENT VALUE',
                  value:
                      (((production.minValue ?? 0) +
                                  (production.maxValue ?? 0)) /
                              2)
                          .toDouble(),
                  maxValue: (production.maxValue ?? 0) > 0
                      ? (production.maxValue ?? 0).toDouble()
                      : (production.msrp ?? 1).toDouble(),
                  color: Colors.white.withValues(alpha: 0.9),
                  showRange: true,
                  minValue: (production.minValue ?? 0).toDouble(),
                  rangeMax: (production.maxValue ?? 0).toDouble(),
                ),
              ],
            ),
          ),
          Gap(32),

          // Production Details
          if (production.description != null &&
              production.description!.isNotEmpty) ...[
            Text(
              'PRODUCTION DETAILS',
              style: context.textTheme.headlineSmall?.copyWith(
                fontSize: 13,
                letterSpacing: 2.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
            Gap(16),
            Container(
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
              child: Text(
                production.description!,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.2,
                ),
              ),
            ),
            Gap(32),
          ],

          // Rarity Badge
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  car.rarity.color.withValues(alpha: 0.15),
                  car.rarity.color.withValues(alpha: 0.05),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: car.rarity.color.withValues(alpha: 0.2),
                  blurRadius: 15,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              car.rarity.name.toUpperCase(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: car.rarity.color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
                letterSpacing: 2,
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
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon at top
          Container(
            padding: EdgeInsets.all(12),
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
              icon,
              size: 20,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Gap(16),
          // Title
          Text(
            title,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Gap(8),
          // Value
          Text(
            subtitle,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w300,
              letterSpacing: 0.3,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

// Value Bar for comparison with Animation
class _ValueBar extends StatefulWidget {
  const _ValueBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    this.showRange = false,
    this.minValue,
    this.rangeMax,
  });

  final String label;
  final double value;
  final double maxValue;
  final Color color;
  final bool showRange;
  final double? minValue;
  final double? rangeMax;

  @override
  State<_ValueBar> createState() => _ValueBarState();
}

class _ValueBarState extends State<_ValueBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Create curved animation for smooth fill effect
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Calculate target percentage
    final targetPercentage = widget.maxValue > 0
        ? (widget.value / widget.maxValue).clamp(0.0, 1.0)
        : 0.0;

    // Tween from 0 to target percentage
    _progressAnimation = Tween<double>(
      begin: 0,
      end: targetPercentage,
    ).animate(curvedAnimation);
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.3) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('value-bar-${widget.label}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.label,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  Text(
                    widget.showRange &&
                            widget.minValue != null &&
                            widget.rangeMax != null
                        ? '${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(widget.minValue!)} - ${NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(widget.rangeMax!)}'
                        : NumberFormat.currency(
                            symbol: '\$',
                            decimalDigits: 0,
                          ).format(widget.value),
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: widget.color,
                    ),
                  ),
                ],
              ),
              Gap(12),
              Stack(
                children: [
                  // Background bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  // Animated progress bar
                  FractionallySizedBox(
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            widget.color,
                            widget.color.withValues(alpha: 0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
