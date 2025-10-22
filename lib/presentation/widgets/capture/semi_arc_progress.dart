// import 'dart:math';
// import 'package:flutter/material.dart';

// /// Semi-circular arc progress bar with dual value indicators (MSRP & Current)
// class ArcProgressBar extends StatelessWidget {
//   const ArcProgressBar({
//     super.key,
//     required this.progress,
//     required this.msrp,
//     required this.current,
//     this.size = const Size(420, 220),
//     this.stroke = 4.0,
//     this.bgColor = const Color(0xFF2A2D35),
//     this.primary = const Color(0xFF3B82F6),
//     this.secondary = const Color(0xFF60A5FA),
//   });

//   final double progress; // Animated progress value (0.0 to 1.0)
//   final double msrp; // MSRP marker position (0.0 to 1.0)
//   final double current; // Current value marker position (0.0 to 1.0)
//   final Size size;
//   final double stroke;
//   final Color bgColor;
//   final Color primary;
//   final Color secondary;

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: size,
//       painter: _ArcProgressPainter(
//         progress: progress.clamp(0.0, 1.0),
//         msrp: msrp.clamp(0.0, 1.0),
//         current: current.clamp(0.0, 1.0),
//         stroke: stroke,
//         bgColor: bgColor,
//         primary: primary,
//         secondary: secondary,
//       ),
//     );
//   }
// }

// class _ArcProgressPainter extends CustomPainter {
//   _ArcProgressPainter({
//     required this.progress,
//     required this.msrp,
//     required this.current,
//     required this.stroke,
//     required this.bgColor,
//     required this.primary,
//     required this.secondary,
//   });

//   final double progress;
//   final double msrp;
//   final double current;
//   final double stroke;
//   final Color bgColor;
//   final Color primary;
//   final Color secondary;

//   // Arc starts at left (π) and sweeps π radians (180°)
//   static const double _startAngle = pi;
//   static const double _sweepAngle = pi;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height);
//     final radius = min(size.width / 2, size.height) * 0.9;
//     final rect = Rect.fromCircle(center: center, radius: radius);

//     // 1. Draw background arc (gray) - full semicircle
//     final bgPaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = stroke
//       ..strokeCap = StrokeCap.round
//       ..color = bgColor;
//     canvas.drawArc(rect, _startAngle, _sweepAngle, false, bgPaint);

//     // 2. Draw MSRP segment (darker blue) - from 0 to msrp
//     final animatedMsrp = msrp * progress;
//     if (animatedMsrp > 0) {
//       final msrpPaint = Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = stroke
//         ..strokeCap = StrokeCap.round
//         ..color = primary;

//       canvas.drawArc(
//         rect,
//         _startAngle,
//         _sweepAngle * animatedMsrp,
//         false,
//         msrpPaint,
//       );
//     }

//     // 3. Draw Current segment (lighter blue) - from msrp to current
//     final animatedCurrent = current * progress;
//     if (animatedCurrent > animatedMsrp) {
//       final currentPaint = Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = stroke
//         ..strokeCap = StrokeCap.round
//         ..color = secondary;

//       canvas.drawArc(
//         rect,
//         _startAngle + (_sweepAngle * animatedMsrp),
//         _sweepAngle * (animatedCurrent - animatedMsrp),
//         false,
//         currentPaint,
//       );
//     }

//     // 4. Draw MSRP marker (blue triangle)
//     if (msrp > 0 && progress > 0) {
//       _drawArrowMarker(
//         canvas,
//         center,
//         radius,
//         animatedMsrp,
//         primary,
//         'MSRP',
//       );
//     }

//     // 5. Draw Current marker (white triangle)
//     if (current > 0 && progress > 0) {
//       _drawArrowMarker(
//         canvas,
//         center,
//         radius,
//         animatedCurrent,
//         Colors.white,
//         'CURRENT',
//       );
//     }
//   }

//   void _drawArrowMarker(
//     Canvas canvas,
//     Offset center,
//     double radius,
//     double position,
//     Color color,
//     String label,
//   ) {
//     // Calculate angle for the marker
//     final angle = _startAngle + (_sweepAngle * position);

//     // Point on the arc
//     final arcPoint = Offset(
//       center.dx + radius * cos(angle),
//       center.dy + radius * sin(angle),
//     );

//     // Draw triangle arrow pointing OUTWARD from the arc
//     final trianglePath = Path();
//     final arrowSize = 8.0;
//     final arrowHeight = 14.0;

//     // Direction vector (pointing OUTWARD from center)
//     final radialDir = Offset(cos(angle), sin(angle));
//     final perpDir = Offset(-radialDir.dy, radialDir.dx);

//     // Triangle vertices - pointing outward
//     final tip = arcPoint + radialDir * arrowHeight; // Tip points away from arc
//     final base1 = arcPoint + perpDir * arrowSize;
//     final base2 = arcPoint - perpDir * arrowSize;

//     trianglePath.moveTo(tip.dx, tip.dy);
//     trianglePath.lineTo(base1.dx, base1.dy);
//     trianglePath.lineTo(base2.dx, base2.dy);
//     trianglePath.close();

//     final trianglePaint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     canvas.drawPath(trianglePath, trianglePaint);

//     // Draw label text outside the arrow
//     final textPainter = TextPainter(
//       text: TextSpan(
//         text: label,
//         style: TextStyle(
//           color: color,
//           fontSize: 11,
//           fontWeight: FontWeight.w600,
//           letterSpacing: 0.5,
//         ),
//       ),
//       textDirection: TextDirection.ltr,
//     );

//     textPainter.layout();

//     // Position label outside the triangle
//     final labelOffset = Offset(
//       tip.dx - textPainter.width / 2,
//       tip.dy + 5,
//     );

//     textPainter.paint(canvas, labelOffset);
//   }

//   @override
//   bool shouldRepaint(_ArcProgressPainter oldDelegate) {
//     return oldDelegate.progress != progress ||
//         oldDelegate.msrp != msrp ||
//         oldDelegate.current != current ||
//         oldDelegate.stroke != stroke ||
//         oldDelegate.bgColor != bgColor ||
//         oldDelegate.primary != primary ||
//         oldDelegate.secondary != secondary;
//   }
// }
