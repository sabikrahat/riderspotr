import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/capture/scanner.dart';
import '../../widgets/shared/back.dart';
import '../payment/upgrade_required_screen.dart';
import 'scan_detail_screen.dart';

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen({super.key});

  static const String routeName = '/camera';

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = true;

  bool _isUploading = false;
  XFile? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Compresses an image to ensure it's under 3MB
  Future<XFile> _compressImage(XFile imageFile) async {
    final file = File(imageFile.path);
    final fileSize = await file.length();

    // If already under 3MB, return as is
    const maxSize = 3 * 1024 * 1024; // 3MB in bytes
    if (fileSize < maxSize) {
      debugPrint(
        'Image size: ${fileSize / 1024 / 1024}MB - No compression needed',
      );
      return imageFile;
    }

    debugPrint('Image size: ${fileSize / 1024 / 1024}MB - Compressing...');

    try {
      final dir = await getTemporaryDirectory();
      final targetPath = path.join(
        dir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed${path.extension(imageFile.path)}',
      );

      // Start with quality 85 and reduce if needed
      int quality = 85;
      XFile? compressedFile;

      while (quality > 20) {
        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: quality,
          minWidth: 1920,
          minHeight: 1080,
        );

        if (result != null) {
          final compressedSize = await File(result.path).length();
          debugPrint(
            'Compressed to ${compressedSize / 1024 / 1024}MB at quality $quality',
          );

          if (compressedSize < maxSize) {
            compressedFile = result;
            break;
          }
        }

        quality -= 10;
      }

      if (compressedFile == null) {
        debugPrint('Warning: Could not compress below 3MB, using best attempt');
        return imageFile;
      }

      final finalSize = await File(compressedFile.path).length();
      debugPrint('Final compressed size: ${finalSize / 1024 / 1024}MB');

      return compressedFile;
    } catch (e) {
      debugPrint('Error compressing image: $e');
      return imageFile; // Return original on error
    }
  }

  // TODO: Remove - Temporary method for testing with gallery images
  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return;

      setState(() {
        _capturedImage = image;
        _isUploading = true;
      });

      // Compress image before uploading
      final compressedImage = await _compressImage(image);

      // Use garage provider's scanCar method
      final carSpotModel = await ref
          .read(garageProvider(null).notifier)
          .scanCar(compressedImage);

      setState(() {
        _isUploading = false;
        _capturedImage = null;
      });

      if (!context.mounted) return;
      await context.push(
        ScanDeatilScreen.routeName,
        extra: carSpotModel,
      );
    } on EdgeFunctionException catch (e) {
      showAlertMessage(e.message);
    } catch (e) {
      showAlertMessage('Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _capturedImage = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Back(),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Camera Preview or Captured Image
          if (_capturedImage != null)
            // Show captured image during scanning
            SizedBox.expand(
              child: Image.file(
                File(_capturedImage!.path),
                fit: BoxFit.cover,
              ),
            )
          else if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_controller != null && _controller!.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),
            )
          else
            const Center(
              child: Text(
                'Camera not available',
                style: TextStyle(color: Colors.white),
              ),
            ),
          // Scanning overlay or camera controls
          if (_isUploading)
            _buildScanningOverlay(context)
          else
            Stack(
              children: [
                Scanner(),
                Positioned(
                  child: SizedBox(
                    height: context.height * 0.225,
                    width: context.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'CAPTURE',
                            style: context.textTheme.headlineMedium,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Keep the car within the boundaries of the frame',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Widget below the camera view
                Positioned(
                  top: context.height * 0.775 + 24,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // TODO: Remove - Temporary gallery button for testing
                          GestureDetector(
                            onTap: _pickFromGallery,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          GestureDetector(
                            onTap: () async {
                              // Check subscription limit
                              final subscription = ref.read(
                                subscriptionProvider.notifier,
                              );
                              final garageNotifier = ref.read(
                                garageProvider(null).notifier,
                              );
                              final currentCarCount =
                                  garageNotifier.carSpots.length;

                              if (!subscription.canAddMoreCars(
                                currentCarCount,
                              )) {
                                if (!context.mounted) return;
                                await context.push(
                                  UpgradeRequiredScreen.routeName,
                                );
                                return;
                              }

                              // capture image
                              try {
                                final XFile? file = await _controller
                                    ?.takePicture();
                                if (file == null) {
                                  showAlertMessage(
                                    'Failed to capture image. Please try again.',
                                  );
                                  return;
                                }

                                setState(() {
                                  _capturedImage = file;
                                  _isUploading = true;
                                });

                                // Compress image before uploading
                                final compressedImage = await _compressImage(
                                  file,
                                );

                                // Use garage provider's scanCar method
                                final carSpotModel = await ref
                                    .read(garageProvider(null).notifier)
                                    .scanCar(compressedImage);

                                setState(() {
                                  _isUploading = false;
                                  _capturedImage = null;
                                });
                                if (!context.mounted) return;
                                await context.push(
                                  ScanDeatilScreen.routeName,
                                  extra: carSpotModel,
                                );
                              } on EdgeFunctionException catch (e) {
                                showAlertMessage(e.message);
                              } catch (e) {
                                showAlertMessage('Error: $e');
                              } finally {
                                setState(() {
                                  _isUploading = false;
                                  _capturedImage = null;
                                });
                              }
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap to capture',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildScanningOverlay(BuildContext context) {
    return Container(
      width: context.width,
      height: context.height,
      color: Colors.black.withValues(alpha: 0.7),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated scanning indicator
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer pulsing circle
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 1.0 - value,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                      // Middle circle
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(
                              alpha: 0.6,
                            ),
                            width: 2,
                          ),
                        ),
                      ),
                      // Inner spinning indicator
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      // Center icon
                      Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                );
              },
              onEnd: () {
                // Restart animation for continuous pulsing effect
                if (mounted && _isUploading) {
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 32),
            // Scanning text
            Text(
              'ANALYZING YOUR CAR',
              style: context.textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Time estimate
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'This may take 30-60 seconds',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Additional info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Please wait while we identify the make, model, and details of your vehicle',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
