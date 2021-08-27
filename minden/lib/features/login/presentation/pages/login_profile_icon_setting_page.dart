import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/image_picker_bottom_sheet/image_picker_bottom_sheet.dart';
import 'package:minden/features/login/presentation/pages/login_profile_bio_setting_page.dart';
import 'package:minden/features/login/presentation/pages/login_profile_name_setting_page.dart';

class LoginProfileIconSettingPage extends StatefulWidget {
  @override
  _LoginProfileIconSettingPageState createState() =>
      _LoginProfileIconSettingPageState();
}

class _LoginProfileIconSettingPageState
    extends State<LoginProfileIconSettingPage> {
  File? _image;

  void _setImage(File cropedImage) {
    setState(() {
      _image = cropedImage == null ? _image : cropedImage;
    });
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
                  i18nTranslate(context, 'skip_katakana'),
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
                  i18nTranslate(context, 'profile_setting_icon'),
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
                    ImagePickerBottomSheet.show(
                        context: context,
                        imageHandler: _setImage,
                        cropStyle: CropStyle.circle);
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
    final route = MaterialPageRoute(
      builder: (context) => LoginProfileBioSettingPage(),
      settings: RouteSettings(name: "/login/profileBioSetting"),
    );
    Navigator.push(context, route);
  }

  void _prev() {
    Navigator.pop(context);
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
}
