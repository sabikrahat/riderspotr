// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
// import '../../../models/auth/user_model.dart';

// import '../../providers/auth/user_provider.dart';
// import '../auth/about_you_screen.dart';
// import '../auth/your_experience_screen.dart';
// import '../auth/your_location_screen.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     ref.watch(userProvider);
//     final notifier = ref.read(userProvider.notifier);
//     if (notifier.user == null) {
//       Future.microtask(() async => await notifier.refreshUser());
//       return Scaffold(body: Center(child: CircularProgressIndicator()));
//     }
//     if (!notifier.user!.isProfileComplete) return AboutYouScreen();
//     if (!notifier.user!.isExperienceComplete) return YourExperienceScreen();
//     if (!notifier.user!.isLocationComplete) return YourLocationScreen();
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Welcome to the Home Screen!'),
//             Gap(16),
//             ElevatedButton(
//               onPressed: () async => await notifier.signOut(context: context),
//               child: Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:ridespotr/core/extensions.dart';

import '../../providers/auth/user_provider.dart';
import '../../widgets/capture/scan_detail_container.dart';
import '../../widgets/shared/car_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    final size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/map-preview.png',
                width: size.width,
                height: size.height * 0.6,
                fit: BoxFit.fill,
              ),
              Positioned(
                top: 16,
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
                      onPressed: () async {
                        // TODO: Temporary --- IGNORE ---
                        await notifier.signOut(context: context);
                      },
                      child: Text('View Map'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarCard(),
          ),
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
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: charcol.withValues(alpha: 0.7),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Gap(70),
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
                                  backgroundColor: Colors.grey.withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 5,
                                  borderRadius: BorderRadius.circular(45),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            color: charcol.withValues(alpha: 0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(70),
                                  Text(
                                    'Cars Spotted',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '24',
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
                        Gap(8),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            color: charcol.withValues(alpha: 0.7),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(70),
                                  Text(
                                    'Legendaries',
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '3',
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
                  ],
                ),
              ],
            ),
          ),
          Gap(30),
        ],
      ),
    );
  }
}
