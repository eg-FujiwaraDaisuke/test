// Package imports:
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

/// すべてのクラスでログ出力を簡単にするカスタムhook
///
/// NOTE: Objectに対する拡張関数としたとき、対象関数がクイックフィックスの候補に出てこないため、
/// カスタムhookとして定義している
///
/// NOTE: カスタムhookのお作法をあえて破っているが、使いやすさのため現状の命名としている

final _logger = Logger(
  // NOTE: 色あり出力はコンソール上で文字化けするためOFF
  // https://github.com/leisim/logger/#colors
  printer: PrefixPrinter(PrettyPrinter(colors: false)),
);

void logV(String message) {
  _logger.v(message);
  FirebaseCrashlytics.instance.log(message);
}

void logD(String message) {
  _logger.d(message);
  FirebaseCrashlytics.instance.log(message);
}

void logI(String message) {
  _logger.i(message);
  FirebaseCrashlytics.instance.log(message);
}

void logW(String message) {
  _logger.w(message);
  FirebaseCrashlytics.instance.log(message);
}

void logE(String message, [Error? error, StackTrace? stack]) {
  if (error != null) {
    _logger.e(message, error);
    FirebaseCrashlytics.instance.recordError(error, stack, reason: message);
  } else {
    _logger.e(message);
    FirebaseCrashlytics.instance.log(message);
  }
}
