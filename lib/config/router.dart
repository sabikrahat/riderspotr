import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car/car_spot_model.dart';
import '../models/car/scan_detail_params.dart';
import '../presentation/pages/auth/about_you_screen.dart';
import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/otp_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';
import '../presentation/pages/auth/your_experience_screen.dart';
import '../presentation/pages/auth/your_location_screen.dart';
import '../presentation/pages/capture/camera_screen.dart';
import '../presentation/pages/capture/car_detail_screen.dart';
import '../presentation/pages/capture/manual_upload_screen.dart';
import '../presentation/pages/capture/scan_detail_screen.dart';
import '../presentation/pages/explore/explore_screen.dart';
import '../presentation/pages/garage/garage_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/leaderboard/leaderboard_screen.dart';
import '../presentation/pages/leaderboard/search_friend.dart';
import '../presentation/pages/nav_screen.dart';
import '../presentation/pages/payment/payment_screen.dart';
import '../presentation/pages/payment/upgrade_required_screen.dart';
import '../presentation/pages/profile/own_profile_screen.dart';
import '../presentation/pages/profile/user_profile_screen.dart';
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
      path: '/',
      redirect: (context, state) {
        final loggedIn = Supabase.instance.client.auth.currentUser != null;

        if (loggedIn) {
          return HomeScreen.routeName;
        }
        return LoginScreen.routeName;
      },
    ),
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
      builder: (_, state) =>
          AboutYouScreen(fromUpdateProfile: state.extra as bool? ?? false),
    ),
    GoRoute(
      path: YourExperienceScreen.routeName,
      // redirect: authHandler,
      builder: (_, state) => YourExperienceScreen(
        fromUpdateProfile: state.extra as bool? ?? false,
      ),
    ),
    GoRoute(
      path: YourLocationScreen.routeName,
      // redirect: authHandler,
      builder: (_, state) =>
          YourLocationScreen(fromUpdateProfile: state.extra as bool? ?? false),
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
          pageBuilder: (_, state) => NoTransitionPage(
            child: HomeScreen(
              isFinishRegister: state.extra as bool? ?? false,
            ),
          ),
        ),
        GoRoute(
          path: GarageScreen.routeName,
          pageBuilder: (_, __) => NoTransitionPage(child: GarageScreen()),
        ),
        GoRoute(
          path: LeaderboardScreen.routeName,
          pageBuilder: (_, __) => NoTransitionPage(child: LeaderboardScreen()),
        ),
        GoRoute(
          path: OwnProfileScreen.routeName,
          pageBuilder: (_, __) => NoTransitionPage(
            child: OwnProfileScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: UserProfileScreen.routeName,
      builder: (_, state) => UserProfileScreen(id: state.extra as String),
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
      path: ManualUploadScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => ManualUploadScreen(),
    ),
    GoRoute(
      path: ScanDeatilScreen.routeName,
      redirect: authHandler,
      builder: (_, state) {
        final extra = state.extra;
        if (extra is ScanDetailParams) {
          return ScanDeatilScreen(params: extra);
        }
        // Fallback for backward compatibility
        return ScanDeatilScreen(
          params: ScanDetailParams(
            carSpot: extra as CarSpotModel?,
            isManual: false,
          ),
        );
      },
    ),
    GoRoute(
      path: CarDetailScreen.routeName,
      redirect: authHandler,
      builder: (_, state) =>
          CarDetailScreen(carSpot: state.extra as CarSpotModel?),
    ),
    GoRoute(
      path: PaymentScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => PaymentScreen(),
    ),
    GoRoute(
      path: UpgradeRequiredScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => UpgradeRequiredScreen(),
    ),
  ],
);
