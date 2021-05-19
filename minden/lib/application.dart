import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:minden/features/startup/presentation/bloc/startup_bloc.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<StartupBloc>(
          create: (BuildContext context) => sl(),
        ),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        title: 'Minden app',
        navigatorObservers: [
          sl<BotToastNavigatorObserver>(),
          sl<FirebaseAnalyticsObserver>()
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // This is required
        ],
        home: InitialPage(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
