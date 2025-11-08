import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MLService {
  final TextRecognizer _textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
      enableLandmarks: false,
      enableTracking: false,
    ),
  );

  /// Detects and blurs text (license plates) and faces in an image
  /// Returns a new XFile with the blurred image
  Future<XFile> detectAndBlurSensitiveContent(XFile imageFile) async {
    try {
      debugPrint('Starting ML detection and blur process...');

      // Create InputImage from XFile
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // Load the image for processing
      final File file = File(imageFile.path);
      final imageBytes = await file.readAsBytes();
      final img.Image? originalImage = img.decodeImage(imageBytes);

      if (originalImage == null) {
        debugPrint('Failed to decode image');
        return imageFile;
      }

      // Create a copy of the image to work with
      img.Image processedImage = img.Image.from(originalImage);

      // Step 1: Detect and blur text (license plates)
      final textRegions = await _detectText(inputImage);
      processedImage = _blurRegions(
        processedImage,
        originalImage,
        textRegions,
        'text',
      );

      // Step 2: Detect and blur faces
      final faceRegions = await _detectFaces(inputImage);
      processedImage = _blurRegions(
        processedImage,
        originalImage,
        faceRegions,
        'face',
      );

      // Save the processed image to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_blurred${path.extension(imageFile.path)}',
      );

      // Encode and save the image
      final encodedImage = img.encodeJpg(processedImage, quality: 95);
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(encodedImage);

      debugPrint('Saved blurred image to: $tempPath');

      return XFile(tempPath);
    } catch (e, stackTrace) {
      debugPrint('Error in ML detection and blur: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return original image on error
      return imageFile;
    }
  }

  /// Detects text in the image and returns bounding boxes
  Future<List<Rect>> _detectText(InputImage inputImage) async {
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      debugPrint('Detected ${recognizedText.blocks.length} text blocks');

      return recognizedText.blocks.map((block) => block.boundingBox).toList();
    } catch (e) {
      debugPrint('Error detecting text: $e');
      return [];
    }
  }

  /// Detects faces in the image and returns bounding boxes
  Future<List<Rect>> _detectFaces(InputImage inputImage) async {
    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      debugPrint('Detected ${faces.length} faces');

      return faces.map((face) => face.boundingBox).toList();
    } catch (e) {
      debugPrint('Error detecting faces: $e');
      return [];
    }
  }

  /// Blurs a list of regions in the image
  img.Image _blurRegions(
    img.Image processedImage,
    img.Image originalImage,
    List<Rect> regions,
    String type,
  ) {
    if (regions.isEmpty) {
      debugPrint('No $type regions to blur');
      return processedImage;
    }

    int blurredCount = 0;
    for (final rect in regions) {
      // Add some padding around the region
      const padding = 10;
      final x = (rect.left - padding).clamp(0, originalImage.width - 1).toInt();
      final y = (rect.top - padding).clamp(0, originalImage.height - 1).toInt();
      final width = (rect.width + padding * 2)
          .clamp(1, originalImage.width - x)
          .toInt();
      final height = (rect.height + padding * 2)
          .clamp(1, originalImage.height - y)
          .toInt();

      // Extract the region to blur
      final region = img.copyCrop(
        originalImage,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Apply heavy blur to the region
      final blurredRegion = img.gaussianBlur(region, radius: 20);

      // Composite the blurred region back onto the processed image
      img.compositeImage(
        processedImage,
        blurredRegion,
        dstX: x,
        dstY: y,
      );

      blurredCount++;
      debugPrint('Blurred $type region: ($x, $y, $width, $height)');
    }

    debugPrint('Blurred $blurredCount $type regions');
    return processedImage;
  }

  /// Clean up resources
  void dispose() {
    _textRecognizer.close();
    _faceDetector.close();
  }
}
