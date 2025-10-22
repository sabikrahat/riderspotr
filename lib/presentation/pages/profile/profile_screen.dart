import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const String routeName = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    return Center(
      child: FilledButton(
        onPressed: () async {
          // await Supabase.instance.client.auth.signOut();
          // if (context.mounted) {
          //   context.pushReplacement(LoginScreen.routeName);
          // }
          await notifier.signOut(context: context);
        },
        child: Text('Logout'),
      ),
    );
  }
}
