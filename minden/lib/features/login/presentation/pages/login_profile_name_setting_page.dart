import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
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
                  'ユーザーネームを入力',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF787877),
                  ),
                ),
                SizedBox(height: 38),
                NameInput(onChanged: _onInputChangedName),
                SizedBox(height: 182),
                GestureDetector(
                  onTap: () {
                    // TODO 設定を完了する
                    final route = NoAnimationMaterialPageRoute(
                      builder: (context) => LoginProfilePhotoSetting(),
                      settings:
                          RouteSettings(name: "/login/profilePhotoSetting"),
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
                        '次へ',
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

class NameInput extends StatefulWidget {
  final Function onChanged;

  const NameInput({
    required this.onChanged,
  }) : super();

  @override
  _NameInputState createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18),
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
