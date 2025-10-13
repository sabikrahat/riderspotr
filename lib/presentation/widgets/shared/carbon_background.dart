import 'package:flutter/material.dart';

class CarbonBackground extends StatelessWidget {
  const CarbonBackground({
    super.key,
    required this.imgPath,
    required this.child,
  });

  final String imgPath;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
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
}
