import 'package:flutter/material.dart';

import '../presentation/pages/garage/garage_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/leaderboard/leaderboard_screen.dart';
import '../presentation/pages/profile/own_profile_screen.dart';

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
    KNavItem.profile => const OwnProfileScreen(),
  };

  String get route => switch (this) {
    KNavItem.home => HomeScreen.routeName,
    KNavItem.garage => GarageScreen.routeName,
    KNavItem.leaderboard => LeaderboardScreen.routeName,
    KNavItem.profile => OwnProfileScreen.routeName,
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

extension MeasurementStringExtension on String {
  Measurement? get toMeasurement {
    switch (this) {
      case 'metric':
        return Measurement.metric;
      case 'imperial':
        return Measurement.imperial;
      default:
        return null;
    }
  }
}

enum Rarity { common, uncommon, rare, epic, legendary, mythic }

extension RarityStringExtension on Rarity {
  String get name {
    switch (this) {
      case Rarity.common:
        return 'Common';
      case Rarity.uncommon:
        return 'Uncommon';
      case Rarity.rare:
        return 'Rare';
      case Rarity.epic:
        return 'Epic';
      case Rarity.legendary:
        return 'Legendary';
      case Rarity.mythic:
        return 'Mythic';
    }
  }

  Color get color {
    switch (this) {
      case Rarity.common:
        return Colors.grey;
      case Rarity.uncommon:
        return Colors.lightBlue;
      case Rarity.rare:
        return Colors.orange;
      case Rarity.epic:
        return Colors.purpleAccent;
      case Rarity.legendary:
        return Colors.amber;
      case Rarity.mythic:
        return Colors.red;
    }
  }
}

enum SortOptions {
  recent,
  oldest,
  alphabetical,
  alphabeticalReverse,
}

extension SortOptionsExtension on SortOptions {
  String get name {
    switch (this) {
      case SortOptions.recent:
        return 'Most Recent';
      case SortOptions.oldest:
        return 'Oldest';
      case SortOptions.alphabetical:
        return 'A-Z';
      case SortOptions.alphabeticalReverse:
        return 'Z-A';
    }
  }
}
