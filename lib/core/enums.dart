import 'package:flutter/material.dart';

import '../presentation/pages/capture/camera_screen.dart';
import '../presentation/pages/explore/explore_screen.dart';
import '../presentation/pages/garage/garage_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/leaderboard/leaderboard_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';

enum KNavItem { home, leaderboard, map, camera, marketplace, profile }

extension KDrawerExtension on KNavItem {
  IconData get icon => switch (this) {
    KNavItem.home => Icons.home_rounded,
    KNavItem.leaderboard => Icons.bar_chart_rounded,
    KNavItem.map => Icons.map_rounded,
    KNavItem.camera => Icons.camera_alt_rounded,
    KNavItem.marketplace => Icons.shopping_bag_rounded,
    KNavItem.profile => Icons.person_rounded,
  };

  String get title => switch (this) {
    KNavItem.home => 'Home',
    KNavItem.leaderboard => 'Leaderboard',
    KNavItem.map => 'Map',
    KNavItem.camera => 'Camera',
    KNavItem.marketplace => 'Marketplace',
    KNavItem.profile => 'Profile',
  };

  Widget get widget => switch (this) {
    KNavItem.home => const HomeScreen(),
    KNavItem.leaderboard => const LeaderboardScreen(),
    KNavItem.map => const ExploreScreen(),
    KNavItem.camera => const CameraScreen(),
    KNavItem.marketplace => const MarketplaceScreen(),
    KNavItem.profile => const ProfileScreen(),
  };

  String get route => switch (this) {
    KNavItem.home => HomeScreen.routeName,
    KNavItem.leaderboard => LeaderboardScreen.routeName,
    KNavItem.map => ExploreScreen.routeName,
    KNavItem.camera => CameraScreen.routeName,
    KNavItem.marketplace => MarketplaceScreen.routeName,
    KNavItem.profile => ProfileScreen.routeName,
  };

  bool get isHome => this == KNavItem.home;
  bool get isLeaderboard => this == KNavItem.leaderboard;
  bool get isMap => this == KNavItem.map;
  bool get isCamera => this == KNavItem.camera;
  bool get isMarketplace => this == KNavItem.marketplace;
  bool get isProfile => this == KNavItem.profile;

  bool get isNotHome => !isHome;
  bool get isNotLeaderboard => !isLeaderboard;
  bool get isNotMap => !isMap;
  bool get isNotCamera => !isCamera;
  bool get isNotMarketplace => !isMarketplace;
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

enum FeedType {
  global,
  country,
  friends,
}

enum SortOptions {
  recent,
  oldest,
  alphabetical,
  alphabeticalReverse,
  rarity,
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
      case SortOptions.rarity:
        return 'Rarity';
    }
  }
}

enum SubscriptionTier {
  free,
  basic,
  premium,
}

extension SubscriptionTierExtension on SubscriptionTier {
  int get maxCarSpots {
    switch (this) {
      case SubscriptionTier.free:
        return 5;
      case SubscriptionTier.basic:
        return 50;
      case SubscriptionTier.premium:
        return -1;
    }
  }

  bool get hasStatsAccess {
    switch (this) {
      case SubscriptionTier.free:
        return false;
      case SubscriptionTier.basic:
      case SubscriptionTier.premium:
        return true;
    }
  }

  bool get hasLeaderboardAccess {
    switch (this) {
      case SubscriptionTier.free:
        return false;
      case SubscriptionTier.basic:
      case SubscriptionTier.premium:
        return true;
    }
  }

  bool get isUnlimited {
    return this == SubscriptionTier.premium;
  }
}
