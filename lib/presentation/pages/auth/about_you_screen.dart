import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';

import '../../../core/extensions.dart';
import '../../../models/auth/user_model.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class AboutYouScreen extends ConsumerStatefulWidget {
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

  Future<void> _submit(Future<void> Function() afterCheck) async {
    if (!_formKey.currentState!.validate()) return;
    await afterCheck.call();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(onPressed: () async => await notifier.signOut(context: context)),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/onboarding/about.png',
            // fit: BoxFit.cover,
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
                      Text('ABOUT YOU', style: context.textTheme.headlineSmall),
                      Gap(4),
                      Text('Tell us about yourself'),
                      Gap(24),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(labelText: 'First Name'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Please enter your first name'),
                          FormBuilderValidators.firstName(
                            errorText: 'Please enter a valid first name',
                          ),
                        ]),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: _lastNameController,
                        decoration: InputDecoration(labelText: 'Last Name'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Please enter your last name'),
                          FormBuilderValidators.lastName(
                            errorText: 'Please enter a valid last name',
                          ),
                        ]),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(errorText: 'Please enter your username'),
                          FormBuilderValidators.username(
                            errorText: 'Please enter a valid username',
                          ),
                        ]),
                      ),
                      Gap(16),
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        decoration: InputDecoration(labelText: 'Date of Birth'),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now().subtract(Duration(days: 365)),
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onPressed: () async => await _submit(() async {
                          await notifier.updateUser(
                            context: context,
                            user: notifier.user!.copyWith(
                              firstName: _firstNameController.text.trim(),
                              lastName: _lastNameController.text.trim(),
                              username: _usernameController.text.trim(),
                              dob: _dateOfBirth!,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
