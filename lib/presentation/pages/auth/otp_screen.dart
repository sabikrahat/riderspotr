import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinput/pinput.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final bool shouldCreateUser;
  const OtpScreen({super.key, required this.email, this.shouldCreateUser = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String? pin;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: Back()),
      extendBodyBehindAppBar: true,
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
                              onChanged: (value) => setState(() => pin = value),
                              onCompleted: (pin) => setState(() => this.pin = pin),
                            ),
                          ),
                          Gap(24),
                          LongButton(
                            text: 'Continue',
                            onPressed: pin != null && pin!.length == 6
                                ? () async {
                                    await notifier.verifyOtp(
                                      context: context,
                                      email: widget.email,
                                      token: pin!,
                                      shouldCreateUser: widget.shouldCreateUser,
                                    );
                                  }
                                : null,
                          ),
                          Gap(16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Didn\'t get a code?'),
                              Gap(4),
                              GestureDetector(
                                onTap: () async => await notifier.resendOtp(
                                  context: context,
                                  email: widget.email,
                                  shouldCreateUser: widget.shouldCreateUser,
                                ),
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
