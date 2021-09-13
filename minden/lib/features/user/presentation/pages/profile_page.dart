import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/important_tag_list_item.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_painter.dart';

import '../../../../utile.dart';

class ProfilePage extends StatelessWidget {
  final data = ProfileDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: SvgPicture.asset(
              'assets/images/common/leading_back.svg',
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ProfileEditPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return const FadeUpwardsPageTransitionsBuilder()
                        .buildTransitions(
                            MaterialPageRoute(
                                builder: (context) => ProfileEditPage(),
                                settings: const RouteSettings(
                                    name: '/user/profile/edit')),
                            context,
                            animation,
                            secondaryAnimation,
                            child);
                  },
                ),
              );
            },
            child: Container(
              width: 90,
              height: 44,
              margin: const EdgeInsets.only(right: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/images/user/edit.svg'),
                  const SizedBox(
                    width: 9,
                  ),
                  Text(
                    i18nTranslate(context, 'user_edit'),
                    style: const TextStyle(
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
        top: false,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 168),
                      painter: WallPaperPainter(wallPaperImage: null),
                    ),
                    Positioned(
                      bottom: -44,
                      child: _ProfileIcon(icon: data.icon),
                    )
                  ],
                ),
                const SizedBox(
                  height: 66,
                ),
                _ProfileName(
                  name: data.name,
                ),
                const SizedBox(
                  height: 43,
                ),
                _ProfileBio(bio: data.bio),
                const SizedBox(
                  height: 37,
                ),
                _TagsList(
                  tagsList: data.tags,
                ),
                const SizedBox(
                  height: 37,
                ),
                // TODO あとで共通Componentを組み込む
                const _SelectedPlantList(selectedPlantList: [])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon({required this.icon});

  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 99,
      height: 99,
      decoration: const BoxDecoration(
        color: Color(0xFFFF8C00),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 93,
          height: 93,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFB92),
            shape: BoxShape.circle,
            border: Border.all(
              width: 3,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileName extends StatelessWidget {
  const _ProfileName({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        color: Color(0xFF575292),
        fontSize: 18,
        fontFamily: 'NotoSansJP',
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _ProfileBio extends StatelessWidget {
  const _ProfileBio({
    required this.bio,
  }) : super();
  final String bio;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}

class _TagsList extends StatelessWidget {
  const _TagsList({required this.tagsList}) : super();
  final List<Tag> tagsList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          const SizedBox(
            height: 4,
          ),
          Wrap(
            spacing: 5,
            runSpacing: 10,
            children: tagsList
                .map(
                  (tag) => ImportantTagListItem(
                    tag: tag,
                    onSelect: () {},
                    isSelected: true,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlantList extends StatelessWidget {
  const _SelectedPlantList({required this.selectedPlantList}) : super();
  final selectedPlantList;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(
          height: 7,
        ),
        Column(
          children: [_SelectedPlantListItem()],
        ),
      ],
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
