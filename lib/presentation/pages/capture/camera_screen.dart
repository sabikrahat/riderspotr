import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/exception.dart';
import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../../models/car/scan_detail_params.dart';
import '../../providers/car/garage_provider.dart';
import '../../providers/subscription/subscription_provider.dart';
import '../../widgets/capture/scanner.dart';
import '../../widgets/shared/back.dart';
import '../../widgets/shared/scanning_overlay.dart';
import '../payment/upgrade_required_screen.dart';
import 'manual_upload_screen.dart';
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
            ScanningOverlay()
          else
            Stack(
              children: [
                Scanner(),
                Positioned(
                  child: SizedBox(
                    height: context.height * 0.25,
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
                  top: context.height * 0.75 + 20,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Camera Capture Button (Centered)
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

                            // Immediately show loading indicator
                            setState(() {
                              _capturedImage = file;
                              _isUploading = true;
                            });

                            // Provider handles compression, blurring, and scanning
                            final carSpotModel = await ref
                                .read(garageProvider(null).notifier)
                                .scanCar(file);

                            if (!mounted) return;

                            setState(() {
                              _isUploading = false;
                              _capturedImage = null;
                            });

                            if (!context.mounted) return;
                            await context.push(
                              ScanDeatilScreen.routeName,
                              extra: ScanDetailParams(
                                carSpot: carSpotModel,
                                isManual: false,
                              ),
                            );
                          } on EdgeFunctionException catch (e) {
                            showAlertMessage(e.message);
                          } catch (e) {
                            showAlertMessage('Error: $e');
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isUploading = false;
                                _capturedImage = null;
                              });
                            }
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
                            size: 32,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Manual Upload Button
                      GestureDetector(
                        onTap: () {
                          context.push(ManualUploadScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.upload_file,
                                color: Colors.white.withValues(alpha: 0.8),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'MANUAL UPLOAD',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
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
}
