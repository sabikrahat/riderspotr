import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ridespotr/core/exception.dart';
import 'package:ridespotr/core/toastification.dart';
import 'package:ridespotr/presentation/pages/auth/login_screen.dart';
import 'package:ridespotr/presentation/pages/auth/your_experience_screen.dart';
import 'package:ridespotr/presentation/widgets/shared/loading_overlay.dart';

import '../../../core/extensions.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import '../../widgets/shared/custom_text_field.dart';

class AboutYouScreen extends ConsumerStatefulWidget {
  static const String routeName = '/about-you';
  const AboutYouScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AboutYouScreenState();
}

class _AboutYouScreenState extends ConsumerState<AboutYouScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  DateTime? _dateOfBirth;

  bool isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userProvider.notifier);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Back(
            onPressed: () async {
              await notifier.signOut(context: context);
              if (context.mounted) {
                context.pushReplacement(LoginScreen.routeName);
              }
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Image.asset(
              'assets/onboarding/about.png',
              width: double.infinity,
              height: context.height * 0.36,
            ),
            PagePadding(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABOUT YOU',
                          style: context.textTheme.headlineSmall,
                        ),
                        Gap(4),
                        Text('Tell us about yourself'),
                        Gap(24),
                        ValidatedTextField(
                          labelText: 'First Name',
                          controller: _firstNameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          required: true,
                          firstNameValidation: true,
                        ),
                        Gap(8),
                        ValidatedTextField(
                          labelText: 'Last Name',
                          controller: _lastNameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          required: true,
                          lastNameValidation: true,
                        ),
                        Gap(8),
                        ValidatedTextField(
                          labelText: 'Username',
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          required: true,
                          usernameValidation: true,
                        ),
                        Gap(8),
                        CustomTextField(
                          controller: _dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                          ),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              initialEntryMode: DatePickerEntryMode.input,
                              context: context,
                              initialDate: DateTime.now().subtract(
                                Duration(days: 365 * 18),
                              ),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now().subtract(
                                Duration(days: 365),
                              ),
                            );
                            if (picked != null && picked != _dateOfBirth) {
                              setState(() {
                                _dateOfBirth = picked;
                                _dobController.text =
                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                        Gap(24),
                        LongButton(
                          text: 'Continue',
                          onPressed: () async {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                await notifier.updateUser(
                                  user: notifier.user!.copyWith(
                                    firstName: _firstNameController.text.trim(),
                                    lastName: _lastNameController.text.trim(),
                                    username: _usernameController.text.trim(),
                                    dob: _dateOfBirth!,
                                  ),
                                );
                                if (context.mounted) {
                                  context.push(YourExperienceScreen.routeName);
                                }
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
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
