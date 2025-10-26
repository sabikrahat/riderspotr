import 'dart:ui' as ui;

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/capture/car_detail_screen.dart';

import '../../../core/extensions.dart';
import '../../../models/car/car_spot_model.dart';

class CarCard extends StatelessWidget {
  final CarSpotModel carSpot;
  const CarCard({required this.carSpot, super.key});

  // final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          CarDetailScreen.routeName,
          extra: carSpot,
        );
      },
      child: Stack(
        children: [
          // Logo avatar
          Positioned(
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              // Set to 26 intentially
              radius: 26,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: FastCachedImage(
                  url: carSpot.car?.make?.logoUrl ?? '',
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  errorBuilder: (context, exception, stacktrace) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: Icon(
                        Icons.directions_car,
                        color: Colors.white54,
                        size: 20,
                      ),
                    );
                  },
                  loadingBuilder: (context, progress) {
                    return Container(
                      color: Colors.grey.shade800,
                      child: Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white54,
                            value: progress.progressPercentage.value,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Main card with background, gradient, and border
          SizedBox(
            height: context.height * 0.25,
            width: context.width,
            child: Stack(
              children: [
                // Background image (clipped)
                ClipPath(
                  clipper: CarCardClipper(
                    circleRadius: 30,
                    borderRadius: 24,
                  ),
                  child: FastCachedImage(
                    url: carSpot.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    fadeInDuration: const Duration(milliseconds: 500),
                    errorBuilder: (context, exception, stacktrace) {
                      return Container(
                        color: Colors.grey.shade900,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.white24,
                            size: 48,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, progress) {
                      return Container(
                        color: Colors.grey.shade900,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white24,
                                  value: progress.progressPercentage.value,
                                ),
                              ),
                              if (progress.isDownloading &&
                                  progress.totalBytes != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${(progress.downloadedBytes / 1024).toStringAsFixed(0)}/${(progress.totalBytes! / 1024).toStringAsFixed(0)} KB',
                                    style: TextStyle(
                                      color: Colors.white24,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient overlay and border in single CustomPaint
                CustomPaint(
                  painter: CarCardOverlayPainter(
                    circleRadius: 30,
                    borderRadius: 24,
                    borderColor: Colors.grey[850]!,
                    borderWidth: 1,
                  ),
                  child: Container(),
                ),
                // Content overlay
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: context.width - 120,
                        child: Text(
                          carSpot.address,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (carSpot.car?.make?.name ?? '').toUpperCase(),
                              style: context.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              (carSpot.car?.model ?? '').toUpperCase(),
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

// Shared path creation for clipper and painter
Path _createCardPath(Size size, double circleRadius, double borderRadius) {
  final path = Path();
  final double transitionRadius = circleRadius;

  // Start after the circle cutout and transition on the top edge
  path.moveTo(circleRadius * 2 + transitionRadius, 0);

  // Top edge to top-right corner
  path.lineTo(size.width - borderRadius, 0);

  // Top-right rounded corner
  path.arcToPoint(
    Offset(size.width, borderRadius),
    radius: Radius.circular(borderRadius),
    clockwise: true,
  );

  // Right edge
  path.lineTo(size.width, size.height - borderRadius);

  // Bottom-right rounded corner
  path.arcToPoint(
    Offset(size.width - borderRadius, size.height),
    radius: Radius.circular(borderRadius),
    clockwise: true,
  );

  // Bottom edge
  path.lineTo(borderRadius, size.height);

  // Bottom-left rounded corner
  path.arcToPoint(
    Offset(0, size.height - borderRadius),
    radius: Radius.circular(borderRadius),
    clockwise: true,
  );

  // Left edge up to just before the circle cutout
  path.lineTo(0, circleRadius * 2 + transitionRadius);

  // Smooth transition from left edge into the circle cutout
  path.arcToPoint(
    Offset(transitionRadius, circleRadius * 2),
    radius: Radius.circular(transitionRadius),
  );

  // Create the circular cutout at top-left
  path.arcToPoint(
    Offset(circleRadius * 2, transitionRadius),
    radius: Radius.circular(circleRadius),
    clockwise: false, // Counter-clockwise for inward curve
  );

  // Smooth transition from circle cutout to top edge
  path.arcToPoint(
    Offset(circleRadius * 2 + transitionRadius, 0),
    radius: Radius.circular(transitionRadius),
  );

  path.close();
  return path;
}

// Clipper for the background image
class CarCardClipper extends CustomClipper<Path> {
  final double circleRadius;
  final double borderRadius;

  CarCardClipper({
    required this.circleRadius,
    required this.borderRadius,
  });

  @override
  Path getClip(Size size) {
    return _createCardPath(size, circleRadius, borderRadius);
  }

  @override
  bool shouldReclip(covariant CarCardClipper oldClipper) {
    return oldClipper.circleRadius != circleRadius ||
        oldClipper.borderRadius != borderRadius;
  }
}

// Painter for gradient overlay and border (combined in one)
class CarCardOverlayPainter extends CustomPainter {
  final double circleRadius;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  CarCardOverlayPainter({
    required this.circleRadius,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = _createCardPath(size, circleRadius, borderRadius);

    // 1. Draw gradient overlay (clipped to path)
    canvas.save();
    canvas.clipPath(path);

    final gradientPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width / 2, size.height),
        Offset(size.width / 2, 0),
        [
          Colors.black,
          Colors.transparent,
          Colors.black,
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );

    canvas.restore();

    // 2. Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CarCardOverlayPainter oldDelegate) {
    return oldDelegate.circleRadius != circleRadius ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
