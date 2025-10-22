import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

final charcol = Color(0xFF2D2D2D).withValues(alpha: 0.8);
final borderGrey = Color(0xFF3A3A3A);

class ScanDetailContainer extends StatelessWidget {
  final String title;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Widget child;
  const ScanDetailContainer({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          // height: context.height * 0.2,
          // 32 because page padding is 16 on both sides
          width: context.width - 32,
          child: CustomPaint(
            painter: ScanDetailBox(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  SizedBox(
                    // color: Colors.white,
                    // The height needs to match the cutout height
                    // of the button
                    height: 50 - 16,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: context.textTheme.headlineSmall,
                      ),
                    ),
                  ),

                  // Content
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              onButtonPressed();
            },
            child: Container(
              width: 140,
              height: 40,
              decoration: BoxDecoration(
                color: charcol,
                border: Border.all(color: borderGrey),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.keyboard_double_arrow_up_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  Text(
                    buttonText,
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScanDetailBox extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double cornerRadius = 24.0;
    const double cutoutWidth = 150.0;
    const double cutoutHeight = 50.0;
    const double cutoutRadius = 24.0;

    final path = Path();

    // Start from top-left corner (after the radius)
    path.moveTo(0, cornerRadius);

    // Top-left corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Top edge until we reach the cutout area
    path.lineTo(size.width - cutoutWidth - cutoutRadius, 0);

    // First inward curve (top-left of cutout)
    path.quadraticBezierTo(
      size.width - cutoutWidth,
      0,
      size.width - cutoutWidth,
      cutoutRadius,
    );

    // Left edge of cutout
    path.lineTo(size.width - cutoutWidth, cutoutHeight - cutoutRadius);

    // Second inward curve (bottom-left of cutout)
    path.quadraticBezierTo(
      size.width - cutoutWidth,
      cutoutHeight,
      size.width - cutoutWidth + cutoutRadius,
      cutoutHeight,
    );

    // Bottom edge of cutout to top-right corner
    path.lineTo(size.width - cornerRadius, cutoutHeight);

    // Top-right corner
    path.quadraticBezierTo(
      size.width,
      cutoutHeight,
      size.width,
      cutoutHeight + cornerRadius,
    );

    // Right edge
    path.lineTo(size.width, size.height - cornerRadius);

    // Bottom-right corner
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );

    // Bottom edge
    path.lineTo(cornerRadius, size.height);

    // Bottom-left corner
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);

    // Close the path
    path.close();

    // Fill painter
    final bodyPainter = Paint()
      ..color = charcol
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, bodyPainter);

    // Border painter
    final borderPainter = Paint()
      ..color = borderGrey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, borderPainter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
