import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/debug/debug_page.dart';
import 'package:minden/features/debug/debug_push_message_page.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/power_plant/pages/power_plant_page.dart';
import 'package:minden/features/startup/presentation/pages/initial_page.dart';

import '../../../../injection_container.dart';

// FCMプッシュ通知の遷移周りの初期化を行っています。
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // プッシュ通知初期化
    //TODO 通知をタップしたらメッセージページに遷移させたい
    //ターミネイト状態でプッシュ通知メッセージからアプリを起動した場合の遷移
    si<FirebaseMessaging>().getInitialMessage().then((RemoteMessage? message) {
      print('===========================ターミネイト状態');
      print(message);
      if (message != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            settings: RouteSettings(
                name: "/message",
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
      print(message);
      print('=========================== バックグラウンド状態');
      Navigator.of(context).push(
        MaterialPageRoute(
          settings: RouteSettings(
              name: "/message",
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
    return HomeTopPage();
  }
}
