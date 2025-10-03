import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/auth/about_you_screen.dart';
import 'package:ridespotr/presentation/pages/auth/your_experience_screen.dart';
import 'package:ridespotr/presentation/pages/auth/your_location_screen.dart';
import 'package:ridespotr/presentation/pages/nav_screen.dart';
import 'package:ridespotr/services/auth/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/otp_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';
import '../presentation/pages/camera/camera_screen.dart';
import '../presentation/pages/graph/graph_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/pages/map/map_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';

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
      builder: (_, _) => AboutYouScreen(),
    ),
    GoRoute(
      path: YourExperienceScreen.routeName,
      // redirect: authHandler,
      builder: (_, _) => YourExperienceScreen(),
    ),
    GoRoute(
      path: YourLocationScreen.routeName,
      // redirect: authHandler,
      builder: (_, _) => YourLocationScreen(),
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
          path: MapScreen.routeName,
          builder: (_, _) => MapScreen(),
        ),
        GoRoute(
          path: GraphScreen.routeName,
          builder: (_, _) => GraphScreen(),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          builder: (_, _) => ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: CameraScreen.routeName,
      redirect: authHandler,
      builder: (_, _) => CameraScreen(),
    ),
  ],
);
