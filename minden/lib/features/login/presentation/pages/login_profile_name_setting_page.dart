import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/login/presentation/pages/login_profile_photo_setting_page.dart';
import '../../../../utile.dart';

class LoginProfileNameSetting extends StatefulWidget {
  @override
  _LoginProfileNameSettingState createState() =>
      _LoginProfileNameSettingState();
}

class _LoginProfileNameSettingState extends State<LoginProfileNameSetting> {
  String _inputName = '';

  void _onInputChangedName(value) {
    setState(() {
      _inputName = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F2),
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 38),
                Text(
                  'ユーザーネームを入力',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF787877),
                  ),
                ),
                SizedBox(height: 38),
                _NameInput(onChanged: _onInputChangedName),
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
      builder: (context) => LoginProfilePhotoSetting(),
      settings: RouteSettings(name: "/login/profilePhotoSetting"),
    );
    Navigator.pushReplacement(context, route);
  }
}

class _NameInput extends StatefulWidget {
  final Function onChanged;

  const _NameInput({
    required this.onChanged,
  }) : super();

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<_NameInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 339,
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            onChanged: (value) {
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              fillColor: Colors.white,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 15,
              ),
            ),
            style: TextStyle(
              fontSize: 17.0,
              color: Color(0xFF000000),
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
