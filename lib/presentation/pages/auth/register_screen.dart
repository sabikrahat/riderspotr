import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: Back()),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/onboarding/register.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: context.height * 0.36,
          ),
          PagePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('REGISTER', style: context.textTheme.headlineSmall),
                          Gap(24),
                          TextFormField(decoration: InputDecoration(labelText: 'Email')),
                          Gap(24),
                          LongButton(
                            text: 'Get Started',
                            onPressed: () {
                              context.push('/otp');
                            },
                          ),
                          Gap(16),
                          Text(
                            'By creating an account, I agree to the Privacy Policy and Terms of Service of RIDESPOTR.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    Gap(4),
                    GestureDetector(
                      onTap: () {
                        context.push('/login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: context.textTheme.bodySmall!.color!,
                              offset: Offset(0, -2),
                            ),
                          ],
                          color: Colors.transparent,
                          decoration: TextDecoration.underline,
                          decorationColor: context.textTheme.bodySmall!.color!,
                          decorationThickness: 1,
                          decorationStyle: TextDecorationStyle.solid,
                        ),
                      ),
                    ),
                  ],
                ),
                Gap(16),
              ],
            ),
          ),
          // Back(),
          // Text('REGISTER', style: context.textTheme.headlineSmall),
          // TextFormField(decoration: InputDecoration(labelText: 'Email')),
          // LongButton(text: 'Get Started', onPressed: () {}),
          // Text(
          //   'By creating an account, I agree to the Privacy Policy and Terms of Service of RIDESPOTR.',
          // ),
          // Back(),
        ],
      ),
    );
  }
}
