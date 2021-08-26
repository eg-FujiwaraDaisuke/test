import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/user_profile_page.dart';
import 'package:minden/features/user/presentation/pages/user_thanks_message_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_painter.dart';

import '../../../../utile.dart';

enum MenuType {
  common,
  message,
}

class _Menu {
  final String title;
  final String icon;
  final MaterialPageRoute? route;
  final MenuType type;
  _Menu({
    required this.title,
    required this.icon,
    required this.route,
    required this.type,
  });
}

class UserPage extends StatelessWidget {
// 確認用仮データ
  final data = ProfileDamyData().damyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          i18nTranslate(context, 'user_mypage'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            letterSpacing: calcLetterSpacing(letter: 0.5),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    top: -113,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 168),
                      painter: WallPaperPainter(wallPaperimage: null),
                    ),
                  ),
                  Positioned(
                    child: _UserProfile(
                      icon: data.icon,
                      name: data.name,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 61,
              ),
              _MenuListView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserProfile extends StatelessWidget {
  final String name;
  final String icon;
  _UserProfile({
    required this.name,
    required this.icon,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
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
          )
        ],
      ),
    );
  }
}

class _MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _menuList = [
      _Menu(
          title: i18nTranslate(context, 'user_menu_select_plant'),
          icon: 'select_plant',
          // TODO routeは仮
          route: MaterialPageRoute(
            builder: (context) => UserProfilePage(),
            settings: RouteSettings(name: "/user/profile"),
          ),
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_profile'),
          icon: 'person',
          route: MaterialPageRoute(
            builder: (context) => UserProfilePage(),
            settings: RouteSettings(name: "/user/profile"),
          ),
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_thanks_message'),
          icon: 'message',
          route: MaterialPageRoute(
            builder: (context) => UserThanksMessagePage(),
            settings: RouteSettings(name: "/user/thanksMessage"),
          ),
          type: MenuType.message),
      _Menu(
          title: i18nTranslate(context, 'user_menu_contact'),
          icon: 'contact',
          // TODO routeは仮
          route: MaterialPageRoute(
            builder: (context) => UserProfilePage(),
            settings: RouteSettings(name: "/user/profile"),
          ),
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_logout'),
          icon: 'logout',
          // TODO routeは仮
          route: MaterialPageRoute(
            builder: (context) => UserProfilePage(),
            settings: RouteSettings(name: "/user/profile"),
          ),
          type: MenuType.common),
    ];
    return Container(
      child: Column(
        children: _menuList.map((menu) {
          if (menu.type == MenuType.message) {
            return _MenuMessageItem(
              title: menu.title,
              icon: menu.icon,
              route: menu.route,
            );
          }
          return _MenuItem(
            title: menu.title,
            icon: menu.icon,
            route: menu.route,
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final MaterialPageRoute? route;

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
        if (route != null) {
          Navigator.push(context, route!);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/user/$icon.svg',
                    color: Color(0xFF575292),
                  ),
                  const SizedBox(width: 17.5),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF575292),
                      fontSize: 12,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w700,
                      letterSpacing: calcLetterSpacing(letter: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuMessageItem extends StatelessWidget {
  final String title;
  final String icon;
  final MaterialPageRoute? route;
  final bool hasUnreadNotice = true;

  const _MenuMessageItem({
    required this.title,
    required this.icon,
    required this.route,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (route != null) {
          Navigator.push(context, route!);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 22),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        child: SvgPicture.asset(
                          'assets/images/user/$icon.svg',
                          color: Color(0xFF575292),
                        ),
                      ),
                      Positioned(
                        right: -6,
                        top: -3,
                        child: Opacity(
                          opacity: hasUnreadNotice ? 1 : 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF8C00),
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 3,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 17.5),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF575292),
                      fontSize: 12,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w700,
                      letterSpacing: calcLetterSpacing(letter: 0.5),
                    ),
                  ),
                  SizedBox(width: 22),
                  hasUnreadNotice
                      ? Flexible(
                          child: Text(
                            'XXX発電所' +
                                i18nTranslate(
                                    context, 'thanks_message_notification'),
                            style: TextStyle(
                              color: Color(0xFFFF8C00),
                              fontSize: 9,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w500,
                              letterSpacing: calcLetterSpacing(letter: 0.5),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
