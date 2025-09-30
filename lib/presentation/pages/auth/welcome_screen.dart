import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../widgets/shared/logo.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/video_player.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ShowVideo(videoPath: 'assets/welcome-video.mp4'),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: context.height * 0.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5), Colors.black],
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
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    ),
                    Gap(16),
                    LongButton(text: 'Continue', onPressed: () => context.push('/register')),
                    Gap(16),
                  ],
                ),
              ),
            ),
          ),
          // Logo(),
          // Text('WELCOME TO RIDESPOTR', style: context.textTheme.headlineSmall),
          // Text("This is a simple app that allows you to find rides in your area."),
          // TextFormField(decoration: InputDecoration(labelText: 'Email')),
          // LongButton(text: 'Continue'),
          // Back(),
          // DropdownTextfield(),
        ],
      ),
    );
  }
}
