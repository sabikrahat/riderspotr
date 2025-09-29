import 'package:go_router/go_router.dart';
import '../presentation/pages/auth/login_screen.dart';
import '../presentation/pages/auth/register_screen.dart';
import '../presentation/pages/auth/welcome_screen.dart';

import '../presentation/pages/auth/otp_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, _) => WelcomeScreen()),
    GoRoute(path: '/register', builder: (_, _) => RegisterScreen()),
    GoRoute(path: '/login', builder: (_, _) => LoginScreen()),
    GoRoute(path: '/otp', builder: (_, _) => OtpScreen()),
  ],
);
