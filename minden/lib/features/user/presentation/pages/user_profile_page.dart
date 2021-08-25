import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/features/user/presentation/pages/user_profile_edit_page.dart';
import '../../../../utile.dart';

class UserProfilePage extends StatelessWidget {
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
              builder: (context) => UserPage(),
              settings: RouteSettings(name: "/user"),
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
              final route = NoAnimationMaterialPageRoute(
                builder: (context) => UserProfileEditPage(),
                settings: RouteSettings(name: "/user/profile/edit"),
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
                  SvgPicture.asset('assets/images/user/edit.svg'),
                  SizedBox(
                    width: 9,
                  ),
                  Text(
                    i18nTranslate(context, 'user_edit'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 33,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -500,
                      child: Container(
                        width: 561,
                        height: 561,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFB92),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    _ProfileInfo(
                      icon: data.icon,
                      bio: data.bio,
                      name: data.name,
                      wallPaper: data.wallPaper,
                    )
                  ],
                ),
                SizedBox(
                  height: 43,
                ),
                _TagsList(
                  tagsList: data.tags,
                ),
                SizedBox(
                  height: 37,
                ),
                // // あとで共通Componentを組み込む
                _SelectedPlantList(selectedPlantList: data.selectedPowerPlant)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String icon;
  final String name;
  final String bio;
  final String wallPaper;
  _ProfileInfo({
    required this.icon,
    required this.name,
    required this.bio,
    required this.wallPaper,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
        SizedBox(
          height: 16,
        ),
        Text(
          name,
          style: TextStyle(
            color: Color(0xFF575292),
            fontSize: 18,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 35,
        ),
        Container(
          width: 338,
          child: Text(
            bio,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w400,
              letterSpacing: calcLetterSpacing(letter: 0.5),
              height: calcFontHeight(lineHeight: 22, fontSize: 12),
            ),
          ),
        )
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
      width: 338,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            i18nTranslate(context, 'user_important'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w700,
              letterSpacing: calcLetterSpacing(letter: 4),
            ),
          ),
          SizedBox(
            height: 4,
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

class _SelectedPlantList extends StatelessWidget {
  final selectedPlantList;
  const _SelectedPlantList({required this.selectedPlantList}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            i18nTranslate(context, 'user_select_plant'),
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w700,
              letterSpacing: calcLetterSpacing(letter: 4),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            child: Column(
              children: [_SelectedPlantListItem()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlantListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 352,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue,
      ),
    );
  }
}
