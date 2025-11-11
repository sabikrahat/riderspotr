import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/scan_detail_params.dart';
import '../../../models/google_maps/map_prediction_model.dart';
import '../../../services/google_maps/google_maps_service.dart';
import '../../providers/car/garage_provider.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/carbon_background.dart';
import '../../widgets/shared/scanning_overlay.dart';
import 'scan_detail_screen.dart';

class ManualUploadScreen extends ConsumerStatefulWidget {
  const ManualUploadScreen({super.key});

  static const String routeName = '/manual-upload';

  @override
  ConsumerState<ManualUploadScreen> createState() => _ManualUploadScreenState();
}

class _ManualUploadScreenState extends ConsumerState<ManualUploadScreen> {
  XFile? _selectedImage;
  final TextEditingController _addressController = TextEditingController();
  final GoogleMapsService _mapsService = GoogleMapsService();
  bool _isUploading = false;

  List<MapPredictionModel> _predictions = [];
  bool _isLoadingPredictions = false;
  Timer? _debounce;
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedAddress;
  bool _isProgrammaticChange = false;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_onAddressChanged);
  }

  void _onAddressChanged() {
    // Don't trigger predictions if we're programmatically setting the address
    if (_isProgrammaticChange) {
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    final text = _addressController.text.trim();

    if (text.isEmpty) {
      setState(() {
        _predictions = [];
        _isLoadingPredictions = false;
      });
      return;
    }

    if (text.length < 3) {
      setState(() {
        _predictions = [];
      });
      return;
    }

    setState(() {
      _isLoadingPredictions = true;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final predictions = await _mapsService.getLocations(text);
        if (mounted) {
          setState(() {
            _predictions = predictions;
            _isLoadingPredictions = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _predictions = [];
            _isLoadingPredictions = false;
          });
        }
      }
    });
  }

  Future<void> _selectPrediction(MapPredictionModel prediction) async {
    setState(() {
      _isLoadingPredictions = true;
    });

    try {
      final placeDetails = await _mapsService.getLocationBasedOnPlaceId(
        prediction.placeId ?? '',
      );

      if (placeDetails != null && mounted) {
        final lat = placeDetails.geometry?.location?.lat;
        final lng = placeDetails.geometry?.location?.lng;
        final address = placeDetails.formattedAddress;

        if (lat != null && lng != null && address != null) {
          setState(() {
            _selectedLat = lat;
            _selectedLng = lng;
            _selectedAddress = address;
            _predictions = [];
            _isLoadingPredictions = false;
          });

          // Set flag to prevent triggering new predictions
          _isProgrammaticChange = true;
          _addressController.text = address;
          // Reset flag after a short delay to allow user typing again
          Future.delayed(Duration(milliseconds: 100), () {
            _isProgrammaticChange = false;
          });
        } else {
          if (mounted) {
            showAlertMessage('Could not get complete location details');
            setState(() {
              _isLoadingPredictions = false;
            });
          }
        }
      }
    } catch (e) {
      showAlertMessage('Error getting location details: $e');
      if (mounted) {
        setState(() {
          _isLoadingPredictions = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      showAlertMessage('Error selecting image: $e');
    }
  }

  Future<void> _uploadCar() async {
    if (_selectedImage == null) {
      showAlertMessage('Please select a car image');
      return;
    }

    if (_addressController.text.trim().isEmpty) {
      showAlertMessage('Please enter an address');
      return;
    }

    if (_selectedLat == null || _selectedLng == null) {
      showAlertMessage('Please select an address from the suggestions');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      final carSpotModel = await ref
          .read(garageProvider(null).notifier)
          .scanCar(
            _selectedImage!,
            isManual: true,
            manualAddress: _selectedAddress ?? _addressController.text.trim(),
            manualLat: _selectedLat,
            manualLng: _selectedLng,
          );

      if (!mounted) return;

      setState(() {
        _isUploading = false;
      });

      if (!context.mounted) return;
      await context.push(
        ScanDeatilScreen.routeName,
        extra: ScanDetailParams(
          carSpot: carSpotModel,
          isManual: true,
        ),
      );
    } on EdgeFunctionException catch (e) {
      showAlertMessage(e.message);
    } catch (e) {
      showAlertMessage('Error uploading car: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _addressController.removeListener(_onAddressChanged);
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      body: CarbonBackground(
        imgPath: 'assets/carbon/49.jpg',
        heightPercent: 0.36,
        child: Stack(
          children: [
            // Content
            SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'MANUAL UPLOAD',
                      style: context.textTheme.headlineMedium,
                    ),
                    Gap(8),
                    Text(
                      'Add a car to your collection manually',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    Gap(24),

                    // Image Picker Section
                    GestureDetector(
                      onTap: _isUploading ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: context.height * 0.35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.08),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      File(_selectedImage!.path),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    // Change image overlay
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.7,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                            Gap(6),
                                            Text(
                                              'CHANGE',
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 1,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.15),
                                          Colors.white.withValues(alpha: 0.05),
                                        ],
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 48,
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                    ),
                                  ),
                                  Gap(20),
                                  Text(
                                    'SELECT CAR IMAGE',
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 2,
                                        ),
                                  ),
                                  Gap(8),
                                  Text(
                                    'Tap to choose from gallery',
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    Gap(24),

                    Text(
                      "ADDRESS",
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    // Address Input Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _addressController,
                          enabled: !_isUploading,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Where did you spot this car?',
                            hintStyle: TextStyle(
                              color: Colors.white.withValues(alpha: 0.4),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                            suffixIcon: _isLoadingPredictions
                                ? Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),

                        // Address Suggestions
                        if (_predictions.isNotEmpty)
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.black,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                                width: 1,
                              ),
                            ),
                            constraints: BoxConstraints(maxHeight: 250),
                            child: ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: _predictions.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                              itemBuilder: (context, index) {
                                final prediction = _predictions[index];
                                return ListTile(
                                  dense: true,
                                  onTap: () => _selectPrediction(prediction),
                                  leading: Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    size: 20,
                                  ),
                                  title: Text(
                                    prediction.description ?? '',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),

                    Gap(40),

                    // Upload Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.grey.shade300,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isUploading ? null : _uploadCar,
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: _isUploading
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.upload_rounded,
                                        color: Colors.black,
                                        size: 22,
                                      ),
                                      Gap(12),
                                      Text(
                                        'UPLOAD CAR',
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 2,
                                              color: Colors.black,
                                            ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),

                    Gap(20),

                    // Info text
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 20,
                          ),
                          Gap(12),
                          Expanded(
                            child: Text(
                              'Manual uploads do not earn XP points',
                              style: context.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Gap(20),
                  ],
                ),
              ),
            ),

            // Scanning overlay
            if (_isUploading) ScanningOverlay(),
          ],
        ),
      ),
    );
  }
}
