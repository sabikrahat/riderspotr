import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';
import '../../../core/extensions.dart';
import '../../widgets/shared/page_padding.dart';

import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/onboarding/otp.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: context.height * 0.36,
          ),
          PagePadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Back(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ENTER OTP', style: context.textTheme.headlineSmall),
                          Gap(4),
                          Text('Check your email for a 6 digit OTP code'),
                          Gap(32),
                          Center(
                            child: Pinput(
                              length: 6,
                              defaultPinTheme: PinTheme(
                                width: 50,
                                height: 60,
                                textStyle: context.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.primaryColor,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: context.theme.primaryColor, width: 2),
                                  ),
                                ),
                              ),
                              focusedPinTheme: PinTheme(
                                width: 50,
                                height: 60,
                                textStyle: context.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.primaryColor,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: context.theme.primaryColor, width: 2),
                                  ),
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onCompleted: (pin) {
                                debugPrint("Entered PIN: $pin");
                              },
                            ),
                          ),
                          Gap(24),
                          LongButton(text: 'Continue', onPressed: () {}),
                          Gap(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Didn\'t get a code?'),
                              Gap(4),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Resend',
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
                        ],
                      ),
                    ),
                  ),
                ),
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
