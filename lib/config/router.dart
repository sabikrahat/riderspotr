import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../presentation/pages/graph/graph_screen.dart';
import '../presentation/pages/map/map_screen.dart';
import '../presentation/pages/profile/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/otp_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';
import '../presentation/pages/camera/camera_screen.dart';
import '../presentation/pages/home/home_screen.dart';
import '../presentation/widgets/shared/scaffold.dart';

const _nonAuthRoutes = [
  '/${WelcomeScreen.name}',
  '/${LoginScreen.name}',
  '/${RegisterScreen.name}',
  '/${OtpScreen.name}',
];

final router = GoRouter(
  initialLocation: '/${HomeScreen.name}',
  routes: [
    GoRoute(
      path: '/${WelcomeScreen.name}',
      name: WelcomeScreen.name,
      builder: (_, _) => WelcomeScreen(),
    ),
    GoRoute(
      path: '/${RegisterScreen.name}',
      name: RegisterScreen.name,
      builder: (_, _) => RegisterScreen(),
    ),
    GoRoute(
      path: '/${LoginScreen.name}',
      name: LoginScreen.name,
      builder: (_, _) => LoginScreen(),
    ),
    GoRoute(
      name: OtpScreen.name,
      path: '/${OtpScreen.name}/:email',
      builder: (context, state) => OtpScreen(
        email: state.pathParameters['email'] ?? '',
        shouldCreateUser: state.uri.queryParameters['shouldCreateUser'] == 'true',
      ),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final path = state.fullPath?.split('/').last.toLowerCase();
        debugPrint('ShellRoute Path: $path');
        return KScaffold(path: path, body: child);
      },
      routes: [
        GoRoute(
          path: '/${HomeScreen.name}',
          name: HomeScreen.name,
          builder: (_, _) => HomeScreen(),
        ),
        GoRoute(
          path: '/${MapScreen.name}',
          name: MapScreen.name,
          builder: (_, _) => MapScreen(),
        ),
        GoRoute(
          path: '/${GraphScreen.name}',
          name: GraphScreen.name,
          builder: (_, _) => GraphScreen(),
        ),
        GoRoute(
          path: '/${ProfileScreen.name}',
          name: ProfileScreen.name,
          builder: (_, _) => ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/${CameraScreen.name}',
      name: CameraScreen.name,
      builder: (_, _) => CameraScreen(),
    ),
  ],
  redirect: (context, state) {
    final currentPath = state.matchedLocation;
    final loggedIn = Supabase.instance.client.auth.currentUser != null;
    debugPrint('Router redirect called. Current path: $currentPath, Logged in: $loggedIn');
    final isAuthRoute = _nonAuthRoutes.any((route) => currentPath.startsWith(route));

    debugPrint('Current path: $currentPath, Logged in: $loggedIn, Is auth route: $isAuthRoute');

    // If user is NOT logged in and trying to access protected route, redirect to welcome
    if (!loggedIn && !isAuthRoute) {
      return '/${WelcomeScreen.name}';
    }

    // If user IS logged in and trying to access auth routes (except OTP), redirect to home
    if (loggedIn && isAuthRoute && !currentPath.startsWith('/otp')) {
      return '/${HomeScreen.name}';
    }

    return null;
  },
);
