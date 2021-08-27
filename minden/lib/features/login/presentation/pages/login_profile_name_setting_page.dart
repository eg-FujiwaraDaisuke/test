import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/login/presentation/pages/login_profile_icon_setting_page.dart';
import '../../../../utile.dart';

class LoginProfileNameSettingPage extends StatefulWidget {
  @override
  _LoginProfileNameSettingPageState createState() =>
      _LoginProfileNameSettingPageState();
}

class _LoginProfileNameSettingPageState
    extends State<LoginProfileNameSettingPage> {
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 38),
                Text(
                  i18nTranslate(context, 'profile_setting_input_name'),
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
    final route = MaterialPageRoute(
      builder: (context) => LoginProfileIconSettingPage(),
      settings: RouteSettings(name: "/login/profileIconSetting"),
    );
    Navigator.push(context, route);
  }

  void _prev() {
    Navigator.pop(context);
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
