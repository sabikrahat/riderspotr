import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Helper class to store a text region with its license plate likelihood score
class _ScoredTextRegion {
  final String text;
  final Rect boundingBox;
  final double score;

  _ScoredTextRegion({
    required this.text,
    required this.boundingBox,
    required this.score,
  });
}

/// Result from ML detection containing the blurred image and detection metadata
class MLDetectionResult {
  final XFile blurredImage;
  final String? numberPlate;
  final bool faceDetected;

  MLDetectionResult({
    required this.blurredImage,
    this.numberPlate,
    required this.faceDetected,
  });
}

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
  /// Returns MLDetectionResult with blurred image and detection metadata
  Future<MLDetectionResult> detectAndBlurSensitiveContent(
    XFile imageFile,
  ) async {
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
        return MLDetectionResult(
          blurredImage: imageFile,
          numberPlate: null,
          faceDetected: false,
        );
      }

      // Create a copy of the image to work with
      img.Image processedImage = img.Image.from(originalImage);

      // Step 1: Detect and blur text (license plates)
      final textDetectionResult = await _detectText(inputImage);
      final textRegions = textDetectionResult['regions'] as List<Rect>;
      final detectedPlate = textDetectionResult['plate_text'] as String?;

      processedImage = _blurRegions(
        processedImage,
        originalImage,
        textRegions,
        'text',
      );

      // Step 2: Detect and blur faces
      final faceRegions = await _detectFaces(inputImage);
      final faceDetected = faceRegions.isNotEmpty;

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
      debugPrint(
        'Detected plate: $detectedPlate | Face detected: $faceDetected',
      );

      return MLDetectionResult(
        blurredImage: XFile(tempPath),
        numberPlate: detectedPlate,
        faceDetected: faceDetected,
      );
    } catch (e, stackTrace) {
      debugPrint('Error in ML detection and blur: $e');
      debugPrint('Stack trace: $stackTrace');
      // Return original image on error with no detections
      return MLDetectionResult(
        blurredImage: imageFile,
        numberPlate: null,
        faceDetected: false,
      );
    }
  }

  /// Detects text in the image and returns bounding boxes and detected plate text
  /// Uses scoring to identify the most likely license plate region
  Future<Map<String, dynamic>> _detectText(InputImage inputImage) async {
    try {
      final RecognizedText recognizedText = await _textRecognizer.processImage(
        inputImage,
      );

      debugPrint('Detected ${recognizedText.blocks.length} text blocks');

      // Collect all text lines with their scores
      List<_ScoredTextRegion> scoredRegions = [];

      for (final block in recognizedText.blocks) {
        for (final line in block.lines) {
          final score = _scoreLicensePlateLikelihood(line, inputImage);
          scoredRegions.add(
            _ScoredTextRegion(
              text: line.text,
              boundingBox: line.boundingBox,
              score: score,
            ),
          );

          debugPrint(
            'Text: "${line.text}" | Score: ${score.toStringAsFixed(2)}',
          );
        }
      }

      if (scoredRegions.isEmpty) {
        debugPrint('No text regions found');
        return {'regions': <Rect>[], 'plate_text': null};
      }

      // Sort by score (highest first)
      scoredRegions.sort((a, b) => b.score.compareTo(a.score));

      // Get the highest scoring region
      final bestCandidate = scoredRegions.first;

      debugPrint(
        '🎯 Selected license plate: "${bestCandidate.text}" with score ${bestCandidate.score.toStringAsFixed(2)}',
      );

      // Only return the best candidate if it has a reasonable score
      if (bestCandidate.score > 0.3) {
        return {
          'regions': [bestCandidate.boundingBox],
          'plate_text': bestCandidate.text,
        };
      } else {
        debugPrint(
          '⚠️ Best score too low (${bestCandidate.score.toStringAsFixed(2)}), skipping blur',
        );
        return {'regions': <Rect>[], 'plate_text': null};
      }
    } catch (e) {
      debugPrint('Error detecting text: $e');
      return {'regions': <Rect>[], 'plate_text': null};
    }
  }

  /// Scores how likely a text line is to be a license plate (0.0 to 1.0)
  double _scoreLicensePlateLikelihood(TextLine line, InputImage inputImage) {
    final text = line.text.replaceAll(' ', ''); // Remove spaces
    final box = line.boundingBox;
    double score = 0.0;

    // Factor 1: Character count (4-9 is ideal)
    if (text.length >= 4 && text.length <= 9) {
      // Perfect range
      score += 0.25;
      if (text.length >= 5 && text.length <= 8) {
        // Most common range, extra bonus
        score += 0.05;
      }
    } else if (text.length >= 3 && text.length <= 11) {
      // Acceptable but not ideal
      score += 0.10;
    }
    // else: no points for very short or very long text

    // Factor 2: Aspect ratio (license plates are wide and rectangular)
    final aspectRatio = box.width / box.height;
    if (aspectRatio >= 2.0 && aspectRatio <= 5.0) {
      // Ideal aspect ratio for plates
      score += 0.25;
    } else if (aspectRatio >= 1.5 && aspectRatio <= 6.0) {
      // Acceptable aspect ratio
      score += 0.15;
    }

    // Factor 3: Has both letters AND numbers (strong indicator)
    final hasLetters = RegExp(r'[A-Z]', caseSensitive: false).hasMatch(text);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(text);
    if (hasLetters && hasNumbers) {
      score += 0.20;
    } else if (hasLetters || hasNumbers) {
      // At least has some alphanumeric
      score += 0.05;
    }

    // Factor 4: Position in image (plates usually in lower 2/3 of image)
    final imageHeight = inputImage.metadata?.size.height ?? 1000;
    final centerY = box.top + (box.height / 2);
    final relativePosition = centerY / imageHeight;

    if (relativePosition >= 0.4 && relativePosition <= 0.9) {
      // Lower portion of image - where plates usually are
      score += 0.10;
    } else if (relativePosition >= 0.3) {
      // Still acceptable
      score += 0.05;
    }

    // Factor 5: Character density (plates pack characters closely)
    final characterDensity = text.length / box.width;
    if (characterDensity >= 0.015 && characterDensity <= 0.1) {
      score += 0.10;
    } else if (characterDensity >= 0.01) {
      score += 0.05;
    }

    // Factor 6: Minimum size (plates shouldn't be tiny)
    if (box.width >= 80 && box.height >= 20) {
      score += 0.10;
    } else if (box.width >= 50 && box.height >= 15) {
      score += 0.05;
    }

    return score.clamp(0.0, 1.0);
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
