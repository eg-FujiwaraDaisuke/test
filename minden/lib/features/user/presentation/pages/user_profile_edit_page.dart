import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/user_profile_page.dart';
import '../../../../utile.dart';

class UserProfileEditPage extends StatelessWidget {
  // 確認用仮データ
  final data = ProfileDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            final route = NoAnimationMaterialPageRoute(
              builder: (context) => UserProfilePage(),
              settings: RouteSettings(name: "/user/profile"),
            );
            Navigator.pushReplacement(context, route);
          },
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
            onTap: () {
              // TODO ここでデータの保存をする
              final route = NoAnimationMaterialPageRoute(
                builder: (context) => UserProfilePage(),
                settings: RouteSettings(name: "/user/profile"),
              );
              Navigator.pushReplacement(context, route);
            },
            child: Container(
              width: 90,
              height: 44,
              margin: EdgeInsets.only(right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/user/check.svg'),
                  SizedBox(
                    width: 10.5,
                  ),
                  Text(
                    i18nTranslate(context, 'user_edit_complete'),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xFFF6F5EF),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 33,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: -500,
                        child: _ProfileWallPaperEdit(),
                      ),
                      _ProfileImageEdit(
                        icon: data.icon,
                        wallPaper: data.wallPaper,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  _ProfileNameEditForm(
                    name: data.name,
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  _ProfileBioEditForm(
                    bio: data.bio,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  _TagsList(
                    tagsList: data.tags,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileWallPaperEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 561,
          height: 561,
          decoration: BoxDecoration(
            color: Color(0xFFFFFB92),
            shape: BoxShape.circle,
          ),
        ),
        Positioned(
          bottom: 43,
          right: 140,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // TODO 写真選択or撮影
              // TODO onTapが動作しない
              print('写真選択or撮影');
            },
            child: Center(
              child: SvgPicture.asset(
                'assets/images/user/camera.svg',
                width: 15,
                height: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileImageEdit extends StatelessWidget {
  final String icon;
  final String wallPaper;
  _ProfileImageEdit({
    required this.icon,
    required this.wallPaper,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          child: Container(
            width: 99,
            height: 99,
            decoration: BoxDecoration(
              color: Color(0xFFFF8C00),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 93,
                height: 93,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFB92),
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // TODO 写真選択or撮影
              print('写真選択or撮影');
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Color(0xFFFFFB92),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/user/camera.svg',
                  width: 15,
                  height: 14,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _ProfileNameEditForm extends StatelessWidget {
  final String name;

  const _ProfileNameEditForm({
    required this.name,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 54,
            width: 339,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: TextFormField(
              initialValue: name,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 18,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileBioEditForm extends StatelessWidget {
  final bio;
  const _ProfileBioEditForm({required this.bio}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '自己紹介',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Form(
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
              initialValue: bio,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 12,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w400,
                letterSpacing: calcLetterSpacing(letter: 0.5),
                height: calcFontHeight(lineHeight: 22.08, fontSize: 12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TagsList extends StatelessWidget {
  final List<Tag> tagsList;
  const _TagsList({required this.tagsList}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  // TODO tagの追加
                },
                child: Text(
                  i18nTranslate(context, 'user_important'),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    letterSpacing: calcLetterSpacing(letter: 4),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFFF8C00),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/user/add.svg',
                      color: Color(0xFFFF8C00),
                      width: 7,
                      height: 7,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 5,
              runSpacing: 10,
              children: tagsList
                  .map((tag) => ImportantTagListItem(
                        tag: tag,
                        onSelect: () {},
                        isSelected: true,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
