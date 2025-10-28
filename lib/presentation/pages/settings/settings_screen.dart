import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/extensions.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/page_padding.dart';
import '../auth/about_you_screen.dart';
import '../auth/login_screen.dart';
import '../auth/your_experience_screen.dart';
import '../auth/your_location_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
        title: Text('SETTINGS', style: context.textTheme.headlineMedium),
        centerTitle: true,
      ),
      body: CarbonBackground(
        imgPath: 'assets/carbon/leaderboard-bg.jpg',
        child: PagePadding(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _Tile(
                      icon: Icons.person,
                      title: 'ACCOUNT',
                      onTap: () async => await context.push(AboutYouScreen.routeName, extra: true),
                    ),
                    Gap(8),
                    _Tile(
                      icon: Icons.checklist_rounded,
                      title: 'YOUR EXPERIENCE',
                      onTap: () async =>
                          await context.push(YourExperienceScreen.routeName, extra: true),
                    ),
                    Gap(8),
                    _Tile(
                      icon: Icons.location_on,
                      title: 'YOUR LOCATION',
                      onTap: () async =>
                          await context.push(YourLocationScreen.routeName, extra: true),
                    ),
                  ],
                ),
              ),
              Gap(16),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (_, ref, _) {
                        return ElevatedButton(
                          onPressed: () async {
                            await Supabase.instance.client.auth.signOut();
                            if (context.mounted) {
                              context.pushReplacement(LoginScreen.routeName);
                            }
                          },
                          child: Text('LOG OUT'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            Gap(16),
            Expanded(child: Text(title, style: context.textTheme.headlineSmall)),
          ],
        ),
      ),
    );
  }
}
