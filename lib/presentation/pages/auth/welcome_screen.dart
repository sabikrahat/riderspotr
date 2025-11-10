import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../widgets/shared/logo.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String routeName = '/welcome';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carbon fiber background
          Positioned.fill(
            child: Image.asset(
              'assets/carbon/47.jpg',
              fit: BoxFit.cover,
              opacity: AlwaysStoppedAnimation(0.3),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: context.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: PagePadding(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Logo(),
                    Gap(16),
                    Text(
                      "Discover, capture and collect rare cars.\nJoin the ultimate car spotting community.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                    ),
                    Gap(16),
                    LongButton(
                      text: 'Continue',
                      onPressed: () => context.push(RegisterScreen.routeName),
                    ),
                    Gap(16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
