import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller_provider.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_state.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';

class HomeMypageTabNavigation extends HookWidget {
  HomeMypageTabNavigation({
    required this.currentTab,
    required this.onSelectTab,
  }) : super();
  final TabItem currentTab;
  final Function onSelectTab;
  late GetMessagesBloc _bloc;
  late TransitionScreenBloc _transitionScreenBloc;

  @override
  Widget build(BuildContext context) {
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);
    final messagesStateData = useProvider(messagesStateControllerProvider);

    useEffect(() {
      if (!messagesStateData.hasEverGetMessage) {
        _bloc = BlocProvider.of<GetMessagesBloc>(context);
        _bloc.add(GetMessagesEvent('1'));
      }

      _transitionScreenBloc = BlocProvider.of<TransitionScreenBloc>(context);
      _transitionScreenBloc.stream.listen((event) {
        if (event is TransitionScreenStart) {
          if (event.screen == 'MessagePage') {
            onSelectTab(
              TabItem.mypage,
            );
          }
          if (event.screen == 'PowerPlantHomePage') {
            onSelectTab(
              TabItem.home,
            );
          }
        }
      });
    }, []);

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: [
        bottomHome(
          context,
          TabItem.home,
        ),
        bottomMypage(
            context, TabItem.mypage, messagesStateController, messagesStateData)
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
        // activeなタブを再度選んだら
        if (TabItem.values[index] == currentTab) {
          print('TransitionScreenEvent');
          if (currentTab == TabItem.home) {
            _transitionScreenBloc
                .add(TransitionScreenEvent('PowerPlantHomePage'));
          }
          if (currentTab == TabItem.mypage) {
            _transitionScreenBloc.add(TransitionScreenEvent('UserPage'));
          }
        }

        onSelectTab(
          TabItem.values[index],
        );
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
      icon: SvgPicture.asset(
        'assets/images/common/$tabIcon.svg',
        color: color,
      ),
      label: tabTitle.toString(),
    );
  }

  BottomNavigationBarItem bottomMypage(
      BuildContext context,
      TabItem tabItem,
      MessagesStateController messagesStateController,
      MessagesState messagesStateData) {
    final color = currentTab == tabItem
        ? const Color(0xFFFF8C00)
        : const Color(0xFFA7A7A7);
    final tabTitle = i18nTranslate(context, 'tab_navigation_mypage');
    const tabIcon = 'mypage';
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            child: SvgPicture.asset(
              'assets/images/common/$tabIcon.svg',
              color: color,
            ),
          ),
          if (!messagesStateData.hasEverGetMessage)
            BlocProvider.value(
              value: _bloc,
              child: BlocListener<GetMessagesBloc, MessageState>(
                listener: (context, state) {
                  if (state is MessagesLoaded) {
                    messagesStateController.updateMessages(state.messages);
                  }
                },
                child: Positioned(
                  right: -6,
                  top: -7,
                  child: Container(),
                ),
              ),
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
