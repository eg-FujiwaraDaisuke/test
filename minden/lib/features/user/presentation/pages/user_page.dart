import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/user/presentation/pages/profile_damy_data.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/user_thanks_message_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_painter.dart';

import '../../../../utile.dart';

enum MenuType {
  common,
  message,
}

class _Menu {
  _Menu({
    required this.title,
    required this.icon,
    required this.routeName,
    required this.type,
  });

  final String title;
  final String icon;
  final String? routeName;
  final MenuType type;
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
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
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

class _ProfileIcon extends StatelessWidget {
  final String icon;

  const _ProfileIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 99,
      height: 99,
      decoration: const BoxDecoration(
        color: const Color(0xFFFF8C00),
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
  final String name;

  const _ProfileName({
    required this.name,
  });

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

class _MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _menuList = [
      _Menu(
          title: i18nTranslate(context, 'user_menu_select_plant'),
          icon: 'select_plant',
          // TODO routeは仮
          routeName: '/user/profile',
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_profile'),
          icon: 'person',
          routeName: '/user/profile',
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_thanks_message'),
          icon: 'message',
          routeName: '/user/thanksMessage',
          type: MenuType.message),
      _Menu(
        title: i18nTranslate(context, 'user_menu_contact'),
        icon: 'contact',
        // TODO routeは仮
        routeName: '/user/profile',
        type: MenuType.common,
      ),
      _Menu(
          title: i18nTranslate(context, 'user_menu_logout'),
          icon: 'logout',
          // TODO routeは仮
          routeName: '/user/profile',
          type: MenuType.common),
    ];
    return Column(
      children: _menuList.map((menu) {
        if (menu.type == MenuType.message) {
          return _MenuMessageItem(
            title: menu.title,
            icon: menu.icon,
            routeName: menu.routeName,
          );
        }
        return _MenuItem(
          title: menu.title,
          icon: menu.icon,
          routeName: menu.routeName,
        );
      }).toList(),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;
  final String icon;
  final String? routeName;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.routeName,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        switch (routeName) {
          case '/user/profile':
            final route = MaterialPageRoute(
              builder: (context) => ProfilePage(),
              settings: RouteSettings(name: routeName),
            );
            Navigator.push(context, route);
            break;

          default:
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/images/user/$icon.svg',
                  color: const Color(0xFF575292),
                ),
                const SizedBox(width: 17.5),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF575292),
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    letterSpacing: calcLetterSpacing(letter: 0.5),
                  ),
                ),
              ],
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
  final String? routeName;
  final bool hasUnreadNotice = true;

  const _MenuMessageItem({
    required this.title,
    required this.icon,
    required this.routeName,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => UserThanksMessagePage(),
          settings: const RouteSettings(name: '/user/message'),
        );

        Navigator.push(context, route);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      child: SvgPicture.asset(
                        'assets/images/user/$icon.svg',
                        color: const Color(0xFF575292),
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
                            color: const Color(0xFFFF8C00),
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 17.5),
                Text(
                  title,
                  style: TextStyle(
                    color: const Color(0xFF575292),
                    fontSize: 12,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    letterSpacing: calcLetterSpacing(letter: 0.5),
                  ),
                ),
                const SizedBox(width: 22),
                if (hasUnreadNotice)
                  Flexible(
                    child: Text(
                      'XXX発電所' +
                          i18nTranslate(context, 'thanks_message_notification'),
                      style: TextStyle(
                        color: const Color(0xFFFF8C00),
                        fontSize: 9,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w500,
                        letterSpacing: calcLetterSpacing(letter: 0.5),
                      ),
                    ),
                  )
                else
                  Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
