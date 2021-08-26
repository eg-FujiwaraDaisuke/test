import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/common/widget/tag/important_tags.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/login/presentation/pages/login_profile_tags_setting_page.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';

class LoginProfileTagsDecisionPage extends StatelessWidget {
  List<Tag> _selectedTags = [
    Tag(tagId: 'タグID', tagName: 'エコ'),
    Tag(tagId: 'タグID', tagName: 'サステナブルコーヒー'),
    Tag(tagId: 'タグID', tagName: '地方創生'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: GestureDetector(
          onTap: () => _prev(context),
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
            children: [
              SizedBox(height: 38),
              Text(
                i18nTranslate(context, 'profile_decision_tag'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF575292),
                ),
              ),
              SizedBox(height: 43),
              Text(
                i18nTranslate(context, 'profile_decision_tag_set'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF787877),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 338,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white,
                ),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 5,
                  runSpacing: 10,
                  children: _selectedTags
                      .map(
                        (tag) => ImportantTagListItem(
                          tag: tag,
                          onSelect: () {},
                          isSelected: true,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 112),
              Botton(
                onTap: () => {_decide(context)},
                text: i18nTranslate(context, 'decide'),
                size: BottonSize.S,
              ),
              SizedBox(height: 19),
              GestureDetector(
                onTap: () => _prev(context),
                child: Text(
                  i18nTranslate(context, 'cancel_katakana'),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF787877),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  void _prev(BuildContext context) {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => LoginProfileTagsSettingPage(),
      settings: RouteSettings(name: "/login/profileTagsSetting"),
    );
    Navigator.pushReplacement(context, route);
  }

  void _decide(BuildContext context) {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => HomePage(),
      settings: RouteSettings(name: "/home"),
    );
    Navigator.pushReplacement(context, route);
  }
}
