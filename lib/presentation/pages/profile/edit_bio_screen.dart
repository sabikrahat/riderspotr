import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../providers/auth/user_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/loading_overlay.dart';
import '../../widgets/shared/long_button.dart';
import '../../widgets/shared/page_padding.dart';

class EditBioScreen extends ConsumerStatefulWidget {
  const EditBioScreen({super.key});

  static const String routeName = '/edit-bio';

  @override
  ConsumerState<EditBioScreen> createState() => _EditBioScreenState();
}

class _EditBioScreenState extends ConsumerState<EditBioScreen> {
  late TextEditingController _bioController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider.notifier).user;
    _bioController = TextEditingController(text: user?.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveBio() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifier = ref.read(userProvider.notifier);
      final user = notifier.user;
      if (user == null) return;

      final bio = _bioController.text.trim();
      await notifier.updateUser(
        user: user.copyWith(bio: bio.isEmpty ? null : bio),
      );
      await notifier.refreshUser();

      if (mounted) {
        showSuccessMessage('Bio updated successfully!');
        context.pop();
      }
    } catch (e) {
      debugPrint('Error updating bio: $e');
      showErrorMessage('Failed to update bio. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = _bioController.text.length;
    const maxCharacters = 150;

    return LoadingOverlay(
      isLoading: _isLoading,
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
                    // Title
                    Text(
                      'EDIT BIO',
                      style: context.textTheme.headlineSmall,
                    ),
                    const Gap(4),
                    Text('Tell people a little about yourself'),
                    const Gap(24),

                    // Bio text field
                    TextField(
                      controller: _bioController,
                      maxLines: 6,
                      maxLength: maxCharacters,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      onChanged: (value) {
                        setState(() {}); // Rebuild to update character count
                      },
                      decoration: InputDecoration(
                        hintText:
                            'Car enthusiast 🏎️\nLamborghini collector\nWeekend racer',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 15,
                        ),
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.05),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                    const Gap(8),

                    // Character count
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '$characterCount/$maxCharacters',
                        style: TextStyle(
                          color: characterCount > maxCharacters
                              ? Colors.red.withValues(alpha: 0.8)
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Gap(24),

                    // Save button
                    LongButton(
                      text: 'Save Bio',
                      onPressed: _saveBio,
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
