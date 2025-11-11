import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/car_spot_model.dart';
import '../../../services/car/report_service.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/custom_text_field.dart';
import '../../widgets/shared/dropdown_textfield.dart';
import '../../widgets/shared/long_button.dart';

class ReportCarScreen extends ConsumerStatefulWidget {
  static const String routeName = '/report-car';

  const ReportCarScreen({super.key, required this.carSpot});

  final CarSpotModel carSpot;

  @override
  ConsumerState<ReportCarScreen> createState() => _ReportCarScreenState();
}

class _ReportCarScreenState extends ConsumerState<ReportCarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commentsController = TextEditingController();
  final _reportService = ReportService();

  String? _selectedReason;
  bool _isSubmitting = false;

  final List<String> _reportReasons = [
    'Incorrect car identification',
    'Incorrect car information',
    'Inappropriate image',
    'Spam or fake',
    'Privacy concerns',
    'Other',
  ];

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedReason == null) {
      showErrorMessage('Please select a reason for reporting');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _reportService.reportCarSpot(
        carSpotId: widget.carSpot.id,
        reason: _selectedReason!,
        comments: _commentsController.text.trim().isNotEmpty
            ? _commentsController.text.trim()
            : null,
      );

      if (mounted) {
        // Show success message
        showSuccessMessage(
          'Your feedback helps us maintain quality content.',
          title: 'Thank you for making this a better platform',
        );

        // Navigate back
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        showErrorMessage(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carSpot = widget.carSpot;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: CarbonBackground(
        imgPath: 'assets/carbon/49.jpg',
        heightPercent: 0.36,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  // Title
                  Text(
                    'REPORT CAR',
                    style: context.textTheme.headlineMedium,
                  ),
                  const Gap(8),
                  Text(
                    'Help us improve the platform!',
                  ),
                  const Gap(24),

                  // Car preview card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.05),
                          Colors.white.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        // Car image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            carSpot.imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const Gap(16),
                        // Car details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carSpot.car?.make?.name.toUpperCase() ??
                                    'UNKNOWN',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 2,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                carSpot.car?.model?.toUpperCase() ?? 'UNKNOWN',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  DropdownTextfield(
                    labelText: 'Select a reason',
                    items: _reportReasons,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value;
                      });
                    },
                  ),
                  const Gap(32),

                  // Comments field
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade900),
                      color: Colors.black.withValues(alpha: 0.4),
                    ),
                    child: CustomTextField(
                      controller: _commentsController,
                      decoration: InputDecoration(
                        labelText: 'Additional Comments (Optional)',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      maxLines: 6,
                      maxLength: 500,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                  const Gap(40),

                  // Info box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.white.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        const Gap(12),
                        Expanded(
                          child: Text(
                            'Reports are reviewed by our team. Thank you for helping us maintain a quality platform.',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(40),

                  // Submit button
                  LongButton(
                    text: _isSubmitting ? 'SUBMITTING...' : 'SUBMIT REPORT',
                    onPressed: _isSubmitting ? null : _submitReport,
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
