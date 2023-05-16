import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

/// すべてのクラスでログ出力を簡単にする拡張関数
/// 拡張関数のimportがしばらく対応されなさそうなため、flutter_hooksで同様の実装を行った
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
