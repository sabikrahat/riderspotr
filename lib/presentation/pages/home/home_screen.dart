import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../providers/auth/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(userProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Welcome to the Home Screen!'),
            Gap(16),
            ElevatedButton(
              onPressed: () async => await notifier.signOut(context: context),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
