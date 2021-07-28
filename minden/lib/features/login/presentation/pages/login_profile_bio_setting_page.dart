import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/pages/login_profile_photo_setting_page.dart';
import 'package:minden/features/login/presentation/pages/login_profile_tags_setting_page.dart';

class LoginProfileBioSetting extends StatefulWidget {
  @override
  _LoginProfileBioSettingState createState() => _LoginProfileBioSettingState();
}

class _LoginProfileBioSettingState extends State<LoginProfileBioSetting> {
  String _inputBio = '';

  void _onInputChangedBio(value) {
    setState(() {
      _inputBio = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5EF),
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
                    builder: (context) => LoginProfilePhotoSetting(),
                    settings: RouteSettings(name: "/login/profilePhotoSetting"),
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
                  i18nTranslate(context, 'profile_setting_bio'),
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF787877),
                  ),
                ),
                SizedBox(height: 38),
                BioInput(onChanged: _onInputChangedBio),
                SizedBox(height: 126),
                GestureDetector(
                  onTap: () {
                    // TODO 設定を完了する
                    final route = NoAnimationMaterialPageRoute(
                      builder: (context) => LoginProfileTagsSetting(),
                      settings:
                          RouteSettings(name: "/login/profileTagsSetting"),
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
}

class BioInput extends StatefulWidget {
  final Function onChanged;

  const BioInput({
    required this.onChanged,
  }) : super();

  @override
  _BioInputState createState() => _BioInputState();
}

class _BioInputState extends State<BioInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        height: 110,
        width: 339,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          initialValue: '',
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          style: TextStyle(
            color: Color(0xFF7C7C7C),
            fontSize: 12,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
