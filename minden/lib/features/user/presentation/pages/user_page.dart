import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/message/presentation/pages/message_page.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller_provider.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/support_history_power_plant/presentation/pages/support_history_power_plant_page.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_event.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/wall_paper_arc_painter.dart';
import 'package:minden/injection_container.dart';
import 'package:minden/utile.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final String routeName;
  final MenuType type;
}

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  late GetProfileBloc _getProfileBloc;
  late TransitionScreenBloc _transitionScreenBloc;

  @override
  void initState() {
    super.initState();

    _getProfileBloc = GetProfileBloc(
      const ProfileStateInitial(),
      GetProfile(
        ProfileRepositoryImpl(
          dataSource: ProfileDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _getProfileBloc.add(GetProfileEvent(userId: si<Account>().userId));

    _transitionScreenBloc = BlocProvider.of<TransitionScreenBloc>(context);
    _transitionScreenBloc.stream.listen((event) {
      if (event is TransitionScreenStart) {
        if (event.screen == 'UserPage') {
          if (event.isFirst)
            Navigator.popUntil(context, (route) => route.isFirst);
        }
      }

      if (event is TransitionMessagePageStart) {
        // メッセージページにいるとき、メッセージページの上にメッセージページがpushされてしまうが一旦仕様として正にする
        final route = MaterialPageRoute(
          builder: (context) => MessagePage(showMessageId: event.messageId),
          settings: RouteSettings(name: '/user/message'),
        );
        Navigator.push(context, route);
      }
    });
  }

  @override
  void dispose() {
    _getProfileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getProfileBloc,
      child: BlocListener<GetProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoaded) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
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
                            if (state.profile.wallPaper?.isEmpty ?? true)
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 173,
                                  color: const Color(0xFFFFFB92))
                            else
                              CachedNetworkImage(
                                imageUrl: state.profile.wallPaper!,
                                placeholder: (context, url) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 173,
                                    color: const Color(0xFFFFFB92),
                                  );
                                },
                                errorWidget: (context, url, error) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 173,
                                  color: const Color(0xFFFFFB92),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 173,
                                fit: BoxFit.cover,
                              ),
                            CustomPaint(
                              size:
                                  Size(MediaQuery.of(context).size.width, 173),
                              painter: WallPaperArcPainter(color: Colors.white),
                            ),
                            Positioned(
                              bottom: -44,
                              child: ProfileIcon(icon: state.profile.icon),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        ProfileName(
                          name: state.profile.name,
                        ),
                        const SizedBox(
                          height: 61,
                        ),
                        _MenuListView(),
                        _MenuItem(
                          title: i18nTranslate(context, 'user_menu_logout'),
                          icon: 'logout',
                          routeName: '/logout',
                          handler: () async {
                            await _showAlert(
                                message:
                                    i18nTranslate(context, "confirm_logout"),
                                actionName: i18nTranslate(context, "YES"));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return PlaceHolderProfile();
          },
        ),
      ),
    );
  }

  Future<void> _showAlert({
    required String message,
    required String actionName,
  }) async {
    final ret = await showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(true),
                child: Text(actionName),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(false),
                child: Text(i18nTranslate(context, "NO")),
              ),
            ],
          );
        });

    if (ret == null) return;

    if (ret) {
      BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
      Loading.show(context);
      await Future.delayed(const Duration(seconds: 2));
      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ), (_) {
        Loading.hide();
        return false;
      });
    }
  }
}

class _MenuListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _menuList = [
      _Menu(
          title: i18nTranslate(context, 'user_menu_profile'),
          icon: 'select_plant',
          routeName: '/user/profile',
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_support_power_plant'),
          icon: 'person',
          routeName: '/user/supporPowerPlant',
          type: MenuType.common),
      _Menu(
          title: i18nTranslate(context, 'user_menu_message'),
          icon: 'message',
          routeName: '/user/message',
          type: MenuType.message),
      _Menu(
        title: i18nTranslate(context, 'user_menu_contact'),
        icon: 'contact',
        routeName: '/contact',
        type: MenuType.common,
      ),
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
  const _MenuItem({
    required this.title,
    required this.icon,
    required this.routeName,
    this.handler,
  }) : super();
  final String title;
  final String icon;
  final String? routeName;
  final Function? handler;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        switch (routeName) {
          case '/user/profile':
            final userId = si<Account>().userId;
            final route = MaterialPageRoute(
              builder: (context) => ProfilePage(userId: userId),
              settings: RouteSettings(name: routeName),
            );
            await Navigator.push(context, route);
            BlocProvider.of<GetProfileBloc>(context)
                .add(GetProfileEvent(userId: si<Account>().userId));
            break;
          case '/user/supporPowerPlant':
            final route = MaterialPageRoute(
              builder: (context) => SupportHistoryPowerPlantPage(),
              settings: RouteSettings(name: routeName),
            );
            await Navigator.push(context, route);
            break;
          case '/contact':
            await launch('https://portal.minden.co.jp/contact/guest');
            break;
          case '/logout':
            handler?.call();
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

class _MenuMessageItem extends HookWidget {
  _MenuMessageItem({
    required this.title,
    required this.icon,
    required this.routeName,
  }) : super();
  final String title;
  final String icon;
  final String routeName;
  late GetMessagesBloc _getMessagesBloc;
  late GetPowerPlantBloc _getPowerPlantsBloc;

  @override
  Widget build(BuildContext context) {
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);
    final messagesStateData = useProvider(messagesStateControllerProvider);

    useEffect(() {
      if (!messagesStateData.hasEverGetMessage) {
        _getMessagesBloc = BlocProvider.of<GetMessagesBloc>(context);
        _getMessagesBloc.add(GetMessagesEvent('1'));
      }

      _getPowerPlantsBloc = GetPowerPlantBloc(
        const PowerPlantStateInitial(),
        GetPowerPlant(
          PowerPlantRepositoryImpl(
            powerPlantDataSource: PowerPlantDataSourceImpl(
              client: http.Client(),
            ),
          ),
        ),
      );
      return () {
        _getPowerPlantsBloc.close();
      };
    });

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => MessagePage(),
          settings: const RouteSettings(name: '/user/message'),
        );
        Navigator.push(context, route);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: !messagesStateData.hasEverGetMessage
              ? BlocProvider.value(
                  value: _getMessagesBloc,
                  child: BlocListener<GetMessagesBloc, MessageState>(
                    listener: (context, state) {
                      if (state is MessagesLoaded) {
                        messagesStateController.updateMessages(state.messages);
                      }
                    },
                    child: _buildMessageNav(context),
                  ),
                )
              : _buildMessageNav(context)),
    );
  }

  Widget _buildMessageNav(BuildContext context) {
    final messagesStateData = useProvider(messagesStateControllerProvider);

    // 取得したメッセージの中でもっとも最新で未読のメッセージを取得
    final latestUnreadMessageDetail = messagesStateData.messages
        .firstWhereOrNull((messageDetail) => messageDetail.read == false);

    return Column(
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
            if (messagesStateData.showBadge &&
                latestUnreadMessageDetail != null)
              Flexible(
                child: Text(
                  '${latestUnreadMessageDetail.messageType == '1' ? i18nTranslate(context, 'minden') : latestUnreadMessageDetail.title}${i18nTranslate(context, 'thanks_message_notification')}',
                  style: TextStyle(
                    color: const Color(0xFFFF8C00),
                    fontSize: 9,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    letterSpacing: calcLetterSpacing(letter: 0.5),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }
}
