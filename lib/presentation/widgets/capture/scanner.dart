import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> with SingleTickerProviderStateMixin {
  late AnimationController _scannerController;
  late Animation<double> _scannerAnimation;

  @override
  void initState() {
    super.initState();
    _scannerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final centerY = context.height / 2;
    final crosshairSize = 60.0;

    _scannerAnimation =
        Tween<double>(
            begin: centerY - crosshairSize,
            end: centerY + crosshairSize,
          ).animate(_scannerController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _scannerController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _scannerController.forward();
            }
          });
    _scannerController.forward();
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Crosshairs
        CustomPaint(
          size: Size.infinite,
          painter: CrosshairsPainter(),
        ),
        // Scanning bar
        Positioned(
          left: context.width / 2 - 60,
          top: _scannerAnimation.value,
          child: Container(
            height: 2,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 15,
                  spreadRadius: 3,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CrosshairsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final crosshairSize = 60.0;
    final lineLength = 20.0;
    final strokeWidth = 2.5;

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Top-left corner
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY - crosshairSize),
      Offset(centerX - crosshairSize + lineLength, centerY - crosshairSize),
      paint,
    );
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY - crosshairSize),
      Offset(centerX - crosshairSize, centerY - crosshairSize + lineLength),
      paint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(centerX + crosshairSize, centerY - crosshairSize),
      Offset(centerX + crosshairSize - lineLength, centerY - crosshairSize),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + crosshairSize, centerY - crosshairSize),
      Offset(centerX + crosshairSize, centerY - crosshairSize + lineLength),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY + crosshairSize),
      Offset(centerX - crosshairSize + lineLength, centerY + crosshairSize),
      paint,
    );
    canvas.drawLine(
      Offset(centerX - crosshairSize, centerY + crosshairSize),
      Offset(centerX - crosshairSize, centerY + crosshairSize - lineLength),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(centerX + crosshairSize, centerY + crosshairSize),
      Offset(centerX + crosshairSize - lineLength, centerY + crosshairSize),
      paint,
    );
    canvas.drawLine(
      Offset(centerX + crosshairSize, centerY + crosshairSize),
      Offset(centerX + crosshairSize, centerY + crosshairSize - lineLength),
      paint,
    );

    // Center dot
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
