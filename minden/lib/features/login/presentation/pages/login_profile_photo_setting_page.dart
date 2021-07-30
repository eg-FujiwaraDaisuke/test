import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/pages/login_profile_bio_setting_page.dart';
import 'package:minden/features/login/presentation/pages/login_profile_name_setting_page.dart';

class LoginProfilePhotoSetting extends StatefulWidget {
  @override
  _LoginProfilePhotoSettingState createState() =>
      _LoginProfilePhotoSettingState();
}

class _LoginProfilePhotoSettingState extends State<LoginProfilePhotoSetting> {
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
      backgroundColor: Color(0xFFFAF9E5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  final route = NoAnimationMaterialPageRoute(
                    builder: (context) => LoginProfileNameSetting(),
                    settings: RouteSettings(name: "/login/profileNameSetting"),
                  );
                  Navigator.pushReplacement(context, route);
                },
                child: Container(
                  width: 44.0,
                  height: 44.0,
                  child: SvgPicture.asset(
                    'assets/images/common/leading_back.svg',
                    fit: BoxFit.fill,
                    width: 44.0,
                    height: 44.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 38),
                Text(
                  'プロフィール写真を設定',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF787877),
                  ),
                ),
                SizedBox(height: 38),
                GestureDetector(
                  onTap: () {
                    _showImageSourceAction();
                  },
                  child: _buildImage(),
                ),
                SizedBox(height: 182),
                GestureDetector(
                  onTap: () {
                    // TODO 設定を完了する
                    final route = NoAnimationMaterialPageRoute(
                      builder: (context) => LoginProfileBioSetting(),
                      settings: RouteSettings(name: "/login/profileBioSetting"),
                    );
                    Navigator.pushReplacement(context, route);
                  },
                  child: Container(
                    width: 180,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF8C00),
                      borderRadius: BorderRadius.all(
                        Radius.circular(27),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        i18nTranslate(context, 'profile_setting_next'),
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return _image == null
        ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFFEFF92),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset('assets/images/common/camera.svg',
                color: Colors.white,
                width: 27,
                height: 24,
                fit: BoxFit.scaleDown),
          )
        : Container(
            width: 150,
            height: 150,
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
