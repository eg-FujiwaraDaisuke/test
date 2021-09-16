import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';

class HomeMypageTabNavigation extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  HomeMypageTabNavigation({
    required this.currentTab,
    required this.onSelectTab,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: [
        bottomItem(context, tabItem: TabItem.home),
        bottomItem(context, tabItem: TabItem.mypage, hasUnreadNotice: true)
      ],
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'NotoSansJP',
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontFamily: 'NotoSansJP',
        fontWeight: FontWeight.w500,
      ),
      selectedItemColor: const Color(0xFFFF8C00),
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: currentTab.index,
    );
  }

  BottomNavigationBarItem bottomItem(
    BuildContext context, {
    TabItem? tabItem,
    bool hasUnreadNotice = false,
  }) {
    final color = currentTab == tabItem
        ? const Color(0xFFFF8C00)
        : const Color(0xFFA7A7A7);
    final tabTitle = <TabItem, String>{
      TabItem.home: i18nTranslate(context, 'tab_navigation_home'),
      TabItem.mypage: i18nTranslate(context, 'tab_navigation_mypage'),
    };
    const tabIcon = <TabItem, String>{
      TabItem.home: 'home',
      TabItem.mypage: 'mypage',
    };

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
              //アプリがforegroundになった際に、応援メッセージ履歴取得APIにて既読メッセージの有無を取得する。
              //既読メッセージが存在している場合、マイページタブ、メッセージラベルに未読バッジを表示する。
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
      label: tabTitle[tabItem].toString(),
    );
  }
}
