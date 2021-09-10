import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/common/widget/tag/important_tags.dart';
import 'package:minden/features/profile_setting/pages/profile_setting_tags_decision_page.dart';

import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/utile.dart';

class ProfileSettingTagsPage extends StatefulWidget {
  @override
  _ProfileSettingTagsPageState createState() => _ProfileSettingTagsPageState();
}

class _ProfileSettingTagsPageState extends State<ProfileSettingTagsPage> {
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
                  i18nTranslate(context, 'profile_setting_select_tag'),
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
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_you'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(context,
                            'profile_setting_tag_description_important'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF8C00),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_wo'),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF787877),
                          height: calcFontHeight(lineHeight: 30, fontSize: 18),
                        ),
                      ),
                      TextSpan(
                        text: i18nTranslate(
                            context, 'profile_setting_tag_description_select'),
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
                  i18nTranslate(
                      context, 'profile_setting_important_tag_find_user'),
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
                _selectedTags.length == 0
                    ? Button(
                        onTap: () => {},
                        text: i18nTranslate(context, 'profile_setting_next'),
                        size: ButtonSize.S,
                        isActive: false,
                      )
                    : Button(
                        onTap: () => {_next()},
                        text: i18nTranslate(context, 'profile_setting_next'),
                        size: ButtonSize.S,
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
    Navigator.pop(context);
  }

  void _next() {
    final route = MaterialPageRoute(
      builder: (context) => ProfileSettingTagsDecisionPage(),
      settings: RouteSettings(name: "/profileSetting/tagsDecision"),
    );
    Navigator.push(context, route);
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
