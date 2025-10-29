import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/shared/profile_xp_card.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/profile_provider.dart';
import '../../widgets/shared/car_card.dart';
import '../explore/explore_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: ref
          .watch(profileProvider(null))
          .when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text(error.toString())),
            data: (_) {
              final notifier = ref.read(profileProvider(null).notifier);
              return Column(
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        'assets/images/map-preview.png',
                        width: context.width,
                        height: context.height * 0.6,
                        fit: BoxFit.fill,
                      ),
                      Positioned(
                        top: MediaQuery.viewPaddingOf(context).top + 8,
                        left: 16,
                        child: SvgPicture.asset(
                          'assets/logo/logo-full.svg',
                          width: 220,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'READY TO HUNT?',
                              style: context.textTheme.headlineSmall,
                            ),
                            Gap(4),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Gap(4),
                            ElevatedButton(
                              onPressed: () async => await context.push(ExploreScreen.routeName),
                              child: Text('View Map'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // TODO: Implement
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CarCard(),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/home-bg.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          children: [
                            Gap(8),
                            ProfileXPCard(user: notifier.user),
                            Gap(16),
                            Row(
                              children: [
                                Expanded(
                                  child: _Tile(title: 'Cars Spotted', value: '24'),
                                ),
                                Gap(16),
                                Expanded(
                                  child: _Tile(title: 'Legendaries', value: '3'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Gap(200),
                ],
              );
            },
          ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

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
          height: 170,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(8),
                        Text(
                          value,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
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
