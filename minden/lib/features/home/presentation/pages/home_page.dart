import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/home_mypage_tab_navigation.dart';
import 'package:minden/features/common/widget/home_mypage_tab_navigation/tab_navigator.dart';
import 'package:minden/features/fcm/data/datasources/fcm_token_data_source.dart';
import 'package:minden/features/fcm/data/repositories/fcm_token_repository_impl.dart';
import 'package:minden/features/fcm/domain/usecases/update_fcm_token.dart';
import 'package:minden/features/fcm/pages/bloc/fcm_bloc.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/data/repositories/message_repository_impl.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/message/presentation/viewmodel/messages_controller_provider.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';
import 'package:minden/injection_container.dart';

// FCMプッシュ通知の遷移周りの初期化を行っています。
// bottomNavigationBarの出し分けを行います

class HomePage extends HookWidget {
  final _navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.mypage: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    final _currentTab = useState<TabItem>(TabItem.home);

    late UpdateFcmTokenBloc _updateFcmTokenBloc;
    late GetMessagePushNotifyBloc _getMessagePushNotifyBloc;
    late GetMessageBackGroundPushNotifyBloc _getMessageBackGroundPushNotifyBloc;
    late TransitionScreenBloc _transitionScreenBloc;

    void _selectTab(TabItem tabItem) => _currentTab.value = tabItem;
    final messagesStateController =
        useProvider(messagesStateControllerProvider.notifier);

    void _postToken(String? token) {
      logD('FCM token : $token');

      if (token == null) {
        return;
      }

      _updateFcmTokenBloc.add(UpdateFcmTokenEvent(token));
    }

    Future _onSelectNotification(String? payload) async {
      if (payload?.isNotEmpty ?? false) {
        _transitionScreenBloc.add(TransitionMessagePageEvent(payload!));
      }
    }

    useEffect(() {
      _transitionScreenBloc = BlocProvider.of<TransitionScreenBloc>(context);
      _transitionScreenBloc.stream.listen((event) {
        if (event is TransitionScreenStart) {
          if (event.screen == 'PowerPlantHomePage') {
            _selectTab(
              TabItem.home,
            );
          }
          if (event.screen == 'UserPage') {
            _selectTab(
              TabItem.mypage,
            );
          }
        }
        //
        if (event is TransitionMessagePageStart) {
          _selectTab(
            TabItem.mypage,
          );
        }
      });
      _getMessagePushNotifyBloc = GetMessagePushNotifyBloc(
        const MessageInitial(),
        GetMessages(
          MessageRepositoryImpl(
            dataSource: MessageDataSourceImpl(
              client: http.Client(),
            ),
          ),
        ),
      );
      _getMessagePushNotifyBloc.stream.listen((state) async {
        if (state is MessagesPushNotifyLoaded) {
          messagesStateController.updateMessagesPushNotify(state.messages);
        }
      });

      _getMessageBackGroundPushNotifyBloc = GetMessageBackGroundPushNotifyBloc(
        const MessageInitial(),
        GetMessages(
          MessageRepositoryImpl(
            dataSource: MessageDataSourceImpl(
              client: http.Client(),
            ),
          ),
        ),
      );

      _getMessageBackGroundPushNotifyBloc.stream.listen((state) async {
        if (state is MessagesLoaded) {
          messagesStateController.updateMessages(state.messages);
        }
      });

      _updateFcmTokenBloc = UpdateFcmTokenBloc(
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
        const initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');
        const initializationSettingsIOS = IOSInitializationSettings();

        const initializationSettings = InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

        await si<FlutterLocalNotificationsPlugin>().initialize(
            initializationSettings,
            onSelectNotification: _onSelectNotification);

        // フォアグラウンド状態の通知
        // Android ではアプリがフォアグラウンド状態で
        // 画面上部にプッシュ通知メッセージを表示することができない為、
        // ローカル通知で擬似的に通知メッセージを表示
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          logD('フォアグラウンド状態からプッシュ通知受け取った ${message.data}');
          _getMessagePushNotifyBloc.add(GetMessagesEvent('1'));

          final notification = message.notification;
          final android = message.notification?.android;
          const channel = AndroidNotificationChannel(
            'high_importance_channel',
            'High Importance Notifications',
            'This channel is used for important notifications.',
            importance: Importance.high,
          );

          if (notification != null && android != null) {
            var payload = '';
            if (message.data.isNotEmpty){
              final String? messageId = message.data['messageId'];
              if (messageId?.isNotEmpty ?? false) {
                payload = messageId!;
              }
            }

            si<FlutterLocalNotificationsPlugin>().show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  icon: 'launch_background',
                ),
              ),
              payload: payload,
            );
          }
        });

        await si<FirebaseMessaging>().getToken().then(_postToken);
        si<FirebaseMessaging>().onTokenRefresh.listen(_postToken);

        // プッシュ通知初期化
        // ターミネイト状態でプッシュ通知メッセージからアプリを起動した場合の遷移
        await si<FirebaseMessaging>()
            .getInitialMessage()
            .then((RemoteMessage? message) {
          logD('ターミネイト状態からプッシュ通知をタップした ${message?.data}');
          if (message?.data.isNotEmpty ?? false){
            final String? messageId = message?.data['messageId'];
            if (messageId?.isNotEmpty ?? false) {
              _transitionScreenBloc.add(TransitionMessagePageEvent(messageId!));
            }
          }
        });

        // バックグラウンド状態でプッシュ通知メッセージからアプリを起動した場合の遷移
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          logD('バックグラウンド状態からプッシュ通知をタップした ${message.data}');
          if (message.data.isNotEmpty){
            final String? messageId = message.data['messageId'];
            if (messageId?.isNotEmpty ?? false) {
              _getMessageBackGroundPushNotifyBloc.add(GetMessagesEvent('1'));
              _transitionScreenBloc.add(TransitionMessagePageEvent(messageId!));
            }
          }
        });
      });

      return () {
        _updateFcmTokenBloc.close();
        _getMessagePushNotifyBloc.close();
        _getMessageBackGroundPushNotifyBloc.close();
      };
    }, []);

    return WillPopScope(
      onWillPop: () async =>
          !await _navigatorKeys[_currentTab.value]!.currentState!.maybePop(),
      child: Scaffold(
        body: Stack(
          children: [
            _buildOffstageNavigator(TabItem.home, _currentTab.value),
            _buildOffstageNavigator(TabItem.mypage, _currentTab.value)
          ],
        ),
        bottomNavigationBar: HomeMypageTabNavigation(
          currentTab: _currentTab.value,
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem, TabItem currentTab) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }
}
