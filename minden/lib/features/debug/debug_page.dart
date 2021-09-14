import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';
import 'package:minden/features/reset_password/pages/reset_password_page.dart';
import 'package:minden/features/startup/presentation/pages/fcm_debug_page.dart';
import 'package:minden/features/startup/presentation/pages/initial_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/features/user/presentation/pages/profile_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';

import '../../injection_container.dart';

/// デバッグ用画面
/// デバッグビルド時のみ遷移可能で、各画面への遷移や機能呼び出しを提供する
/// NOTE: 本画面を利用する場合、通常と異なる遷移となるため、
/// Navigator関係の不具合が疑われる際は、本画面実装に起因するものか切り分けした上で調査されたし

class DebugPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DebugPageState();
  }
}

class DebugPageState extends State<DebugPage> {
  @override
  void initState() {
    super.initState();
    si<Account>().prepare();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _generateNavigatorPush(
                    context, '通常遷移', (context) => InitialPage(), '/init'),
                _generateNavigatorPush(
                    context, 'ログイン', (context) => LoginPage(), '/login'),
                _generateNavigatorPush(context, 'チュートリアル',
                    (context) => TutorialPage(), '/tutorial'),
                _generateNavigatorPush(
                    context,
                    'プロフィール設定',
                    (context) => ProfileSettingNamePage(),
                    '/profileSetting/name'),
                _generateNavigatorPush(context, 'ログイン パスワードリセット',
                    (context) => ResetPasswordPage(), '/login/resetPassword'),
                _generateNavigatorPush(context, 'ホーム - トップ',
                    (context) => PowerPlantHomePage(), '/home/top'),
                _generateNavigatorPush(context, 'マイページ - top',
                    (context) => UserPage(), '/user/matching'),
                _generateNavigatorPush(context, 'マイページ - プロフィール',
                    (context) => ProfilePage(), '/user/profile'),
                _generateNavigatorPush(context, 'マイページ - マッチング',
                    (context) => MatchingPage(), '/my_page/matching'),
                _generateNavigatorPush(context, 'push通知FCM取得',
                    (context) => FCMDebugPage(), '/fcm_debug'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _generateNavigatorPush(BuildContext context,
      String buttonLabel, WidgetBuilder builder, String routeName) {
    return ElevatedButton(
      child: Text(buttonLabel),
      onPressed: () {
        final route = NoAnimationMaterialPageRoute(
          builder: builder,
          settings: RouteSettings(name: routeName),
        );
        Navigator.push(context, route);
      },
    );
  }
}
