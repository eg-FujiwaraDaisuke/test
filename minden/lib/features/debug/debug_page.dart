import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/camera/pages/camera_mock_page.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/startup/presentation/pages/initial_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/features/user/presentation/pages/user_profile_page.dart';

/// デバッグ用画面
/// デバッグビルド時のみ遷移可能で、各画面への遷移や機能呼び出しを提供する
/// NOTE: 本画面を利用する場合、通常と異なる遷移となるため、
/// Navigator関係の不具合が疑われる際は、本画面実装に起因するものか切り分けした上で調査されたし
class DebugPage extends StatelessWidget {
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
                    context, '通常遷移', (context) => InitialPage(), '/'),
                _generateNavigatorPush(context, 'マイページ - top',
                    (context) => UserPage(), '/user/matching'),
                _generateNavigatorPush(context, 'マイページ - プロフィール',
                    (context) => UserProfilePage(), '/user/profile'),
                _generateNavigatorPush(context, 'マイページ - マッチング',
                    (context) => MatchingPage(), '/my_page/matching'),
                _generateNavigatorPush(context, '画像選択Camera or Gallery',
                    (context) => CameraMock(), '/camera_mock'),
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
        Navigator.pushReplacement(context, route);
      },
    );
  }
}
