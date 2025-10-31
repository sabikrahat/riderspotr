import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_specs_model.dart';

class SpecsPart extends StatelessWidget {
  const SpecsPart({super.key, required this.specs});

  final CarSpecsModel? specs;

  @override
  Widget build(BuildContext context) {
    if (specs == null) {
      return Center(
        child: Text(
          'No specs data available.',
          style: context.textTheme.bodyMedium,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(24),

          // Key Stats Above Gauge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CompactStat(
                label: '0-100 KM/H',
                value: specs!.acceleration0100 != null
                    ? '${specs!.acceleration0100!.toStringAsFixed(1)}s'
                    : 'N/A',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _CompactStat(
                label: 'WEIGHT',
                value: specs!.weightKg != null
                    ? '${specs!.weightKg} kg'
                    : 'N/A',
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.1),
              ),
              _CompactStat(
                label: 'QUARTER MILE',
                value: specs!.quarterMiles != null
                    ? '${specs!.quarterMiles!.toStringAsFixed(1)}s'
                    : 'N/A',
              ),
            ],
          ),
          Gap(32),

          // Full Width Speed Gauge
          _SpeedGauge(
            topSpeed: specs!.topSpeedKmh?.toDouble() ?? 0,
          ),
          Gap(16),

          // Dashboard Style Engine Specs
          Text(
            'ENGINE SPECIFICATIONS',
            style: context.textTheme.headlineSmall?.copyWith(
              fontSize: 13,
              letterSpacing: 2.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          Gap(24),

          // Dashboard Layout
          _DashboardSpec(
            icon: Icons.settings_outlined,
            label: 'CONFIGURATION',
            value: specs!.configuration ?? 'N/A',
          ),
          Gap(16),
          _DashboardSpec(
            icon: Icons.compress,
            label: 'DISPLACEMENT',
            value: specs!.displacementl != null
                ? '${specs!.displacementl}L'
                : 'N/A',
          ),
          Gap(16),
          _DashboardSpec(
            icon: Icons.bolt_outlined,
            label: 'POWER',
            value: specs!.powerKw != null ? '${specs!.powerKw} kW' : 'N/A',
          ),
          Gap(16),
          _DashboardSpec(
            icon: Icons.rotate_right,
            label: 'TORQUE',
            value: specs!.torqueNm != null ? '${specs!.torqueNm} Nm' : 'N/A',
          ),
          Gap(100),
        ],
      ),
    );
  }
}

// Compact Stat Widget (above gauge)
class _CompactStat extends StatelessWidget {
  const _CompactStat({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
            color: Colors.white.withValues(alpha: 0.4),
          ),
        ),
        Gap(6),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.3,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }
}

// Dashboard Style Spec Row
class _DashboardSpec extends StatelessWidget {
  const _DashboardSpec({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.06),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
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
              size: 18,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                Gap(4),
                Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Full Width Speed Gauge with Animation
class _SpeedGauge extends StatefulWidget {
  const _SpeedGauge({
    required this.topSpeed,
  });

  final double topSpeed;

  @override
  State<_SpeedGauge> createState() => _SpeedGaugeState();
}

class _SpeedGaugeState extends State<_SpeedGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _speedAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    // Create animation controller (2 seconds duration)
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create curved animation for smooth acceleration effect
    final curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic, // Smooth deceleration like a car
    );

    // Tween from 0 to target speed
    _speedAnimation = Tween<double>(
      begin: 0,
      end: widget.topSpeed,
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
      key: Key('speed-gauge-${widget.topSpeed}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _speedAnimation,
        builder: (context, child) {
          return SizedBox(
            width: double.infinity,
            height: 280,
            child: CustomPaint(
              painter: _SpeedGaugePainter(
                speed: _speedAnimation.value,
                maxSpeed: 400,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _speedAnimation.value.toInt().toString(),
                      style: context.textTheme.headlineLarge?.copyWith(
                        fontSize: 72,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -3,
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                    ),
                    Text(
                      'KM/H',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 4,
                        color: Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                    Gap(6),
                    Text(
                      'TOP SPEED',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2.5,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom Painter for Speed Gauge
class _SpeedGaugePainter extends CustomPainter {
  final double speed;
  final double maxSpeed;

  _SpeedGaugePainter({
    required this.speed,
    required this.maxSpeed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    final strokeWidth = 4.0;

    // Calculate progress (0 to 1)
    final progress = (speed / maxSpeed).clamp(0.0, 1.0);
    final sweepAngle = progress * math.pi * 1.5; // 270 degrees max
    final startAngle =
        math.pi * -1.25; // Start from bottom left (225 degrees = 5*pi/4)

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      math.pi * 1.5,
      false,
      backgroundPaint,
    );

    // Progress arc with gradient
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: math.pi * 2,
        colors: [
          Colors.white.withValues(alpha: 0.9),
          Colors.white.withValues(alpha: 0.7),
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.9),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw tick marks
    for (int i = 0; i <= 15; i++) {
      final angle = startAngle + (math.pi * 1.5 / 15) * i;
      final isMajor = i % 3 == 0;

      final tickPaint = Paint()
        ..color = Colors.white.withValues(alpha: isMajor ? 0.3 : 0.15)
        ..strokeWidth = isMajor ? 2.5 : 1.5
        ..strokeCap = StrokeCap.round;

      final outerRadius = radius - 8;
      final innerRadius = outerRadius - (isMajor ? 16 : 10);

      final startPoint = Offset(
        center.dx + outerRadius * math.cos(angle),
        center.dy + outerRadius * math.sin(angle),
      );
      final endPoint = Offset(
        center.dx + innerRadius * math.cos(angle),
        center.dy + innerRadius * math.sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, tickPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
