import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/provider/app_badge_manager_provider.dart';
import 'package:minden/features/debug/debug_page.dart';
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
import 'package:minden/features/message/presentation/pages/message_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_page.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/startup/presentation/pages/initial_page.dart';
import 'package:minden/features/startup/presentation/pages/tutorial_page.dart';
import 'package:minden/features/transition_screen/presentation/bloc/transition_screen_bloc.dart';
import 'package:minden/features/uploader/data/datasources/media_datasource.dart';
import 'package:minden/features/uploader/data/repositories/media_repository_impl.dart';
import 'package:minden/features/uploader/domain/usecases/media_usecase.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_bloc.dart';
import 'package:minden/features/uploader/presentation/bloc/upload_state.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/data/repositories/profile_repository_impl.dart';
import 'package:minden/features/user/domain/usecases/profile_usecase.dart';
import 'package:minden/features/user/presentation/bloc/profile_bloc.dart';
import 'package:minden/features/user/presentation/bloc/profile_state.dart';
import 'package:minden/features/user/presentation/pages/profile_edit_page.dart';
import 'package:minden/features/user/presentation/pages/user_page.dart';
import 'package:minden/injection_container.dart';

class Application extends HookConsumerWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBadgeManager = ref.watch(appBadgeManagerProvider);

    useEffect(() {
      // EventBusで管理している未読件数変化に応じて、未読バッジ数に反映する
      ref
          .watch(unreadBadgeCountProvider.notifier)
          .addListener(appBadgeManager.setCount);
      // アプリがバックグラウンドにいる or プロセスkillされた状態のメッセージ受信検知
      FirebaseMessaging.onBackgroundMessage(
          (message) => appBadgeManager.incrementCount());
      // アプリがフォアグラウンドにいる状態のメッセージ受信検知
      FirebaseMessaging.onMessage.listen((event) {
        appBadgeManager.incrementCount();
      });
      return null;
    }, []);
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
        ),
        BlocProvider<GetShowBadgeBloc>(
          create: (BuildContext context) => GetShowBadgeBloc(
            const MessageInitial(),
            GetMessages(
              MessageRepositoryImpl(
                dataSource: MessageDataSourceImpl(
                  client: http.Client(),
                ),
              ),
            ),
          ),
        ),
        BlocProvider<TransitionScreenBloc>(
          create: (BuildContext context) => TransitionScreenBloc(
            const TransitionScreenInitial(),
          ),
        ),
        BlocProvider<ProfileBloc>(
            create: (BuildContext context) => ProfileBloc(
                const ProfileStateInitial(),
                GetProfile(
                  ProfileRepositoryImpl(
                    dataSource: ProfileDataSourceImpl(
                      client: http.Client(),
                    ),
                  ),
                ),
                UpdateProfile(
                  ProfileRepositoryImpl(
                    dataSource: ProfileDataSourceImpl(
                      client: http.Client(),
                    ),
                  ),
                ))),
        BlocProvider<GetTagsBloc>(
            create: (context) => GetTagsBloc(
                  const TagStateInitial(),
                  GetTags(
                    TagRepositoryImpl(
                      dataSource: TagDataSourceImpl(
                        client: http.Client(),
                      ),
                    ),
                  ),
                )),
        BlocProvider<UpdateTagBloc>(
            create: (context) => UpdateTagBloc(
                  const TagStateInitial(),
                  UpdateTags(
                    TagRepositoryImpl(
                      dataSource: TagDataSourceImpl(
                        client: http.Client(),
                      ),
                    ),
                  ),
                ))
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
    final routes = <String, WidgetBuilder>{
      InitialPage.routeName: (_) {
        if (kReleaseMode) {
          return InitialPage();
        } else {
          return DebugPage();
        }
      },
      TutorialPage.routeName: (_) => TutorialPage(),
      HomePage.routeName: (_) => HomePage(),
      LoginPage.routeName: (_) => LoginPage(),
      PowerPlantHomePage.routeName: (_) => PowerPlantHomePage(),
      MatchingPage.routeName: (_) => MatchingPage(),
      UserPage.routeName: (_) => UserPage(),
      ProfileEditPage.routeName: (_) => ProfileEditPage(),
      MessagePage.routeName: (_) => MessagePage(),
    };

    // routeName定数化により一覧性が無くなってしまったため、ログに出力する
    logD('routes on MaterialApp.\n${routes.entries.join('\n')}');

    return routes;
  }
}
