import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../core/extensions.dart';
import '../../widgets/shared/back.dart';

import '../../widgets/shared/car_card.dart';

class FriendProfileScreen extends StatelessWidget {
  const FriendProfileScreen({super.key});

  static const String routeName = '/friend-profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 400,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.asset(
                      'assets/images/profile_bg.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 0.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.6),
                            Colors.black.withValues(alpha: 0.53),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Back(),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                            Colors.black,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundImage: const NetworkImage(
                              'https://picsum.photos/200',
                            ),
                          ),
                          Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Charlie Crozier',
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "@charlie",
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR STATISTICS',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(16),
                  Stack(
                    children: [
                      Positioned(
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          radius: 26,
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(269),
                            child: Icon(
                              Icons.electric_bolt,
                              size: 30,
                              color: Colors.white,
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
                              child: Container(),
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
                                            'YOUR XP',
                                            style: context.textTheme.headlineLarge?.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Spacer(),
                                          Text(
                                            '80 XP',
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
                                            value: 0.4,
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
                  ),
                  //
                  const Gap(16),
                  Row(
                    spacing: 16,
                    children: [
                      Expanded(
                        child: _Tile(
                          icon: Icons.directions_car_rounded,
                          title: 'LEGANDARIES',
                          value: '#14',
                        ),
                      ),
                      Expanded(
                        child: _Tile(
                          icon: Icons.directions_car_rounded,
                          title: 'LEGANDARIES',
                          value: '#14',
                        ),
                      ),
                      Expanded(
                        child: _Tile(
                          icon: Icons.directions_car_rounded,
                          title: 'LEGANDARIES',
                          value: '#14',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          Gap(8),
          Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
