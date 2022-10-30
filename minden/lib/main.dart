// @dart=2.9

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/application.dart';
import 'package:minden/core/env/config.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/core/provider/package_info_provider.dart';
import 'package:minden/injection_container.dart' as di;
import 'package:package_info/package_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment('DEFINE_BUILD_ENV');
  Config.setEnvironment(env);
  await di.init();
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
