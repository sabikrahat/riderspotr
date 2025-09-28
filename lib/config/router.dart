import 'package:go_router/go_router.dart';
import 'package:ridespotr/presentation/pages/auth/welcome_screen.dart';

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => WelcomeScreen())],
);
