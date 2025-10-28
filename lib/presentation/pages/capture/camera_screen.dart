import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions.dart';
import '../../../core/toastification.dart';
import '../../providers/car/garage_provider.dart';
import '../../widgets/capture/scanner.dart';
import '../../widgets/shared/back.dart';
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
          // Camera Preview
          if (_isLoading)
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
                    GestureDetector(
                      onTap: _isUploading
                          ? null
                          : () async {
                              // capture image
                              try {
                                setState(() {
                                  _isUploading = true;
                                });
                                final XFile? file = await _controller?.takePicture();
                                if (file == null) {
                                  showAlertMessage(
                                    'Failed to capture image. Please try again.',
                                  );
                                  return;
                                }

                                // Use garage provider's scanCar method
                                final carSpotModel = await ref
                                    .read(garageProvider(null).notifier)
                                    .scanCar(file);

                                setState(() {
                                  _isUploading = false;
                                });
                                if (!context.mounted) return;
                                await context.push(
                                  ScanDeatilScreen.routeName,
                                  extra: carSpotModel,
                                );
                              } catch (e) {
                                debugPrint('Error capturing image: $e');
                                showAlertMessage('Error capturing image: $e');
                              } finally {
                                setState(() {
                                  _isUploading = false;
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
                        child: _isUploading
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  strokeCap: StrokeCap.round,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.black,
                              ),
                      ),
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
}
