import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums.dart';
import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/custom_text_field.dart';
import '../../widgets/shared/dropdown_textfield.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import 'login_screen.dart';
import 'your_experience_screen.dart';

class AboutYouScreen extends ConsumerStatefulWidget {
  static const String routeName = '/about-you';
  const AboutYouScreen({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

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
  String? _measurement;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(userProvider.future);
      final notifier = ref.read(userProvider.notifier);
      _firstNameController.text = notifier.user?.firstName ?? '';
      _lastNameController.text = notifier.user?.lastName ?? '';
      _usernameController.text = notifier.user?.username ?? '';
      _dateOfBirth = notifier.user?.dob;
      _dobController.text = _dateOfBirth == null
          ? ''
          : '${_dateOfBirth?.year}-${_dateOfBirth?.month.toString().padLeft(2, '0')}-${_dateOfBirth?.day.toString().padLeft(2, '0')}';
      _measurement =
          notifier.user?.measurement?.toMeasurement?.name ??
          Measurement.metric.name;
    });
  }

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
    ref.watch(userProvider);
    final notifier = ref.read(userProvider.notifier);
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Back(
            onPressed: () async {
              if (widget.fromUpdateProfile) {
                if (context.mounted) context.pop();
                return;
              }
              await notifier.signOut(context: context);
              if (context.mounted) {
                context.pushReplacement(LoginScreen.routeName);
              }
            },
          ),
        ),
        extendBodyBehindAppBar: true,
        body: CarbonBackground(
          imgPath: 'assets/carbon/47.jpg',
          heightPercent: 0.36,
          child: PagePadding(
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
                      Gap(8),
                      DropdownTextfield(
                        labelText: 'Measurement',
                        items: Measurement.values.map((e) => e.title).toList(),
                        initialValue: _measurement != null
                            ? Measurement.values
                                  .firstWhere(
                                    (element) => element.name == _measurement,
                                  )
                                  .title
                            : null,
                        onChanged: (val) => setState(() {
                          final idx = Measurement.values.indexWhere(
                            (element) => element.title == val,
                          );
                          _measurement = idx != -1
                              ? Measurement.values[idx].name
                              : null;
                        }),
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
                                  measurement: _measurement!,
                                ),
                              );
                              if (widget.fromUpdateProfile) {
                                if (context.mounted) context.pop();
                                return;
                              }
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
        ),
      ),
    );
  }
}
