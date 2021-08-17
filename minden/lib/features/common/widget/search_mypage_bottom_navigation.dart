import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum TabItem { home, mypage }

const tabTitle = <TabItem, String>{
  TabItem.home: 'Home',
  TabItem.mypage: 'Mypage',
};
const tabIcon = <TabItem, String>{
  TabItem.home: 'home',
  TabItem.mypage: 'mypage',
};

class SearchMypageBottomNavigation extends StatelessWidget {
  final TabItem currentTab = TabItem.mypage;
  // final ValueChanged<Tab> onSelect;

  SearchMypageBottomNavigation(
      // this.currentTab,
      // this.onSelect,
      )
      : super();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: [
        bottomItem(context, tabItem: TabItem.home),
        bottomItem(context, tabItem: TabItem.mypage, isNewNotification: true)
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) => {print(index)},
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'NotoSansJP',
        fontWeight: FontWeight.w500,
      ),
      selectedItemColor: Color(0xFFFF8C00),
      currentIndex: 1,
    );
  }

  BottomNavigationBarItem bottomItem(BuildContext context,
      {TabItem? tabItem, bool isNewNotification = false}) {
    final color = currentTab == tabItem ? Color(0xFFFF8C00) : Color(0xFFA7A7A7);
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: SvgPicture.asset(
              'assets/images/common/${tabIcon[tabItem]}.svg',
              color: color,
            ),
          ),
          Positioned(
            right: -6,
            top: -7,
            child: Opacity(
              opacity: isNewNotification ? 1 : 0,
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
      label: tabTitle[tabItem].toString(),
    );
  }
}
