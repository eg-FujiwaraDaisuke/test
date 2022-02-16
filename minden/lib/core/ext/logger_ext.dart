import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

/// すべてのクラスでログ出力を簡単にする拡張関数
///
/// NOTE: 現在、dartの問題なのか拡張関数がクイックフィックスの候補に出てこないため、
/// 手動でimportする必要がある
/// https://github.com/dart-lang/sdk/issues/38894
///
/// NOTE: 未importなファイル内で使用する場合、 `LoggerExt` とタイプしてimportするとお手軽
extension LoggerExt on dynamic {
  void logV(String message) {
    logger.v(message);
  }

  void logD(String message) {
    logger.d(message);
  }

  void logI(String message) {
    logger.i(message);
  }

  void logW(String message) {
    logger.w(message);
  }

  void logE(String message, [Error? error]) {
    logger.e(message, error);
  }
}
