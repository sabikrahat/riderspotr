import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () async {
          await Supabase.instance.client.auth.signOut();
          if (context.mounted) {
            context.pushReplacement(LoginScreen.routeName);
          }
        },
        child: Text('Logout'),
      ),
    );
  }
}
