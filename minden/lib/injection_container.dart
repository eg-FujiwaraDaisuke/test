import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_i18n/loaders/file_translation_loader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';

// singleton instance
final si = GetIt.instance;

Future<void> init() async {
  final firebaseApp = await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final RemoteConfig remoteConfig = RemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 0),
    minimumFetchInterval: const Duration(hours: 1),
  ));

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
  await flutterI18nDelegate.load(Locale('ja'));

  /// Create a [AndroidNotificationChannel] for heads up notifications
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  if (!kIsWeb) {
    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // フォアグラウンド状態の通知
    // Android ではアプリがフォアグラウンド状態で画面上部にプッシュ通知メッセージを表示することができない為、ローカル通知で擬似的に通知メッセージを表示
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("フォアグラウンドでメッセージを受け取りました");
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        print('表示');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'launch_background',
              ),
            ));
      }
    });
  }

  // 暗号化して保存しているTokenを提供するDataSource実装
  const encryptionTokenDataSource =
      EncryptionTokenDataSourceImpl(secureStorage: FlutterSecureStorage());

  si
    ..registerLazySingleton(() => firebaseApp)
    ..registerLazySingleton(() => remoteConfig)
    ..registerLazySingleton(() => firebaseAnalyticsObserver)
    ..registerLazySingleton(() => botToastNavigatorObserver)
    ..registerLazySingleton(() => flutterI18nDelegate)
    ..registerLazySingleton(() => firebaseMessaging)
    ..registerLazySingleton(() => encryptionTokenDataSource);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("バックグラウンドでメッセージを受け取りました");
  print('Handling a background message ${message.messageId}');
}
