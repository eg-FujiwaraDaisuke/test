import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/login/presentation/pages/login_profile_bio_setting_page.dart';
import 'package:minden/features/login/presentation/pages/login_profile_name_setting_page.dart';

class LoginProfilePhotoSettingPage extends StatefulWidget {
  @override
  _LoginProfilePhotoSettingPageState createState() =>
      _LoginProfilePhotoSettingPageState();
}

class _LoginProfilePhotoSettingPageState
    extends State<LoginProfilePhotoSettingPage> {
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
      backgroundColor: Color(0xFFFAF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => _prev(),
          child: Center(
            child: SvgPicture.asset(
              'assets/images/common/leading_back.svg',
              fit: BoxFit.fill,
              width: 44.0,
              height: 44.0,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _next,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              child: Center(
                child: Text(
                  "スキップ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
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
                Botton(
                  onTap: _next,
                  text: i18nTranslate(context, 'profile_setting_next'),
                  size: BottonSize.S,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _next() {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => LoginProfileBioSettingPage(),
      settings: RouteSettings(name: "/login/profileBioSetting"),
    );
    Navigator.pushReplacement(context, route);
  }

  void _prev() {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => LoginProfileNameSettingPage(),
      settings: RouteSettings(name: "/login/profileNameSetting"),
    );
    Navigator.pushReplacement(context, route);
  }

  Widget _buildImage() {
    return _image == null
        ? Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/common/camera.svg',
                width: 32,
                height: 28,
              ),
            ),
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
