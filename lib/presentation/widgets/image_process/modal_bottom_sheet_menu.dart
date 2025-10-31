import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gap/gap.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ridespotr/core/extensions.dart';

import 'take_image_option.dart';

Future<XFile?> modalBottomSheetMenu(
  BuildContext context, {
  bool isCircle = false,
  List<CropAspectRatioPreset>? aspectRatioPresets,
  int imageQuality = 100,
  List<String>? allowedExtensions,
}) async {
  return showModalBottomSheet(
    elevation: 2.0,
    backgroundColor: context.theme.scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    context: context,
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            'Choose an Option',
            style: context.theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.photo_camera, color: Colors.white),
          title: Text(
            'Capture Image With Camera',
            style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          onTap: () async {
            // Checking Permission
            final status = await Permission.camera.status;
            debugPrint('Camera Permission Status: $status');
            if (!status.isGranted) {
              debugPrint('Requesting Camera Permission');
              await Permission.camera.request();
              return;
            }
            //
            if (!context.mounted) return;
            await takeImageOption(
              context,
              ImageSource.camera,
              isCircle: isCircle,
              aspectRatioPresets: aspectRatioPresets,
              imageQuality: imageQuality,
              allowedExtensions: allowedExtensions,
            ).then((file) async {
              if (file == null) return;
              if (!context.mounted) return;
              Navigator.of(context).pop(file);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_library, color: Colors.white),
          title: Text(
            'Select Image From Gallery',
            style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          onTap: () async {
            // Checking Permission
            final status = await Permission.photos.status;
            debugPrint('Gallery Permission Status: $status');
            if (status.isPermanentlyDenied) {
              debugPrint('Permission Denied permanently. Showing error popup!');
              EasyLoading.showError('Permission Denied permanently');
              await Permission.photos.request();
              return;
            }
            if (!status.isGranted) {
              debugPrint('Requesting Gallery Permission');
              await Permission.photos.request();
              return;
            }
            //
            if (!context.mounted) return;
            await takeImageOption(
              context,
              ImageSource.gallery,
              isCircle: isCircle,
              aspectRatioPresets: aspectRatioPresets,
              imageQuality: imageQuality,
              allowedExtensions: allowedExtensions,
            ).then((file) async {
              if (file == null) return;
              if (!context.mounted) return;
              Navigator.of(context).pop(file);
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.cancel, color: Colors.white),
          title: Text(
            'Cancel',
            style: context.textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          onTap: () => Navigator.of(context).pop(null),
        ),
        Gap(130),
      ],
    ),
  );
}
