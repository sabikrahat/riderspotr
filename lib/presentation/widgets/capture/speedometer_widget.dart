import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

class SpeedometerWidget extends StatefulWidget {
  final double value;
  final double maxValue;
  final Duration duration;

  const SpeedometerWidget({
    super.key,
    required this.value,
    this.maxValue = 300,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<SpeedometerWidget> createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  double _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animateTo(widget.value);
  }

  void _animateTo(double target) {
    _animation = Tween<double>(begin: _previousValue, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _controller
      ..reset()
      ..forward();
  }

  @override
  void didUpdateWidget(covariant SpeedometerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value;
      _animateTo(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget specsContainer({
    double size = 90,
    IconData icon = Icons.electric_bolt,
    String label = '0-60 mph',
    double value = 2.8,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white54, width: 0.8),
        color: Colors.transparent,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          Text(
            value.toStringAsFixed(1),
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: context.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Foreground layout
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    specsContainer(),
                    Container(
                      margin: const EdgeInsets.only(bottom: 60),
                      child: specsContainer(),
                    ),
                    specsContainer(),
                  ],
                ),
              ),

              /// Speedometer
              SizedBox(
                height: 230,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          painter: _GlowPainter(
                            value: _animation.value,
                            maxValue: widget.maxValue,
                          ),
                          size: Size.infinite,
                        ),
                        CustomPaint(
                          painter: _SpeedometerPainter(
                            value: _animation.value,
                            maxValue: widget.maxValue,
                          ),
                          size: Size.infinite,
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 0.6),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _animation.value.toInt().toString(),
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'km/h',
                                  style: context.textTheme.bodyMedium
                                      ?.copyWith(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 0,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'TOP SPEED',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- Glow Painter (neon progress ring)
class _GlowPainter extends CustomPainter {
  final double value;
  final double maxValue;

  _GlowPainter({required this.value, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    const startAngle = 3 * pi / 4;
    const sweepAngle = 3 * pi / 2;
    final progressAngle = sweepAngle * (value / maxValue);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 15)
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + progressAngle,
        colors: [
          Colors.cyanAccent.withOpacity(0.3),
          Colors.cyanAccent.withOpacity(0.9),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      false,
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) =>
      oldDelegate.value != value;
}

/// --- Foreground Painter (ticks, ring, needle)
class _SpeedometerPainter extends CustomPainter {
  final double value;
  final double maxValue;

  _SpeedometerPainter({required this.value, required this.maxValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    const startAngle = 3 * pi / 4;
    const sweepAngle = 3 * pi / 2;
    final progressAngle = sweepAngle * (value / maxValue);

    // Background ring
    final bgPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      bgPaint,
    );

    // Progress ring
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + progressAngle,
        colors: [
          Colors.blueAccent,
          Colors.cyanAccent,
          Colors.lightBlueAccent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      progressAngle,
      false,
      progressPaint,
    );

    // Tick marks
    final tickPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2;
    for (int i = 0; i <= 30; i++) {
      final tickAngle = startAngle + (sweepAngle / 30) * i;
      final tickStart = Offset(
        center.dx + (radius - 14) * cos(tickAngle),
        center.dy + (radius - 14) * sin(tickAngle),
      );
      final tickEnd = Offset(
        center.dx + (radius - 5) * cos(tickAngle),
        center.dy + (radius - 5) * sin(tickAngle),
      );
      canvas.drawLine(tickStart, tickEnd, tickPaint);
    }

    // Needle
    final needleAngle = startAngle + progressAngle;
    final outerR = radius - 5;
    final innerR = radius * 0.42;
    const needleBaseWidth = 5.0;

    final baseLeft = Offset(
      center.dx +
          innerR * cos(needleAngle) -
          needleBaseWidth * sin(needleAngle),
      center.dy +
          innerR * sin(needleAngle) +
          needleBaseWidth * cos(needleAngle),
    );
    final baseRight = Offset(
      center.dx +
          innerR * cos(needleAngle) +
          needleBaseWidth * sin(needleAngle),
      center.dy +
          innerR * sin(needleAngle) -
          needleBaseWidth * cos(needleAngle),
    );
    final tip = Offset(
      center.dx + outerR * cos(needleAngle),
      center.dy + outerR * sin(needleAngle),
    );

    final needlePath = Path()
      ..moveTo(baseLeft.dx, baseLeft.dy)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(baseRight.dx, baseRight.dy)
      ..close();

    final needlePaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;
    canvas.drawPath(needlePath, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) =>
      oldDelegate.value != value;
}
