import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/fcm_wrapper.dart';

import '../../core/enums.dart';
import 'capture/camera_screen.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key, required this.path, required this.body});

  final String? path;
  final Widget body;

  KNavItem _getSelectedNavItem(String? path) {
    if (path == null) return KNavItem.home;

    switch (path.toLowerCase()) {
      case 'home':
        return KNavItem.home;
      case 'garage':
        return KNavItem.garage;
      case 'leaderboard':
        return KNavItem.leaderboard;
      case 'profile':
        return KNavItem.profile;
      default:
        return KNavItem.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: FcmWrapper(child: body),
      bottomNavigationBar: KBottomNavbar(
        selectedNavItem: _getSelectedNavItem(path),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade900,
        shape: const CircleBorder(),
        child: const Icon(Icons.camera, size: 40, color: Colors.white),
        onPressed: () => context.push(CameraScreen.routeName),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
          context.go(KNavItem.values[i].route);
        },
      ),
    );
  }
}
