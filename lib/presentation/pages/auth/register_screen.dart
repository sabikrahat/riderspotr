import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Future<void> _submit(Future<void> Function() afterCheck) async {
    if (!_formKey.currentState!.validate()) return;
    await afterCheck.call();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(authProvider.notifier);
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('REGISTER', style: context.textTheme.headlineSmall),
                            Gap(24),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onFieldSubmitted: (_) async => await _submit(
                                () async => await notifier.register(
                                  context: context,
                                  email: _emailController.text,
                                ),
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: 'Please enter your email',
                                ),
                                FormBuilderValidators.email(
                                  errorText: 'Please enter a valid email address',
                                ),
                              ]),
                            ),
                            Gap(24),
                            LongButton(
                              text: 'Get Started',
                              onPressed: () async => await _submit(
                                () async => await notifier.register(
                                  context: context,
                                  email: _emailController.text,
                                ),
                              ),
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
