import 'package:flutter/material.dart';

import '../presentation/pages/garage/garage_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/leaderboard/leaderboard_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';

enum KNavItem { home, garage, leaderboard, profile }

extension KDrawerExtension on KNavItem {
  IconData get icon => switch (this) {
    KNavItem.home => Icons.home_rounded,
    KNavItem.garage => Icons.directions_car_rounded,
    KNavItem.leaderboard => Icons.bar_chart_rounded,
    KNavItem.profile => Icons.person_rounded,
  };

  String get title => switch (this) {
    KNavItem.home => 'Home',
    KNavItem.garage => 'Garage',
    KNavItem.leaderboard => 'Leaderboard',
    KNavItem.profile => 'Profile',
  };

  Widget get widget => switch (this) {
    KNavItem.home => const HomeScreen(),
    KNavItem.garage => const GarageScreen(),
    KNavItem.leaderboard => const LeaderboardScreen(),
    KNavItem.profile => const ProfileScreen(),
  };

  String get route => switch (this) {
    KNavItem.home => HomeScreen.routeName,
    KNavItem.garage => GarageScreen.routeName,
    KNavItem.leaderboard => LeaderboardScreen.routeName,
    KNavItem.profile => ProfileScreen.routeName,
  };

  bool get isHome => this == KNavItem.home;
  bool get isGarage => this == KNavItem.garage;
  bool get isLeaderboard => this == KNavItem.leaderboard;
  bool get isProfile => this == KNavItem.profile;

  bool get isNotHome => !isHome;
  bool get isNotGarage => !isGarage;
  bool get isNotLeaderboard => !isLeaderboard;
  bool get isNotProfile => !isProfile;
}

enum Measurement { metric, imperial }

extension MeasurementUnitExtension on Measurement {
  String get title => switch (this) {
    Measurement.metric => 'Metric',
    Measurement.imperial => 'Imperial',
  };
}
