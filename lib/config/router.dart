import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car/car_spot_model.dart';
import '../presentation/pages/auth/about_you_screen.dart';
import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/otp_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';
import '../presentation/pages/auth/your_experience_screen.dart';
import '../presentation/pages/auth/your_location_screen.dart';
import '../presentation/pages/capture/camera_screen.dart';
import '../presentation/pages/capture/car_deatil_screen.dart';
import '../presentation/pages/capture/scan_deatil_screen.dart';
import '../presentation/pages/explore/explore.dart';
import '../presentation/pages/garage/garage_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/leaderboard/leaderboard_screen.dart';
import '../presentation/pages/leaderboard/search_friend.dart';
import '../presentation/pages/nav_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';
import '../presentation/pages/settings/settings_screen.dart';
import '../services/auth/user_service.dart';

Future<String?> authHandler(BuildContext context, GoRouterState state) async {
  // final currentPath = state.matchedLocation;
  final loggedIn = Supabase.instance.client.auth.currentUser != null;

  // If user is NOT logged in and trying to access protected route, redirect to welcome
  if (!loggedIn) {
    return WelcomeScreen.routeName;
  }

  final user = await UserService().getUser();

  if (user?.isProfileComplete == false ||
      user?.isExperienceComplete == false ||
      user?.isLocationComplete == false) {
    return AboutYouScreen.routeName;
  }

  return null;
}

final router = GoRouter(
  initialLocation: HomeScreen.routeName,
  routes: [
    GoRoute(
      path: WelcomeScreen.routeName,
      builder: (_, _) => WelcomeScreen(),
    ),
    GoRoute(
      path: RegisterScreen.routeName,
      builder: (_, _) => RegisterScreen(),
      // redirect: authHandler,
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (_, _) => LoginScreen(),
    ),
    GoRoute(
      path: OtpScreen.routeName,
      // redirect: authHandler,
      builder: (context, state) => OtpScreen(
        params: state.extra as OtpScreenParams,
      ),
    ),
    GoRoute(
      path: AboutYouScreen.routeName,
      // redirect: authHandler,
      builder: (_, state) => AboutYouScreen(fromUpdateProfile: state.extra as bool? ?? false),
    ),
    GoRoute(
      path: YourExperienceScreen.routeName,
      // redirect: authHandler,
      builder: (_, state) => YourExperienceScreen(fromUpdateProfile: state.extra as bool? ?? false),
    ),
    GoRoute(
      path: YourLocationScreen.routeName,
      // redirect: authHandler,
      builder: (_, state) => YourLocationScreen(fromUpdateProfile: state.extra as bool? ?? false),
    ),
    GoRoute(
      path: ExploreScreen.routeName,
      // redirect: authHandler,
      builder: (_, _) => ExploreScreen(),
    ),
    GoRoute(
      path: SearchFriendScreen.routeName,
      // redirect: authHandler,
      builder: (_, _) => SearchFriendScreen(),
    ),
    ShellRoute(
      redirect: authHandler,
      builder: (context, state, child) {
        final path = state.fullPath?.split('/').last.toLowerCase();
        return NavScreen(path: path, body: child);
      },
      routes: [
        GoRoute(
          path: HomeScreen.routeName,
          builder: (_, _) => HomeScreen(),
        ),
        GoRoute(
          path: GarageScreen.routeName,
          builder: (_, _) => GarageScreen(),
        ),
        GoRoute(
          path: LeaderboardScreen.routeName,
          builder: (_, _) => LeaderboardScreen(),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          builder: (_, state) => ProfileScreen(id: state.extra as String?),
        ),
      ],
    ),
    GoRoute(
      path: SettingsScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => SettingsScreen(),
    ),
    GoRoute(
      path: CameraScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => CameraScreen(),
    ),
    GoRoute(
      path: ScanDeatilScreen.routeName,
      redirect: authHandler,
      builder: (_, state) => ScanDeatilScreen(carSpot: state.extra as CarSpotModel?),
    ),
    GoRoute(
      path: CarDeatilScreen.routeName,
      redirect: authHandler,
      builder: (_, state) => CarDeatilScreen(carSpot: state.extra as CarSpotModel?),
    ),
  ],
);
