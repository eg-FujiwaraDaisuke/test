import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab_navigation.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/tab_navigator.dart';
import 'package:minden/features/debug/debug_push_message_page.dart';
import 'package:minden/features/fcm/data/datasources/fcm_token_data_source.dart';
import 'package:minden/features/fcm/data/repositories/fcm_token_repository_impl.dart';
import 'package:minden/features/fcm/domain/usecases/update_fcm_token.dart';
import 'package:minden/features/fcm/pages/bloc/fcm_bloc.dart';
import 'package:minden/injection_container.dart';
import 'package:http/http.dart' as http;

// FCMプッシュ通知の遷移周りの初期化を行っています。
// bottomNavigationBarの出し分けを行います

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.home;

  late UpdateFcmTokenBloc _bloc;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.mypage: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  void _postToken(String? token) {
    logD('FCM token : $token');

    if (token == null) {
      return;
    }

    _bloc.add(UpdateFcmTokenEvent(token));
  }

  @override
  void initState() {
    super.initState();

    _bloc = UpdateFcmTokenBloc(
      FcmStateInitial(),
      UpdateFcmToken(
        FcmTokenRepositoryImpl(
          fcmTokenDataSource: FcmTokenDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    si<FirebaseMessaging>().getToken().then(_postToken);
    si<FirebaseMessaging>().onTokenRefresh.listen(_postToken);

    // プッシュ通知初期化
    //TODO 通知をタップしたらメッセージページに遷移させたい
    //ターミネイト状態でプッシュ通知メッセージからアプリを起動した場合の遷移
    si<FirebaseMessaging>().getInitialMessage().then((RemoteMessage? message) {
      logD('${message}');
      if (message != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(
                name: '/message',
                arguments: MessageArguments(message, openedApplication: true)),
            builder: (BuildContext context) {
              return MessageView();
            },
          ),
        );
      }
    });

    // バックグラウンド状態でプッシュ通知メッセージからアプリを起動した場合の遷移
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      logD('${message}');
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(
              name: '/message',
              arguments: MessageArguments(message, openedApplication: true)),
          builder: (BuildContext context) {
            return MessageView();
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(TabItem.home),
            _buildOffstageNavigator(TabItem.mypage)
          ],
        ),
        bottomNavigationBar: HomeMypageTabNavigation(
          currentTab: _currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
