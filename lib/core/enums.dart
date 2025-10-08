import 'package:flutter/material.dart';

import '../presentation/pages/graph/graph_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/map/map_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';

enum KNavItem { home, map, graph, profile }

extension KDrawerExtension on KNavItem {
  IconData get icon => switch (this) {
    KNavItem.home => Icons.home_rounded,
    KNavItem.map => Icons.map_rounded,
    KNavItem.graph => Icons.bar_chart_rounded,
    KNavItem.profile => Icons.person_rounded,
  };

  String get title => switch (this) {
    KNavItem.home => 'Home',
    KNavItem.map => 'Map',
    KNavItem.graph => 'Graph',
    KNavItem.profile => 'Profile',
  };

  Widget get widget => switch (this) {
    KNavItem.home => const HomeScreen(),
    KNavItem.map => const MapScreen(),
    KNavItem.graph => const GraphScreen(),
    KNavItem.profile => const ProfileScreen(),
  };

  String get route => switch (this) {
    KNavItem.home => HomeScreen.routeName,
    KNavItem.map => MapScreen.routeName,
    KNavItem.graph => GraphScreen.routeName,
    KNavItem.profile => ProfileScreen.routeName,
  };

  bool get isHome => this == KNavItem.home;
  bool get isMap => this == KNavItem.map;
  bool get isGraph => this == KNavItem.graph;
  bool get isProfile => this == KNavItem.profile;

  bool get isNotHome => !isHome;
  bool get isNotMap => !isMap;
  bool get isNotGraph => !isGraph;
  bool get isNotProfile => !isProfile;
}

enum Measurement { metric, imperial }

extension MeasurementUnitExtension on Measurement {
  String get title => switch (this) {
    Measurement.metric => 'Metric',
    Measurement.imperial => 'Imperial',
  };
}
