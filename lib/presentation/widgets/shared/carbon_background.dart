import 'package:flutter/material.dart';

class CarbonBackground extends StatelessWidget {
  const CarbonBackground({
    super.key,
    required this.imgPath,
    required this.child,
    this.heightPercent, // Optional: if provided, only covers top X% of screen
    this.opacity = 0.3,
  });

  final String imgPath;
  final Widget child;
  final double? heightPercent; // e.g., 0.3 for 30% of screen
  final double opacity;

  @override
  Widget build(BuildContext context) {
    // Full screen background (original behavior)
    if (heightPercent == null) {
      return Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Image.asset(
              imgPath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Align(alignment: Alignment.topCenter, child: child),
        ],
      );
    }

    // Partial height background with fade
    final screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        // Carbon fiber top section
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: screenHeight * heightPercent!,
          child: Stack(
            children: [
              // Carbon fiber image
              Image.asset(
                imgPath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                opacity: AlwaysStoppedAnimation(opacity),
              ),
              // Gradient fade to black
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 150,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        child,
      ],
    );
  }
}
