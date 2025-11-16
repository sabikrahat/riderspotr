import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/fcm_wrapper.dart';

import '../../core/enums.dart';

class NavScreen extends StatelessWidget {
  const NavScreen({super.key, required this.path, required this.body});

  final String? path;
  final Widget body;

  KNavItem _getSelectedNavItem(String? path) {
    if (path == null) return KNavItem.home;

    switch (path.toLowerCase()) {
      case 'home':
        return KNavItem.home;
      case 'search-friend':
        return KNavItem.search;
      case 'explore':
        return KNavItem.map;
      case 'camera':
        return KNavItem.camera;
      case 'marketplace':
        return KNavItem.marketplace;
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
      body: Stack(
        children: [
          FcmWrapper(child: body),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: KBottomNavbar(
              selectedNavItem: _getSelectedNavItem(path),
            ),
          ),
        ],
      ),
    );
  }
}

class KBottomNavbar extends StatelessWidget {
  const KBottomNavbar({super.key, required this.selectedNavItem});

  final KNavItem selectedNavItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: KNavItem.values.map((item) {
          final isSelected = item == selectedNavItem;
          final isCamera = item == KNavItem.camera;

          if (isCamera) {
            // Slightly elevated camera icon
            return GestureDetector(
              onTap: () => context.go(item.route),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  item.icon,
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7),
                  size: 22,
                ),
              ),
            );
          }

          // Regular nav items
          return GestureDetector(
            onTap: () => context.go(item.route),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                item.icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.4),
                size: 22,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
