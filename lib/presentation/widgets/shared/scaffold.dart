import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums.dart';
import '../../../models/auth/user_model.dart';
import '../../pages/auth/about_you_screen.dart';
import '../../pages/auth/your_experience_screen.dart';
import '../../pages/auth/your_location_screen.dart';
import '../../pages/camera/camera_screen.dart';
import '../../providers/auth/user_provider.dart';

class KScaffold extends ConsumerWidget {
  const KScaffold({super.key, required this.path, required this.body});

  final String? path;
  final Widget body;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    if (notifier.user == null) {
      Future.microtask(() async => await notifier.refreshUser());
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selectedDrawer = KNavItem.values.firstWhere(
      (e) => e.route == path,
      orElse: () => KNavItem.home,
    );
    return ref
        .watch(userProvider)
        .when(
          loading: () => const CircularProgressIndicator(),
          error: (Object e, _) => Center(child: Text('Error: $e')),
          data: (_) {
            final notifier = ref.read(userProvider.notifier);
            if (!notifier.user!.isProfileComplete) return AboutYouScreen();
            if (!notifier.user!.isExperienceComplete) return YourExperienceScreen();
            if (!notifier.user!.isLocationComplete) return YourLocationScreen();
            return SafeArea(
              child: Scaffold(
                body: body,
                bottomNavigationBar: KBottomNavbar(selectedNavItem: selectedDrawer),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.grey.shade900,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.camera, size: 40, color: Colors.white),
                  onPressed: () => context.pushNamed(CameraScreen.name),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              ),
            );
          },
        );
  }
}

class KBottomNavbar extends StatelessWidget {
  const KBottomNavbar({super.key, required this.selectedNavItem});

  final KNavItem selectedNavItem;

  @override
  Widget build(BuildContext context) {
    final idx = KNavItem.values.indexWhere((e) => e == selectedNavItem);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(45)),
      child: AnimatedBottomNavigationBar(
        icons: KNavItem.values.map((e) => e.icon).toList(),
        activeIndex: idx,
        backgroundColor: Colors.grey.shade900,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        activeColor: Colors.white,
        inactiveColor: Colors.white38,
        height: 55,
        notchMargin: 8,
        safeAreaValues: const SafeAreaValues(bottom: false),
        onTap: (i) async {
          if (idx == i) return;
          context.goNamed(KNavItem.values[i].route);
        },
      ),
    );
    //   return ClipRRect(
    //     borderRadius: BorderRadius.all(Radius.circular(45)),
    //     child: BottomNavigationBar(
    //       currentIndex: idx,
    //       items: List.generate(
    //         KNavItem.values.length,
    //         (i) => kBottomNavBarItem(context, KNavItem.values[i]),
    //       ),
    //       onTap: (i) async {
    //         if (idx == i) return;
    //         context.goNamed(KNavItem.values[i].route);
    //       },
    //     ),
    //   );
  }

  // BottomNavigationBarItem kBottomNavBarItem(BuildContext context, KNavItem data) {
  //   return BottomNavigationBarItem(
  //     label: data.title,
  //     activeIcon: Icon(data.icon),
  //     icon: Icon(data.icon),
  //   );
  // }
}
