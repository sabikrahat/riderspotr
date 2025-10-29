import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/auth/user_model.dart';
import 'car_card.dart';

class ProfileXPCard extends StatelessWidget {
  const ProfileXPCard({
    super.key,
    required this.user,
  });

  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            radius: 26,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(
                269,
              ),
              child: Icon(
                Icons.electric_bolt,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 160,
          width: context.width,
          child: Stack(
            children: [
              // Clipped background
              ClipPath(
                clipper: CarCardClipper(
                  circleRadius: 30,
                  borderRadius: 24,
                ),
                child: Container(),
              ),

              // Border drawn on top
              CustomPaint(
                painter: CarCardOverlayPainter(
                  circleRadius: 30,
                  borderRadius: 24,
                  borderColor: Colors.grey.shade800,
                  borderWidth: 1,
                ),
                child: Container(),
              ),

              // Black gradient
              ClipPath(
                clipper: CarCardClipper(
                  circleRadius: 30,
                  borderRadius: 24,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade900),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'LVL ${user?.stats?.level ?? 0}',
                              style: context.textTheme.headlineLarge?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '${user?.stats?.totalXp.toInt() ?? 0} XP',
                              style: context.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Gap(12),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.9),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: LinearProgressIndicator(
                              value: (user?.stats?.xpToNextLevelProgress ?? 0.0) / 100,
                              backgroundColor: Colors.grey.withValues(
                                alpha: 0.3,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(45),
                            ),
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
    );
  }
}
