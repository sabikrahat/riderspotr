import 'package:flutter/material.dart';
import '../../../core/extensions.dart';

class CarCard extends StatelessWidget {
  const CarCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
        ),
        SizedBox(
          height: context.height * 0.25,
          width: context.width,
          child: CustomPaint(
            painter: CardShape(),
          ),
        ),
      ],
    );
  }
}

class CardShape extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerRadius = 24.0;
    const double cutoutWidth = 65.0;
    const double cutoutHeight = 65.0;
    const double cutoutRadius = 35.0;

    final path = Path();

    // Start from left edge, below the cutout area
    path.moveTo(0, cutoutHeight + cornerRadius);

    // Left edge down to bottom-left corner
    path.lineTo(0, size.height - cornerRadius);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, cornerRadius, size.height);

    // Bottom edge
    path.lineTo(size.width - cornerRadius, size.height);

    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - cornerRadius,
    );

    // Right edge up to top-right corner
    path.lineTo(size.width, cornerRadius);

    // Top-right corner
    path.quadraticBezierTo(size.width, 0, size.width - cornerRadius, 0);

    // Top edge from right to the cutout area
    path.lineTo(cutoutWidth + cutoutRadius, 0);

    // First inward curve (top-right of cutout)
    path.quadraticBezierTo(
      cutoutWidth,
      0,
      cutoutWidth,
      cutoutRadius,
    );

    // Right edge of cutout going down
    // path.lineTo(cutoutWidth, cutoutHeight - cutoutRadius);

    // Second inward curve (bottom-right of cutout)
    path.quadraticBezierTo(
      cutoutWidth,
      cutoutHeight,
      cutoutWidth - cutoutRadius,
      cutoutHeight,
    );

    // Bottom edge of cutout going left
    // path.lineTo(cutoutRadius, cutoutHeight);

    // Third inward curve (bottom-left of cutout)
    path.quadraticBezierTo(
      0,
      cutoutHeight,
      0,
      cutoutHeight + cornerRadius,
    );

    // Close the path (will connect back to start point)
    path.close();

    // Fill painter
    final bodyPainter = Paint()
      ..color = Colors
          .white //charcol
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, bodyPainter);

    // // Border painter
    final borderPainter = Paint()
      ..color = Colors
          .green //borderGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
