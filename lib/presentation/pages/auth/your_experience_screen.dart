import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/dropdown_textfield.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';
import 'your_location_screen.dart';

class YourExperienceScreen extends ConsumerStatefulWidget {
  static const String routeName = '/your-experience';
  const YourExperienceScreen({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _YourExperienceScreenState();
}

class _YourExperienceScreenState extends ConsumerState<YourExperienceScreen> {
  String? _carKnowledge;
  String? _spottingExperience;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.watch(userProvider.future);
      final notifier = ref.read(userProvider.notifier);
      setState(() {
        _carKnowledge = notifier.user?.knowledgeLevel;
        _spottingExperience = notifier.user?.experience;
      });
    });
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
          leading: Back(),
        ),
        extendBodyBehindAppBar: true,
        body: CarbonBackground(
          imgPath: 'assets/carbon/49.jpg',
          heightPercent: 0.36,
          child: PagePadding(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR EXPERIENCE',
                      style: context.textTheme.headlineSmall,
                    ),
                    Gap(4),
                    Text('How experienced are you with car spotting?'),
                    Gap(24),
                    DropdownTextfield(
                      initialValue: _carKnowledge,
                      labelText: 'Car Knowledge',
                      items: [
                        'Newbie',
                        'Casual Driver',
                        'Car Enthusiast',
                        'Gearhead',
                        'Car Guru',
                      ],
                      onChanged: (val) => setState(() => _carKnowledge = val),
                    ),
                    Gap(8),
                    DropdownTextfield(
                      initialValue: _spottingExperience,
                      labelText: 'Spotting Experience',
                      items: [
                        'First Timer',
                        'Casual Spotter',
                        'Weekend Hunter',
                        'Street Scout',
                        'Pro Spotter',
                      ],
                      onChanged: (val) =>
                          setState(() => _spottingExperience = val),
                    ),
                    Gap(24),
                    LongButton(
                      text: 'Continue',
                      onPressed: () async {
                        if (_carKnowledge == null) {
                          showErrorMessage(
                            'Please select your car knowledge',
                          );
                          return;
                        }
                        if (_spottingExperience == null) {
                          showErrorMessage(
                            'Please select your spotting experience',
                          );
                          return;
                        }
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          await notifier.updateUser(
                            user: notifier.user!.copyWith(
                              knowledgeLevel: _carKnowledge!,
                              experience: _spottingExperience!,
                            ),
                          );
                          if (widget.fromUpdateProfile) {
                            if (context.mounted) context.pop();
                            return;
                          }
                          if (context.mounted) {
                            context.push(YourLocationScreen.routeName);
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
    );
  }
}
