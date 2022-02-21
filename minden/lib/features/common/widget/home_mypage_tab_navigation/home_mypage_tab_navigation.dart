import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller_provider.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_state.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';

class HomeMypageTabNavigation extends HookWidget {
  HomeMypageTabNavigation({
    required this.currentTab,
  }) : super();
  final TabItem currentTab;

  @override
  Widget build(BuildContext context) {
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);
    final messagesStateData = useProvider(messagesStateControllerProvider);

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: [
        bottomHome(
          context,
          TabItem.home,
        ),
        bottomMenu(
            context, TabItem.menu, messagesStateController, messagesStateData)
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
      onTap: (index) {
        if (TabItem.values[index] == TabItem.home) {
          // 前にいたtabがhomeで次いきたいのもhomeならisFirstさせる
          if (TabItem.values[currentTab.index] == TabItem.home) {
            BlocProvider.of<TransitionScreenBloc>(context)
                .add(TransitionScreenEvent('PowerPlantHomePage', true));
            return;
          }

          BlocProvider.of<TransitionScreenBloc>(context)
              .add(TransitionScreenEvent('PowerPlantHomePage', false));
        }

        if (TabItem.values[index] == TabItem.menu) {
          // 前にいたtabがnemuで次いきたいのもnemuならisFirstさせる
          if (TabItem.values[currentTab.index] == TabItem.menu) {
            BlocProvider.of<TransitionScreenBloc>(context)
                .add(TransitionScreenEvent('UserPage', true));
            return;
          }

          BlocProvider.of<TransitionScreenBloc>(context)
              .add(TransitionScreenEvent('UserPage', false));
        }
      },
      currentIndex: currentTab.index,
    );
  }

  BottomNavigationBarItem bottomHome(
    BuildContext context,
    TabItem tabItem,
  ) {
    final color = currentTab == tabItem
        ? const Color(0xFFFF8C00)
        : const Color(0xFFA7A7A7);
    final tabTitle = i18nTranslate(context, 'tab_navigation_home');
    const tabIcon = 'home';

    return BottomNavigationBarItem(
      tooltip: '',
      icon: SvgPicture.asset(
        'assets/images/common/$tabIcon.svg',
        color: color,
      ),
      label: tabTitle.toString(),
    );
  }

  BottomNavigationBarItem bottomMenu(
      BuildContext context,
      TabItem tabItem,
      MessagesStateController messagesStateController,
      MessagesState messagesStateData) {
    final color = currentTab == tabItem
        ? const Color(0xFFFF8C00)
        : const Color(0xFFA7A7A7);
    final tabTitle = i18nTranslate(context, 'tab_navigation_menu');
    const tabIcon = 'mypage';
    return BottomNavigationBarItem(
      tooltip: '',
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: Icon(
              Icons.dehaze_rounded,
              color: color,
            ),
          ),
          if (!messagesStateData.hasEverGetMessage)
            Positioned(
              right: -6,
              top: -7,
              child: Container(),
            )
          else
            Positioned(
              right: -6,
              top: -7,
              child: Opacity(
                opacity: messagesStateData.showBadge ? 1 : 0,
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
      label: tabTitle.toString(),
    );
  }
}
