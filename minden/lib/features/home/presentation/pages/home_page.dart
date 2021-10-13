import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab_navigation.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/tab_navigator.dart';
import 'package:minden/features/fcm/data/datasources/fcm_token_data_source.dart';
import 'package:minden/features/fcm/data/repositories/fcm_token_repository_impl.dart';
import 'package:minden/features/fcm/domain/usecases/update_fcm_token.dart';
import 'package:minden/features/fcm/pages/bloc/fcm_bloc.dart';
import 'package:minden/features/message/presentation/pages/message_page.dart';
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

    Future(() async {
      // const initializationSettingsAndroid = AndroidInitializationSettings('');
      // const initializationSettingsIOS = IOSInitializationSettings();

      // const initializationSettings = InitializationSettings(
      //     android: initializationSettingsAndroid,
      //     iOS: initializationSettingsIOS);

      // await si<FlutterLocalNotificationsPlugin>().initialize(
      //     initializationSettings,
      //     onSelectNotification: onSelectNotification);

      // // フォアグラウンド状態の通知
      // // Android ではアプリがフォアグラウンド状態で画面上部に
      // // プッシュ通知メッセージを表示することができない為、
      // // ローカル通知で擬似的に通知メッセージを表示
      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   debugPrint('フォアグラウンド状態からプッシュ通知をタップした');
      //   logD('${message}');

      //   final notification = message.notification;
      //   final android = message.notification?.android;
      //   const channel = AndroidNotificationChannel(
      //     'high_importance_channel',
      //     'High Importance Notifications',
      //     'This channel is used for important notifications.',
      //     importance: Importance.high,
      //   );

      //   if (notification != null && android != null) {
      //     si<FlutterLocalNotificationsPlugin>().show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           channel.id,
      //           channel.name,
      //           channel.description,
      //           icon: 'launch_background',
      //         ),
      //       ),
      //       payload: notification.body,
      //     );
      //   }
      // });

      await si<FirebaseMessaging>().getToken().then(_postToken);
      si<FirebaseMessaging>().onTokenRefresh.listen(_postToken);

      // プッシュ通知初期化
      //ターミネイト状態でプッシュ通知メッセージからアプリを起動した場合の遷移
      await si<FirebaseMessaging>()
          .getInitialMessage()
          .then((RemoteMessage? message) {
        logD('${message}');
        debugPrint('ターミネイト状態からプッシュ通知をタップした');
        if (message != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(
                  name: '/user/message',
                  arguments: MessageArguments(message, true)),
              builder: (BuildContext context) {
                return MessagePage();
              },
            ),
          );
        }
      });

      // バックグラウンド状態でプッシュ通知メッセージからアプリを起動した場合の遷移
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('バックグラウンド状態からプッシュ通知をタップした');
        logD('${message}');
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(
                name: '/user/message',
                arguments: MessageArguments(message, true)),
            builder: (BuildContext context) {
              return MessagePage();
            },
          ),
        );
      });
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future onSelectNotification(String? payload) async {
    print('onSelectNotification');
    print(payload);
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
