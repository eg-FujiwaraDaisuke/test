import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/login/presentation/pages/login_profile_tags_setting_page.dart';

class LoginProfileBioSettingPage extends StatefulWidget {
  @override
  _LoginProfileBioSettingPageState createState() =>
      _LoginProfileBioSettingPageState();
}

class _LoginProfileBioSettingPageState
    extends State<LoginProfileBioSettingPage> {
  String _inputBio = '';

  void _onInputChangedBio(value) {
    setState(() {
      _inputBio = value;
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
      builder: (context) => LoginProfileTagsSettingPage(),
      settings: RouteSettings(name: "/login/profileTagsSetting"),
    );
    Navigator.push(context, route);
  }

  void _prev() {
    Navigator.pop(context);
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
