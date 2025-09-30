import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/otp_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';
import '../presentation/pages/home/home_screen.dart';

const _nonAuthRoutes = ['/welcome', '/login', '/register', '/otp'];

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, _) => HomeScreen()),
    GoRoute(path: '/welcome', builder: (_, _) => WelcomeScreen()),
    GoRoute(path: '/register', builder: (_, _) => RegisterScreen()),
    GoRoute(path: '/login', builder: (_, _) => LoginScreen()),
    GoRoute(
      path: '/otp/:email',
      builder: (context, state) => OtpScreen(
        email: state.pathParameters['email'] ?? '',
        shouldCreateUser: state.uri.queryParameters['shouldCreateUser'] == 'true',
      ),
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
      return '/welcome';
    }

    // If user IS logged in and trying to access auth routes (except OTP), redirect to home
    if (loggedIn && isAuthRoute && !currentPath.startsWith('/otp')) {
      return '/';
    }

    return null;
  },
);
