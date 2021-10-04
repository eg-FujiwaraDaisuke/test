import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/data/repositories/message_repository_impl.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:http/http.dart' as http;

class HomeMypageTabNavigation extends StatefulWidget {
  const HomeMypageTabNavigation({
    required this.currentTab,
    required this.onSelectTab,
  }) : super();
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  _HomeMypageTabNavigationState createState() =>
      _HomeMypageTabNavigationState();
}

class _HomeMypageTabNavigationState extends State<HomeMypageTabNavigation> {
  late GetMessagesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = GetMessagesBloc(
      const MessageInitial(),
      GetMessages(
        MessageRepositoryImpl(
          dataSource: MessageDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.add(GetMessagesEvent('1'));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 0,
      items: [
        bottomHome(
          context,
          TabItem.home,
        ),
        bottomMypage(
          context,
          TabItem.mypage,
        )
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
      onTap: (index) => widget.onSelectTab(
        TabItem.values[index],
      ),
      currentIndex: widget.currentTab.index,
    );
  }

  BottomNavigationBarItem bottomHome(
    BuildContext context,
    TabItem tabItem,
  ) {
    final color = widget.currentTab == tabItem
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
  ) {
    final color = widget.currentTab == tabItem
        ? const Color(0xFFFF8C00)
        : const Color(0xFFA7A7A7);
    final tabTitle = i18nTranslate(context, 'tab_navigation_home');

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
          BlocProvider.value(
            value: _bloc,
            child: BlocBuilder<GetMessagesBloc, MessageState>(
              builder: (context, state) {
                if (state is MessagesLoaded) {
                  return Positioned(
                    right: -6,
                    top: -7,
                    child: Opacity(
                      opacity: state.messages.showBadge ? 1 : 0,
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
                  );
                }
                return Positioned(
                  right: -6,
                  top: -7,
                  child: Container(),
                );
              },
            ),
          ),
        ],
      ),
      label: tabTitle.toString(),
    );
  }
}
