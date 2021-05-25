// @dart=2.9

import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minden/application.dart';
import 'package:minden/core/env/config.dart';
import 'package:minden/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const env = String.fromEnvironment("DEFINE_BUILD_ENV");
  Config.setEnvironment(env);
  await di.init();

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  if (kReleaseMode) {
    runZonedGuarded(() async {
      runApp(Application());
    }, (e, s) async => await Crashlytics.instance.recordError(e, s));
  } else {
    runApp(Application());
  }
}
