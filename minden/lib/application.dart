import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minden/features/debug/debug_page.dart';
import 'package:minden/features/localize/data/datasources/localized_info_datasource.dart';
import 'package:minden/features/localize/data/repositories/localized_info_repository_impl.dart';
import 'package:minden/features/localize/domain/usecases/get_localized_info.dart';
import 'package:minden/features/localize/presentation/bloc/localized_bloc.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/power_plant/pages/power_plant_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/features/user/presentation/pages/user_profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/user_profile_page.dart';

import 'core/ui/tab_indicator.dart';

import 'features/debug/debug_push_message_page.dart';
import 'features/startup/presentation/pages/initial_page.dart';
import 'injection_container.dart';

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
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
        Navigator.pushNamed(
          context,
          '/message',
          arguments: MessageArguments(message, openedApplication: true),
        );
      }
    });

    // バックグラウンド状態でプッシュ通知メッセージからアプリを起動した場合の遷移
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message);
      print('=========================== バックグラウンド状態');
      Navigator.pushNamed(
        context,
        '/message',
        arguments: MessageArguments(message, openedApplication: true),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizedBloc>(
          create: (BuildContext context) => LocalizedBloc(
            LocalizedStateEmpty(),
            GetLocalizedInfo(
              LocalizedInfoRepositoryImpl(
                dataSource: LocalizedInfoDataSourceImpl(),
              ),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        title: 'Minden app',
        navigatorObservers: [
          si<BotToastNavigatorObserver>(),
          si<FirebaseAnalyticsObserver>()
        ],
        localizationsDelegates: [
          si<FlutterI18nDelegate>(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
        ],
        theme: ThemeData(
            tabBarTheme: TabBarTheme().copyWith(
                indicator: TabIndicator(),
                labelPadding: EdgeInsets.symmetric(vertical: 12.0),
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
                unselectedLabelColor: Colors.black.withOpacity(0.7),
                unselectedLabelStyle: TextStyle(
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ))),
        supportedLocales: [
          const Locale('ja'),
          const Locale('en'),
        ],
        routes: _buildRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return <String, WidgetBuilder>{
      "/": (_) {
        if (kReleaseMode) {
          return InitialPage();
        } else {
          return DebugPage();
        }
      },
      "/tutorial": (_) => TutorialPage(),
      "/login": (_) => LoginPage(),
      "/home/top": (_) => HomeTopPage(),
      "/my_page/matching": (_) => MatchingPage(),
      "/user": (_) => UserPage(),
      "/user/profile": (_) => UserProfilePage(),
      "/user/profile/edit": (_) => UserProfileEditPage(),
      '/message': (_) => MessageView(),
    };
  }
}
