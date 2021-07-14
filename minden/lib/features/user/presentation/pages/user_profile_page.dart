import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/features/user/presentation/pages/profile.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
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
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
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
            Align(
              alignment: Alignment.centerRight,
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
                    SvgPicture.asset('assets/images/user/edit.svg'),
                    SizedBox(
                      width: 9,
                    ),
                    Text(
                      '編集',
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
            )
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _ProfileInfo(
                  icon: data.icon,
                  bio: data.bio,
                  contractor: data.contractor,
                  name: data.name,
                  wallPaper: data.wallPaper),
              SizedBox(
                height: 45,
              ),
              _TagsList(
                tagsList: data.tags,
              ),
              SizedBox(
                height: 30,
              ),
              // あとで共通Componentを組み込む
              _SelectedPlantList(selectedPlantList: data.selectedPowerPlant)
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfo extends StatelessWidget {
  final String icon;
  final String contractor;
  final String name;
  final String bio;
  final String wallPaper;
  _ProfileInfo({
    required this.icon,
    required this.contractor,
    required this.name,
    required this.bio,
    required this.wallPaper,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 365,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 168,
              color: Color(0xFFFFFB92),
            ),
          ),
          Positioned(
            top: 118,
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFB92),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                ),
                SizedBox(
                  height: 19,
                ),
                Text(
                  contractor,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Color(0xFF7C7C7C),
                    fontSize: 14,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 22,
                ),
                Container(
                  width: 338,
                  child: Text(
                    bio,
                    textAlign: TextAlign.center,
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
            ),
          ),
        ],
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
      child: Text(
        '#$tag',
        style: TextStyle(
          color: Color(0xFF487254),
          fontSize: 12,
          fontFamily: 'NotoSansJP',
          fontWeight: FontWeight.w500,
        ),
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
            '選択中の電力会社',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w400,
              letterSpacing: calcLetterSpacing(letter: 4),
            ),
          ),
          SizedBox(
            height: 25,
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
