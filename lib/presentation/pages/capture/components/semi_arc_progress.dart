import 'dart:math';

import 'package:flutter/material.dart';

/// Semi-circular progress bar with two arrow markers (MSRP=blue, Current=white)
class ArcProgressBar extends StatelessWidget {
  const ArcProgressBar({
    super.key,
    required this.progress, // 0..1
    required this.msrp, // 0..1
    required this.current, // 0..1
    this.size = const Size(420, 220),
    this.stroke = 10,
    this.bgColor = const Color(0xFF5A5E66),
    this.primary = const Color(0xFF3B82F6),
    this.secondary = const Color(0xFF93C5FD),
    this.tickColor = const Color(0xFF8C8F96),
  });

  final double progress;
  final double msrp;
  final double current;

  final Size size;
  final double stroke;
  final Color bgColor;
  final Color primary;
  final Color secondary;
  final Color tickColor;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: size,
      painter: _ArcPainter(
        progress: progress.clamp(0, 1),
        msrp: msrp.clamp(0, 1),
        current: current.clamp(0, 1),
        stroke: stroke,
        bgColor: bgColor,
        primary: primary,
        secondary: secondary,
        tickColor: tickColor,
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter({
    required this.progress,
    required this.msrp,
    required this.current,
    required this.stroke,
    required this.bgColor,
    required this.primary,
    required this.secondary,
    required this.tickColor,
  });

  final double progress;
  final double msrp;
  final double current;
  final double stroke;
  final Color bgColor;
  final Color primary;
  final Color secondary;
  final Color tickColor;

  // Half circle: start on the left (π) and sweep 180°
  static const double _start = pi;
  static const double _sweep = pi;

  @override
  void paint(Canvas canvas, Size size) {
    // Put the circle's center at bottom middle so we draw a semi-arc above it
    final center = Offset(size.width / 2, size.height);
    final radius = min(size.width, size.height * 2) * 0.45;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // 1) Full base arc (grey background)
    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke
      ..color = bgColor;
    canvas.drawArc(rect, _start, _sweep, false, base);

    // 2) Primary progress (from start to msrp)
    if (msrp > 0) {
      final primaryPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..color = primary;
      canvas.drawArc(rect, _start, _sweep * msrp, false, primaryPaint);
    }

    // 3) Secondary progress (from msrp to current)
    if (current > msrp) {
      final secondaryPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke
        ..color = secondary;
      canvas.drawArc(
        rect,
        _start + _sweep * msrp,
        _sweep * (current - msrp),
        false,
        secondaryPaint,
      );
    }

    // 4) 100% end tick (small inward line at end of arc)
    _drawEndTick(canvas, center, radius);

    // 5) Markers
    _drawTriangleMarker(canvas, rect, t: msrp, color: primary); // MSRP
    _drawTriangleMarker(canvas, rect, t: current, color: Colors.white); // CURRENT
  }

  void _drawEndTick(Canvas canvas, Offset c, double r) {
    final a = _start + _sweep; // 100% end angle
    final p = Offset(c.dx + r * cos(a), c.dy + r * sin(a));
    final outward = Offset(cos(a), sin(a)); // away from center
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p + outward * 8, p + outward * 22, tickPaint);
  }

  void _drawTriangleMarker(Canvas canvas, Rect rect, {required double t, required Color color}) {
    final center = rect.center;
    final radius = rect.width / 2;
    final a = _start + _sweep * t;

    final tip = Offset(center.dx + radius * cos(a), center.dy + radius * sin(a));
    final toCenter = (center - tip);
    final len = toCenter.distance == 0.0 ? 1.0 : toCenter.distance;
    final dir = toCenter / len.toDouble(); // inward (radial) unit vector
    final normal = Offset(-dir.dy, dir.dx); // perpendicular for base width

    const baseLen = 16.0;
    const halfWidth = 7.0;

    final baseCenter = tip + dir * baseLen;
    final p1 = tip;
    final p2 = baseCenter + normal * halfWidth;
    final p3 = baseCenter - normal * halfWidth;

    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..lineTo(p2.dx, p2.dy)
      ..lineTo(p3.dx, p3.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter o) =>
      o.progress != progress ||
      o.msrp != msrp ||
      o.current != current ||
      o.stroke != stroke ||
      o.bgColor != bgColor ||
      o.primary != primary ||
      o.secondary != secondary ||
      o.tickColor != tickColor;
}
