import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final firebaseApp = await Firebase.initializeApp();

  final remoteConfig = await RemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

  final analytics = FirebaseAnalytics();
  final firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(analytics: analytics);

  final botToastNavigatorObserver = BotToastNavigatorObserver();

  final FlutterI18nDelegate flutterI18nDelegate = FlutterI18nDelegate(
    translationLoader: FileTranslationLoader(
        useCountryCode: false,
        fallbackFile: 'ja',
        basePath: 'assets/i18n',
        forcedLocale: Locale('ja')),
  );
  await flutterI18nDelegate.load(null);

  sl.registerLazySingleton(() => firebaseApp);
  sl.registerLazySingleton(() => remoteConfig);
  sl.registerLazySingleton(() => firebaseAnalyticsObserver);
  sl.registerLazySingleton(() => botToastNavigatorObserver);
  sl.registerLazySingleton(() => flutterI18nDelegate);
}
