// @dart=2.9

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:minden/application.dart';
import 'package:minden/core/env/config.dart';
import 'package:minden/core/event_bus/event.dart';
import 'package:minden/core/event_bus/event_bus.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/core/provider/package_info_provider.dart';
import 'package:minden/injection_container.dart' as di;
import 'package:minden/injection_container.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final box = await Hive.openBox('notificationCountBox');
  final int numMessageUnread= box.get('messageUnread') ?? 0;
  if (await FlutterAppBadger.isAppBadgeSupported()) {
    FlutterAppBadger.updateBadgeCount(numMessageUnread+1);
  }
}

Future<void> initNotificationCounter() async {
  final box = await Hive.openBox('notificationCountBox');
  eventBus.on<NotificationCounterEvent>().listen((event) async {
    await box.put('messageUnread',event.count);
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.updateBadgeCount(box.get('messageUnread'));
    }
    if (event.count == 0) {
      await si<FlutterLocalNotificationsPlugin>().cancelAll();
      FlutterAppBadger.removeBadge();
    }
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment('DEFINE_BUILD_ENV');
  Config.setEnvironment(env);
  await di.init();
  await Firebase.initializeApp();
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // DynamicLinksをRiverpod経由で使うため
  final dynamicLinks = FirebaseDynamicLinks.instance;

  final packageInfo = await PackageInfo.fromPlatform();

  await runZonedGuarded(
    () async {
      runApp(
        ProviderScope(
          overrides: [
            dynamicLinksProvider.overrideWithValue(dynamicLinks),
            packageInfoProvider.overrideWithValue(packageInfo),
          ],
          child: const Application(),
        ),
      );
    },
    (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
