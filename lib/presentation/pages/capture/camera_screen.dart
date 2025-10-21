import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/toastification.dart';
import '../../../models/car/car_spot_model.dart';

import '../../../core/extensions.dart';
import '../../../services/capture/capture.dart';
import '../../widgets/capture/scanner.dart';
import '../../widgets/shared/back.dart';
import 'scan_deatil_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  static const String routeName = '/camera';

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isLoading = true;

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
                      onTap: () async {
                        // capture image
                        try {
                          EasyLoading.show();
                          // final XFile? file = await _controller?.takePicture();
                          // TODO: Replace the dummy imagepciker with the actual capture data.
                          final XFile? file = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (file == null) {
                            showAlertMessage('Failed to capture image. Please try again.');
                            return;
                          }
                          final url = await CaptureService().uploadFileToStorage(file);
                          if (url == null) {
                            showAlertMessage('Failed to upload image. Please try again.');
                            return;
                          }
                          debugPrint('Image uploaded to: $url');

                          final res = await CaptureService().uploadToEdgeFunction(url);
                          debugPrint('Edge function upload result: $res');
                          final carSpotModel = CarSpotModel.fromJson(res['data']);
                          EasyLoading.dismiss();
                          if (!context.mounted) return;
                          await context.push(ScanDeatilScreen.routeName, extra: carSpotModel);
                        } catch (e) {
                          debugPrint('Error capturing image: $e');
                          showAlertMessage('Error capturing image: $e');
                        } finally {
                          EasyLoading.dismiss();
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
                    const SizedBox(height: 12),
                    Text(
                      'Tap to capture',
                      style: context.textTheme.bodyMedium?.copyWith(color: Colors.white70),
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
