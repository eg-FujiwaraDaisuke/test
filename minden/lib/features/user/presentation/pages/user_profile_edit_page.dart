import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
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
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  final route = NoAnimationMaterialPageRoute(
                    builder: (context) => UserProfilePage(),
                    settings: RouteSettings(name: "/user/profile"),
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
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 90,
                  height: 44,
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
                        '完了',
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
            )
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFF6F5EF),
          child: Column(
            children: [
              _ProfileImageEdit(
                icon: data.icon,
                wallPaper: data.wallPaper,
              ),
              SizedBox(
                height: 20,
              ),
              _ProfileNameEditForm(
                name: data.name,
                contractor: data.contractor,
              ),
              SizedBox(
                height: 20,
              ),
              _ProfileBioEditForm(
                bio: data.bio,
              ),
              SizedBox(
                height: 20,
              ),
              _TagsList(
                tagsList: data.tags,
              ),
            ],
          ),
        ),
      ),
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
    return Container(
      height: 218,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Stack(children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 168,
                  color: Color(0xFFFFFB92),
                ),
              ),
              Positioned(
                bottom: 9,
                right: 28,
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: SvgPicture.asset('assets/images/user/camera.svg'),
                  ),
                ),
              ),
            ]),
          ),
          Positioned(
            top: 118,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFB92),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFB92),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/user/camera.svg',
                        width: 15.87,
                        height: 14,
                        fit: BoxFit.none,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileNameEditForm extends StatelessWidget {
  final String contractor;
  final String name;

  const _ProfileNameEditForm({required this.name, required this.contractor})
      : super();

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
                fontSize: 14,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 6),
            height: 54,
            width: 339,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: TextFormField(
              initialValue: contractor,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/user/clear.svg',
                  ),
                  onPressed: () {},
                ),
              ),
              style: TextStyle(
                color: Color(0xFF7C7C7C),
                fontSize: 14,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w500,
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
    );
  }
}

class _TagsList extends StatelessWidget {
  final List<Tags> tagsList;
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
              Text(
                '大切にしていること',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                  letterSpacing: calcLetterSpacing(letter: 4),
                ),
              ),
              GestureDetector(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Color(0xFFEDCB50),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/user/add.svg',
                    fit: BoxFit.none,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 13,
              children: tagsList
                  .map((tag) => _TagsListItem(tag: tag.tagName))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsListItem extends StatelessWidget {
  final tag;
  const _TagsListItem({required this.tag}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFFFFB92),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$tag',
            style: TextStyle(
              color: Color(0xFF487254),
              fontSize: 12,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          GestureDetector(
            child: SvgPicture.asset(
              'assets/images/user/close.svg',
            ),
          ),
        ],
      ),
    );
  }
}
