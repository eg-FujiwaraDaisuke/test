import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/pages/login_profile_photo_setting_page.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';
import 'package:minden/utile.dart';

class LoginProfileTagsSetting extends StatefulWidget {
  @override
  _LoginProfileTagsSettingState createState() =>
      _LoginProfileTagsSettingState();
}

class _LoginProfileTagsSettingState extends State<LoginProfileTagsSetting> {
  //TODO あとで差し替える
  final List<Tag> _tagsDamyData = [
    Tag(tagId: 'タグID', tagName: '使い捨てしません'),
    Tag(tagId: 'タグID', tagName: '環境負荷ゼロ'),
    Tag(tagId: 'タグID', tagName: '地産地消'),
    Tag(tagId: 'タグID', tagName: 'フェアトレード'),
    Tag(tagId: 'タグID', tagName: 'エコ'),
    Tag(tagId: 'タグID', tagName: 'プラスチックフリー'),
    Tag(tagId: 'タグID', tagName: 'シェアリングエコノミー'),
    Tag(tagId: 'タグID', tagName: '無農薬野菜好き'),
    Tag(tagId: 'タグID', tagName: 'サステイナブルコーヒー好き'),
    Tag(tagId: 'タグID', tagName: 'フードロスを減らす'),
    Tag(tagId: 'タグID', tagName: 'リサイクルしよう'),
    Tag(tagId: 'タグID', tagName: '環境を守れる経済活動'),
    Tag(tagId: 'タグID', tagName: '子供たちの未来のために'),
    Tag(tagId: 'タグID', tagName: '生物多様性'),
    Tag(tagId: 'タグID', tagName: 'バリアフリー'),
    Tag(tagId: 'タグID', tagName: 'ロハス'),
    Tag(tagId: 'タグID', tagName: '地元を愛する'),
    Tag(tagId: 'タグID', tagName: '持続可能な開発'),
    Tag(tagId: 'タグID', tagName: '地方創生'),
  ];

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
      backgroundColor: Color(0xFFFAF9E5),
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
                  i18nTranslate(context, 'profile_setting_select_tags'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF787877),
                    height: calcFontHeight(lineHeight: 30, fontSize: 18),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  i18nTranslate(context, 'profile_setting_select_tags_any_num'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF787877),
                  ),
                ),
                SizedBox(height: 31),
                _TagsList(
                  tagsList: _tagsDamyData,
                  onSelect: _onSelectTag,
                  selectedTags: _selectedTags,
                ),
                SizedBox(height: 78),
                GestureDetector(
                  onTap: () {
                    // TODO 設定を完了する
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
                        i18nTranslate(context, 'profile_setting_complete'),
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

class _TagsList extends StatefulWidget {
  final List<Tag> tagsList;
  final List<Tag> selectedTags;
  final Function onSelect;
  const _TagsList(
      {required this.tagsList,
      required this.onSelect,
      required this.selectedTags})
      : super();

  @override
  _TagsListState createState() => _TagsListState();
}

class _TagsListState extends State<_TagsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 10,
              children: widget.tagsList
                  .map((tag) => _TagsListItem(
                      tag: tag,
                      onSelect: widget.onSelect,
                      isSelected: widget.selectedTags.contains(tag)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsListItem extends StatefulWidget {
  final Tag tag;
  final Function onSelect;
  final bool isSelected;
  const _TagsListItem(
      {required this.tag, required this.onSelect, required this.isSelected})
      : super();

  @override
  _TagsListItemState createState() => _TagsListItemState();
}

class _TagsListItemState extends State<_TagsListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.tag);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: Color(0xFFE2E2E2),
              width: 1,
            ),
            color: widget.isSelected ? Colors.yellow : Color(0xFFF6F5EF)),
        child: Text(
          '#${widget.tag.tagName}',
          style: TextStyle(
            color: Color(0xFF4F4F4F),
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
