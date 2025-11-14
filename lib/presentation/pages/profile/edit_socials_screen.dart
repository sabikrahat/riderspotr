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

class EditSocialsScreen extends ConsumerStatefulWidget {
  const EditSocialsScreen({super.key});

  static const String routeName = '/edit-socials';

  @override
  ConsumerState<EditSocialsScreen> createState() => _EditSocialsScreenState();
}

class _EditSocialsScreenState extends ConsumerState<EditSocialsScreen> {
  late TextEditingController _instagramController;
  late TextEditingController _tiktokController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider.notifier).user;
    _instagramController = TextEditingController(text: user?.instagramUrl);
    _tiktokController = TextEditingController(text: user?.tiktokUrl);
  }

  @override
  void dispose() {
    _instagramController.dispose();
    _tiktokController.dispose();
    super.dispose();
  }

  Future<void> _saveSocials() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final notifier = ref.read(userProvider.notifier);
      final user = notifier.user;
      if (user == null) return;

      final instagram = _instagramController.text.trim();
      final tiktok = _tiktokController.text.trim();

      await notifier.updateUser(
        user: user.copyWith(
          instagramUrl: instagram.isEmpty ? null : instagram,
          tiktokUrl: tiktok.isEmpty ? null : tiktok,
        ),
      );
      await notifier.refreshUser();

      if (mounted) {
        showSuccessMessage('Social links updated successfully!');
        context.pop();
      }
    } catch (e) {
      debugPrint('Error updating social links: $e');
      showErrorMessage('Failed to update social links. Please try again.');
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
                      'EDIT SOCIALS',
                      style: context.textTheme.headlineSmall,
                    ),
                    const Gap(4),
                    Text('Add your social media links'),
                    const Gap(24),

                    // Instagram URL field
                    Text(
                      'INSTAGRAM',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(8),
                    TextField(
                      controller: _instagramController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'https://instagram.com/username',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 15,
                        ),
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
                    const Gap(20),

                    // TikTok URL field
                    Text(
                      'TIKTOK',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(8),
                    TextField(
                      controller: _tiktokController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                        hintText: 'https://tiktok.com/@username',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                          fontSize: 15,
                        ),
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
                    const Gap(24),

                    // Save button
                    LongButton(
                      text: 'Save Links',
                      onPressed: _saveSocials,
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
