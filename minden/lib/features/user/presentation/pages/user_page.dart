import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../utile.dart';

class UserPage extends StatelessWidget {
  // 確認用仮データ
  final String userPhoto = '';
  final String userName = 'Username';
  final String userFullName = 'Full Name';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'マイページ',
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
              userPhoto: userPhoto,
              userName: userName,
              userFullName: userFullName,
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
  final String userPhoto;
  final String userFullName;
  final String userName;
  _UserProfile({
    required this.userPhoto,
    required this.userFullName,
    required this.userName,
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
                userFullName,
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
                userName,
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

class Menu {
  late final String title;
  late final String icon;

  Menu({
    required this.title,
    required this.icon,
  });
}

class _MenuListView extends StatelessWidget {
  final _menuList = [
    Menu(title: 'ご利用明細・ご契約内容の確認', icon: 'contract'),
    Menu(title: '選択した発電所', icon: 'select_plant'),
    Menu(title: 'プロフィール', icon: 'profile'),
    Menu(title: 'お問い合わせ', icon: 'contact'),
    Menu(title: 'ログアウト', icon: 'logout'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: _menuList
            .map(
              (e) => _MenuItem(
                title: e.title,
                icon: e.icon,
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
  const _MenuItem({
    required this.title,
    required this.icon,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        print(title);
      },
      child: Container(
        margin: EdgeInsets.only(left: 22),
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
            'assets/images/user/profile.svg',
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
