import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/user_profile_page.dart';
import 'package:minden/features/user/presentation/pages/user_thanks_message_page.dart';
import '../../../../utile.dart';

class UserPage extends StatelessWidget {
// 確認用仮データ
  final data = ProfileDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          i18nTranslate(context, 'user_mypage'),
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      bottomNavigationBar: _Footer(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _UserProfile(
              icon: data.icon,
              name: data.name,
              contractor: data.contractor,
            ),
            SizedBox(
              height: 39,
            ),
            _MenuListView(),
          ],
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final String name;
  final String contractor;
  final String icon;
  _UserProfile({
    required this.name,
    required this.contractor,
    required this.icon,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 22),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contractor,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
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
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Menu {
  final String title;
  final String icon;
  final NoAnimationMaterialPageRoute route;
  _Menu({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class _MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _menuList = [
      _Menu(
        title: i18nTranslate(context, 'user_menu_contract'),
        icon: 'contract',
        // TODO routeは仮
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserProfilePage(),
          settings: RouteSettings(name: "/user/profile"),
        ),
      ),
      _Menu(
        title: i18nTranslate(context, 'user_menu_select_plant'),
        icon: 'select_plant',
        // TODO routeは仮
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserProfilePage(),
          settings: RouteSettings(name: "/user/profile"),
        ),
      ),
      _Menu(
        title: i18nTranslate(context, 'user_menu_profile'),
        icon: 'person',
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserProfilePage(),
          settings: RouteSettings(name: "/user/profile"),
        ),
      ),
      _Menu(
        title: i18nTranslate(context, 'user_menu_thanks_message'),
        icon: 'message',
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserThanksMessagePage(),
          settings: RouteSettings(name: "/user/thanksMessage"),
        ),
      ),
      _Menu(
        title: i18nTranslate(context, 'user_menu_contact'),
        icon: 'contact',
        // TODO routeは仮
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserProfilePage(),
          settings: RouteSettings(name: "/user/profile"),
        ),
      ),
      _Menu(
        title: i18nTranslate(context, 'user_menu_logout'),
        icon: 'logout',
        // TODO routeは仮
        route: NoAnimationMaterialPageRoute(
          builder: (context) => UserProfilePage(),
          settings: RouteSettings(name: "/user/profile"),
        ),
      ),
    ];
    return Container(
      child: Column(
        children: _menuList
            .map(
              (e) => _MenuItem(
                title: e.title,
                icon: e.icon,
                route: e.route,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final title;
  final icon;
  final route;
  const _MenuItem({
    required this.title,
    required this.icon,
    required this.route,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pushReplacement(context, route);
      },
      child: Container(
        padding: EdgeInsets.only(left: 22),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: [
            SvgPicture.asset('assets/images/user/$icon.svg'),
            SizedBox(width: 17.5),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w400,
                letterSpacing: calcLetterSpacing(letter: 0.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      items: [
        BottomNavigationBarItem(
          label: '',
          icon: SvgPicture.asset(
            'assets/images/user/search.svg',
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: SvgPicture.asset(
            'assets/images/user/person_black.svg',
          ),
        ),
      ],
    );
  }
}
