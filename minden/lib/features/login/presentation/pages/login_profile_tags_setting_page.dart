import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/botton_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/login/presentation/pages/login_profile_photo_setting_page.dart';
import 'package:minden/features/common/widget/tag/important_tags.dart';
import 'package:minden/features/login/presentation/pages/login_profile_tags_decision_page.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';
import 'package:minden/utile.dart';

class LoginProfileTagsSettingPage extends StatefulWidget {
  @override
  _LoginProfileTagsSettingPageState createState() =>
      _LoginProfileTagsSettingPageState();
}

class _LoginProfileTagsSettingPageState
    extends State<LoginProfileTagsSettingPage> {
  List<Tag> _selectedTags = [];

  void _onSelectTag(Tag tag) {
    if (_selectedTags.contains(tag)) {
      setState(() {
        _selectedTags.remove(tag);
      });
    } else {
      setState(() {
        _selectedTags.add(tag);
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 38),
                Text(
                  'タグを選択',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF575292),
                  ),
                ),
                SizedBox(height: 19),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'あなたが',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: '大切にしていること',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF8C00),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: 'を\n',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: '選択してください（何個でも選択タグ可）',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7),
                Text(
                  '大切にしていることのタグを設定すると\nあなたと似たユーザーを見つけやすくなります',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF787877),
                    height: calcFontHeight(fontSize: 12, lineHeight: 17.38),
                  ),
                ),
                SizedBox(height: 15),
                Column(
                  children: importantTags
                      .map((e) => _TagsList(
                            tagsList: e.tags,
                            onSelect: _onSelectTag,
                            selectedTags: _selectedTags,
                            color: e.color,
                            title: e.title,
                          ))
                      .toList(),
                ),
                SizedBox(height: 28),
                Botton(
                  onTap: () => {_next()},
                  text: i18nTranslate(context, 'profile_setting_next'),
                  size: BottonSize.S,
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _prev() {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => LoginProfilePhotoSettingPage(),
      settings: RouteSettings(name: "/login/profilePhotoSetting"),
    );
    Navigator.pushReplacement(context, route);
  }

  void _next() {
    final route = NoAnimationMaterialPageRoute(
      builder: (context) => LoginProfileTagsDecisionPage(),
      settings: RouteSettings(name: "/login/profileTagsDecision"),
    );
    Navigator.pushReplacement(context, route);
  }
}

class _TagsList extends StatefulWidget {
  final List<Tag> tagsList;
  final List<Tag> selectedTags;
  final Function onSelect;
  final Color color;
  final String title;
  const _TagsList(
      {required this.tagsList,
      required this.onSelect,
      required this.selectedTags,
      required this.color,
      required this.title})
      : super();

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<_TagsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13), topRight: Radius.circular(13)),
              color: widget.color,
            ),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF787877),
                ),
              ),
            ),
          ),
          Container(
            width: 329,
            height: 2,
            color: widget.color,
          ),
          Container(
            width: 338,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Colors.white,
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 10,
              children: widget.tagsList
                  .map(
                    (tag) => ImportantTagListItem(
                      tag: tag,
                      onSelect: widget.onSelect,
                      selectedColor: widget.color,
                      isSelected: widget.selectedTags.contains(tag),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
