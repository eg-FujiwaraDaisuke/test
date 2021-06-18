import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minden/features/localize/data/datasources/localized_info_datasource.dart';
import 'package:minden/features/localize/data/repositories/localized_info_repository_impl.dart';
import 'package:minden/features/localize/domain/usecases/get_localized_info.dart';
import 'package:minden/features/localize/presentation/bloc/localized_bloc.dart';
import 'package:minden/features/localize/presentation/bloc/localized_state.dart';
import 'features/startup/presentation/pages/initial_page.dart';
import 'injection_container.dart';

class Application extends StatelessWidget {
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
        supportedLocales: [
          const Locale('ja'),
          const Locale('en'),
        ],
        home: InitialPage(),
      ),
    );
  }
}
