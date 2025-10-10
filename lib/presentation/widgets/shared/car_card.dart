import 'package:flutter/material.dart';

import '../../../core/extensions.dart';

class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    this.imgPath = 'assets/images/lamborghini-hurcan.png',
    this.address = 'MELBOURNE, VIC, AUSTRALIA',
    this.brand = 'LAMBORGHINI',
    this.model = 'HURACAN',
    this.badgePath = 'assets/images/lamborghini.png',
  });

  final String imgPath;
  final String address;
  final String brand;
  final String model;
  final String badgePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imgPath,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Text(
                address,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand,
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 8,
              top: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(45),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  badgePath,
                  height: 60,
                  width: 60,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
