import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/car/car_spot_model.dart';

import '../../../core/extensions.dart';
import '../../providers/map/lat_lng.dart';

class CarCard extends StatelessWidget {
  final CarSpotModel carSpot;
  const CarCard({required this.carSpot, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Positioned(
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                radius: 26,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(269),
                  child: Image.network(
                    carSpot.car?.make?.logoUrl ?? '',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: context.height * 0.25,
              width: context.width,
              child: Stack(
                children: [
                  // Clipped background
                  ClipPath(
                    clipper: CircleClipper(
                      circleRadius: 30,
                      borderRadius: 24,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            carSpot.imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  // Border drawn on top
                  CustomPaint(
                    painter: CircleBorderPainter(
                      circleRadius: 30,
                      borderRadius: 24,
                      borderColor: Colors.grey.shade800,
                      borderWidth: 1,
                    ),
                    child: Container(),
                  ),

                  // Blakck gradient
                  ClipPath(
                    clipper: CircleClipper(
                      circleRadius: 30,
                      borderRadius: 24,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                            Colors.black,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Consumer(
                              builder: (_, ref, __) {
                                String address;
                                if (carSpot.latitude == null || carSpot.longitude == null) {
                                  address = carSpot.id;
                                } else {
                                  address =
                                      ref
                                          .watch(
                                            getLocationBasedOnLatLngPd(
                                              LatLng(carSpot.latitude!, carSpot.longitude!),
                                            ),
                                          )
                                          .value
                                          ?.formattedAddress ??
                                      carSpot.id;
                                }
                                return SizedBox(
                                  width: context.width - 100,
                                  child: Text(
                                    address,
                                    textAlign: TextAlign.right,
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Spacer(),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    carSpot.car?.make?.name ?? '',
                                    style: context.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    carSpot.car?.model ?? '',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final double circleRadius;
  final double borderRadius;

  CircleClipper({
    this.circleRadius = 0,
    this.borderRadius = 0,
  });

  @override
  Path getClip(Size size) {
    var path = Path();

    // Small transition radius for smooth connection
    final double transitionRadius = circleRadius / 1;

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
      // clockwise: false,
    );

    // Create the circular cutout at top-left
    // This creates a concave (inward) circle
    path.arcToPoint(
      Offset(circleRadius * 2, transitionRadius),
      radius: Radius.circular(circleRadius),
      clockwise: false, // Counter-clockwise for inward curve
    );

    // Smooth transition from circle cutout to top edge
    path.arcToPoint(
      Offset(circleRadius * 2 + transitionRadius, 0),
      radius: Radius.circular(transitionRadius),
      // clockwise: false,
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return oldClipper is! CircleClipper ||
        oldClipper.circleRadius != circleRadius ||
        oldClipper.borderRadius != borderRadius;
  }
}

class CircleBorderPainter extends CustomPainter {
  final double circleRadius;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

  CircleBorderPainter({
    required this.circleRadius,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final path = Path();

    // Small transition radius for smooth connection
    final double transitionRadius = circleRadius / 1;

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
      // clockwise: false,
    );

    // Create the circular cutout at top-left
    // This creates a concave (inward) circle
    path.arcToPoint(
      Offset(circleRadius * 2, transitionRadius),
      radius: Radius.circular(circleRadius),
      clockwise: false, // Counter-clockwise for inward curve
    );

    // Smooth transition from circle cutout to top edge
    path.arcToPoint(
      Offset(circleRadius * 2 + transitionRadius, 0),
      radius: Radius.circular(transitionRadius),
      // clockwise: false,
    );

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! CircleBorderPainter ||
        oldDelegate.circleRadius != circleRadius ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.borderWidth != borderWidth;
  }
}
