import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minden/core/util/string_util.dart';

class CameraMock extends StatefulWidget {
  @override
  _CameraMockState createState() => _CameraMockState();
}

class _CameraMockState extends State<CameraMock> {
  File? _image;
  final _picker = ImagePicker();

  Future _getImage(ImageSource source) async {
    final PickedFile? pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      final File? cropped = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: 'crop',
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
        ),
        iosUiSettings: IOSUiSettings(minimumAspectRatio: 1.0),
      );

      setState(() {
        _image = cropped == null ? _image : cropped;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(children: [
          _buildImage(),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: () {
              _showImageSourceAction();
            },
          ),
        ]),
      ),
    ));
  }

  Widget _buildImage() {
    return _image == null
        ? Text('No image selected')
        : Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(_image!),
              ),
            ),
          );
  }

  void _showImageSourceAction() {
    Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  child: Text(i18nTranslate(context, 'image_select_gallery')),
                  onPressed: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                ),
                CupertinoActionSheetAction(
                  child: Text(i18nTranslate(context, 'image_select_camera')),
                  onPressed: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
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
                    _getImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  title: Text(i18nTranslate(context, 'image_select_camera')),
                  onTap: () {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
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
}
