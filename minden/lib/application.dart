import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:minden/features/debug/debug_page.dart';
import 'package:minden/features/debug/debug_push_message_page.dart';
import 'package:minden/features/home/presentation/pages/home_page.dart';
import 'package:minden/features/localize/data/datasources/localized_info_datasource.dart';
import 'package:minden/features/localize/data/repositories/localized_info_repository_impl.dart';
import 'package:minden/features/localize/domain/usecases/localized_usecase.dart';
import 'package:minden/features/localize/presentation/bloc/localized_bloc.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/data/repositories/login_repository_impl.dart';
import 'package:minden/features/login/data/repositories/logout_repository_impl.dart';
import 'package:minden/features/login/domain/usecases/login_usecase.dart';
import 'package:minden/features/login/domain/usecases/logout_usecase.dart';
import 'package:minden/features/login/presentation/bloc/login_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_state.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/matching/pages/matching_page.dart';
import 'package:minden/features/message/data/datasources/message_datasource.dart';
import 'package:minden/features/message/data/repositories/message_repository_impl.dart';
import 'package:minden/features/message/domain/usecases/message_usecase.dart';
import 'package:minden/features/message/presentation/bloc/message_bloc.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/features/uploader/data/datasources/media_datasource.dart';
import 'package:minden/features/uploader/data/repositories/media_repository_impl.dart';
import 'package:minden/features/uploader/domain/usecases/media_usecase.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_bloc.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/injection_container.dart';

class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocalizedBloc>(
          create: (BuildContext context) => LocalizedBloc(
            LocalizedStateEmpty(),
            GetLocalizedEvent(
              LocalizedInfoRepositoryImpl(
                dataSource: LocalizedInfoDataSourceImpl(),
              ),
            ),
          ),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(
            const LoginInitial(),
            GetLoginUser(
              LoginRepositoryImpl(
                userDataSource: UserDataSourceImpl(client: http.Client()),
              ),
            ),
          ),
        ),
        BlocProvider<UploadBloc>(
          create: (BuildContext context) => UploadBloc(
            const UploadInitial(),
            UploadMedia(
              MediaRepositoryImpl(
                dataSource: MediaDataSourceImpl(client: http.Client()),
              ),
            ),
          ),
        ),
        BlocProvider<LogoutBloc>(
          create: (BuildContext context) => LogoutBloc(
            LogoutStateInitial(),
            LogoutUser(
              LogoutRepositoryImpl(
                userDataSource: UserDataSourceImpl(client: http.Client()),
              ),
            ),
          ),
        ),
        BlocProvider<GetMessagesBloc>(
          create: (BuildContext context) => GetMessagesBloc(
            const MessageInitial(),
            GetMessages(
              MessageRepositoryImpl(
                dataSource: MessageDataSourceImpl(
                  client: http.Client(),
                ),
              ),
            ),
          ),
        )
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
          indicatorColor: const Color(0xFFFF8C00),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          tabBarTheme: const TabBarTheme().copyWith(
            labelPadding: const EdgeInsets.symmetric(vertical: 12),
            labelColor: Colors.black,
            labelStyle: const TextStyle(
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
            unselectedLabelColor: Colors.black.withOpacity(0.7),
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              letterSpacing: 0.2,
            ),
          ),
        ),
        supportedLocales: const [
          Locale('ja'),
          Locale('en'),
        ],
        routes: _buildRoutes(),
      ),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return <String, WidgetBuilder>{
      '/': (_) {
        // TODO 納品後もとに戻す
        if (kReleaseMode) {
          return DebugPage();
        } else {
          return DebugPage();
        }
      },
      '/tutorial': (_) => TutorialPage(),
      '/home': (_) => HomePage(),
      '/login': (_) => LoginPage(),
      '/home/top': (_) => PowerPlantHomePage(),
      '/my_page/matching': (_) => MatchingPage(),
      '/user': (_) => UserPage(),
      '/user/profile/edit': (_) => ProfileEditPage(),
      '/message': (_) => MessageView(),
    };
  }
}
