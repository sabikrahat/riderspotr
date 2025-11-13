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

  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 5.0;

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

      // Get zoom capabilities
      _minZoomLevel = await _controller!.getMinZoomLevel();
      _maxZoomLevel = await _controller!.getMaxZoomLevel();
      // Cap max zoom to 5x
      if (_maxZoomLevel > 5.0) {
        _maxZoomLevel = 5.0;
      }

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

  Future<void> _setZoom(double zoom) async {
    if (_controller == null) return;

    final clampedZoom = zoom.clamp(_minZoomLevel, _maxZoomLevel);
    await _controller!.setZoomLevel(clampedZoom);
    setState(() {
      _currentZoomLevel = clampedZoom;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                // Crosshairs and Scanner
                Scanner(),
                // Bottom gradient overlay
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: context.height * 0.35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.9),
                          Colors.black.withValues(alpha: 0.7),
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: Back(),
                ),
                // Zoom slider
                if (_controller != null && _controller!.value.isInitialized)
                  Positioned(
                    right: 20,
                    top: context.height * 0.3,
                    bottom: context.height * 0.35 + 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Zoom level indicator
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_currentZoomLevel.toStringAsFixed(1)}x',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        // Zoom slider
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 3,
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withValues(
                                  alpha: 0.3,
                                ),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                              child: Slider(
                                value: _currentZoomLevel,
                                min: _minZoomLevel,
                                max: _maxZoomLevel,
                                onChanged: (value) => _setZoom(value),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Bottom controls
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom + 20,
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
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Manual Upload Button
                      GestureDetector(
                        onTap: () {
                          context.push(ManualUploadScreen.routeName);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.upload_file_rounded,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'UPLOAD FROM GALLERY',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  letterSpacing: 1.0,
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
