import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab_navigation.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/tab_navigator.dart';
import 'package:minden/features/debug/debug_push_message_page.dart';
import 'package:minden/injection_container.dart';

// FCMプッシュ通知の遷移周りの初期化を行っています。
//bottomNavigationBarの出し分けを行います

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.home;

  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.mypage: GlobalKey<NavigatorState>(),
  };

  void _selectTab(TabItem tabItem) {
    setState(() => _currentTab = tabItem);
  }

  void _postToken(String? token) {
    logD('FCM token : $token');
    if (token == null) return;
  }

  @override
  void initState() {
    super.initState();

    si<FirebaseMessaging>().getToken().then(_postToken);
    si<FirebaseMessaging>().onTokenRefresh.listen(_postToken);

    // プッシュ通知初期化
    //TODO 通知をタップしたらメッセージページに遷移させたい
    //ターミネイト状態でプッシュ通知メッセージからアプリを起動した場合の遷移
    si<FirebaseMessaging>().getInitialMessage().then((RemoteMessage? message) {
      logD('===========================ターミネイト状態');
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

      logD('=========================== バックグラウンド状態');
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
