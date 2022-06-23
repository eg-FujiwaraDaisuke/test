import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/core/success/account.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/Issue_report/presentation/issue_report_dialog_debug_page.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/profile_setting/presentation/pages/profile_setting_name_page.dart';
import 'package:minden/features/reset_password/pages/forgot_password_message_page.dart';
import 'package:minden/features/reset_password/pages/forgot_password_page.dart';
import 'package:minden/features/startup/presentation/pages/initial_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/injection_container.dart';

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
                _generateNavigatorPush(context, '通常遷移',
                    (context) => InitialPage(), InitialPage.routeName),
                _generateNavigatorPush(context, 'ログイン',
                    (context) => LoginPage(), LoginPage.routeName),
                _generateNavigatorPush(context, 'チュートリアル',
                    (context) => TutorialPage(), TutorialPage.routeName),
                _generateNavigatorPush(
                    context,
                    'プロフィール設定',
                    (context) => ProfileSettingNamePage(),
                    '/profileSetting/name'),
                _generateNavigatorPush(context, 'ホーム', (context) => HomePage(),
                    HomePage.routeName),

                // TODO 納品後もとに戻す
                _generateNavigatorPush(context, 'ログイン パスワードリセット',
                    (context) => ForgotPasswordPage(), '/login/forgotPassword'),
                // TODO 納品後もとに戻す
                _generateNavigatorPush(
                    context,
                    'ログイン パスワードリセットメッセージ',
                    (context) => ForgotPasswordMessagePage(loginId: 'debug'),
                    '/login/forgotPasswordMessage'),
                // _generateNavigatorPush(context, 'マイページ - top',
                //     (context) => UserPage(), '/user/matching'),
                // _generateNavigatorPush(context, 'マイページ - プロフィール',
                //     (context) => ProfilePage(), '/user/profile'),
                // _generateNavigatorPush(context, 'push通知FCM取得',
                //     (context) => FCMDebugPage(), '/fcm_debug'),
                _generateNavigatorPush(
                    context,
                    '通報デバックページ',
                    (context) => IssueReportDialogDebugPage(),
                    '/violate_dialog_debug'),
                // DynamicLinks経由起動の場合の、リンク情報を表示する
                // NOTE: DynamicLinksの利用有無が決まったら、削除などを行う
                // DynamicLinksDataPreview(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _generateNavigatorPush(
    BuildContext context,
    String buttonLabel,
    WidgetBuilder builder,
    String routeName,
  ) {
    return ElevatedButton(
      onPressed: () {
        final route = NoAnimationMaterialPageRoute(
          builder: builder,
          settings: RouteSettings(name: routeName),
        );
        Navigator.push(context, route);
      },
      child: Text(buttonLabel),
    );
  }
}

/// DynamicLinks経由で起動されたときのurl情報を表示する
class DynamicLinksDataPreview extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentDynamicLink = useProvider(pendingDynamicLink);
    final streamDynamicLink = useProvider(pendingDynamicLinkStream);
    final createdDynamicLink =
        useProvider(createDynamicLink('powerplant-info/MP000606'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DynamicLinksプレビュー',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        Text('未起動状態から取得: ${awaitLink(currentDynamicLink)}'),
        Text('起動中に取得（stream）: ${awaitLink(streamDynamicLink)}'),
        Text('生成サンプル: ${awaitUri(createdDynamicLink)}'),
      ],
    );
  }

  String awaitLink(AsyncValue<PendingDynamicLinkData?> asyncData) {
    return asyncData.maybeWhen(data: (data) {
      if (data != null) {
        return data.link.toString();
      } else {
        return 'Not found.';
      }
    }, orElse: () {
      return 'Not found.';
    });
  }

  String awaitUri(AsyncValue<Uri?> asyncData) {
    return asyncData.maybeWhen(data: (data) {
      if (data != null) {
        return data.toString();
      } else {
        return 'Not found.';
      }
    }, orElse: () {
      return 'Not found.';
    });
  }
}
