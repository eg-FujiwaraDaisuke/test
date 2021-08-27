import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minden/core/util/string_util.dart';

class ImagePickerBottomSheet {
  static void show({
    required BuildContext context,
    required Function(File file) imageHandler,
    CropStyle cropStyle = CropStyle.rectangle,
    int clipWidth = 700,
    int clipHeight = 700,
  }) {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(i18nTranslate(context, 'image_select_gallery')),
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(context, ImageSource.gallery, imageHandler,
                        clipWidth, clipHeight, cropStyle);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(i18nTranslate(context, 'image_select_camera')),
                  onPressed: () {
                    Navigator.pop(context);
                    _pickImage(context, ImageSource.camera, imageHandler,
                        clipWidth, clipHeight, cropStyle);
                  },
                )
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(i18nTranslate(context, 'cancel')),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          )
        : showModalBottomSheet(
            context: context,
            builder: (context) => Wrap(
              children: [
                ListTile(
                  title: Text(i18nTranslate(context, 'image_select_gallery')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(context, ImageSource.gallery, imageHandler,
                        clipWidth, clipHeight, cropStyle);
                  },
                ),
                ListTile(
                  title: Text(i18nTranslate(context, 'image_select_camera')),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(
                      context,
                      ImageSource.camera,
                      imageHandler,
                      clipWidth,
                      clipHeight,
                      cropStyle,
                    );
                  },
                ),
                ListTile(
                  title: Text(i18nTranslate(context, 'cancel')),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }

  static Future<void> _pickImage(
    BuildContext context,
    ImageSource source,
    Function(File file) fileHandler,
    int clipWidth,
    int clipHeight,
    CropStyle cropStyle,
  ) async {
    final mediaFile = await ImagePicker.platform.getImage(source: source);
    if (mediaFile == null) {
      return;
    } else {
      final File? cropped = await ImageCropper.cropImage(
        cropStyle: cropStyle,
        sourcePath: mediaFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: clipWidth,
        maxHeight: clipHeight,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          statusBarColor: Colors.black,
          toolbarTitle: '画像を編集',
          backgroundColor: Colors.black,
        ),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0),
      );

      fileHandler(cropped!);
    }
  }
}
