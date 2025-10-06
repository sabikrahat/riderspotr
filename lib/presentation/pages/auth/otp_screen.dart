import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:ridespotr/core/exception.dart';
import 'package:ridespotr/core/toastification.dart';
import 'package:ridespotr/presentation/pages/auth/about_you_screen.dart';
import 'package:ridespotr/presentation/widgets/shared/loading_overlay.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class OtpScreenParams {
  final String email;
  final bool shouldCreateUser;

  OtpScreenParams({
    required this.email,
    required this.shouldCreateUser,
  });
}

class OtpScreen extends ConsumerStatefulWidget {
  static const String routeName = '/otp';

  final OtpScreenParams params;

  const OtpScreen({
    super.key,
    required this.params,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Back(),
        ),
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
                            Text(
                              'ENTER OTP',
                              style: context.textTheme.headlineSmall,
                            ),
                            Gap(4),
                            Text('Check your email for a 6 digit OTP code'),
                            Gap(24),
                            Center(
                              child: Form(
                                key: _formKey,
                                child: Pinput(
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.equalLength(
                                      6,
                                      errorText: 'Please enter a valid OTP',
                                    ),
                                  ]),
                                  controller: pinController,
                                  length: 6,
                                  defaultPinTheme: PinTheme(
                                    width: 100,
                                    height: 60,
                                    textStyle: context.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.theme.primaryColor,
                                        ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: context.theme.primaryColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  focusedPinTheme: PinTheme(
                                    width: 100,
                                    height: 60,
                                    textStyle: context.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: context.theme.primaryColor,
                                        ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: context.theme.primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                            ),
                            Gap(24),
                            LongButton(
                              text: 'Continue',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await ref
                                        .read(userProvider.notifier)
                                        .verifyOtp(
                                          context: context,
                                          email: widget.params.email,
                                          token: pinController.text,
                                          shouldCreateUser:
                                              widget.params.shouldCreateUser,
                                        );

                                    if (context.mounted) {
                                      context.push(AboutYouScreen.routeName);
                                    }
                                  } on KException catch (e) {
                                    showErrorMessage(e.message);
                                  } catch (e) {
                                    showErrorMessage(e.toString());
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              // onPressed: pin != null && pin!.length == 6
                              //     ? () async {
                              //         await notifier.verifyOtp(
                              //           context: context,
                              //           email: widget.params.email,
                              //           token: pin!,
                              //           shouldCreateUser:
                              //               widget.params.shouldCreateUser,
                              //         );
                              //       }
                              //     : null,
                            ),
                            // Gap(16),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Text('Didn\'t get a code?'),
                            //     Gap(4),
                            //     GestureDetector(
                            //       onTap: () async => await notifier.resendOtp(
                            //         context: context,
                            //         email: widget.params.email,
                            //         shouldCreateUser:
                            //             widget.params.shouldCreateUser,
                            //       ),
                            //       child: Text(
                            //         'Resend',
                            //         style: TextStyle(
                            //           fontWeight: FontWeight.bold,
                            //           shadows: [
                            //             Shadow(
                            //               color:
                            //                   context.textTheme.bodySmall!.color!,
                            //               offset: Offset(0, -2),
                            //             ),
                            //           ],
                            //           color: Colors.transparent,
                            //           decoration: TextDecoration.underline,
                            //           decorationColor:
                            //               context.textTheme.bodySmall!.color!,
                            //           decorationThickness: 1,
                            //           decorationStyle: TextDecorationStyle.solid,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
