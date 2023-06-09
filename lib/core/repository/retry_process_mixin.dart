import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:minden/injection_container.dart';
import 'package:retry/retry.dart' as backoff;

mixin RetryProcessMixin {
  /// http requestでの401エラーが発生した場合に自動的にリトライする
  /// リトライは指数バックオフで行います
  Future<T> retryRequest<T>(FutureOr<T> Function() function) async {
    try {
      return await backoff.retry(
        () => function(),
        retryIf: (e) async {
          if (e is TokenExpiredException) {
            logD('#### retry ####');
            try {
              final dataSource = TokenDataSourceImpl(
                client: http.Client(),
                encryptionTokenDataSource: si<EncryptionTokenDataSourceImpl>(),
              );
              await dataSource.getAppToken(true);
            } catch (e) {
              logD('### refresh token expired error $e');
              rethrow;
            }
            return true;
          }
          return false;
        },
        delayFactor: const Duration(seconds: 3),
        maxDelay: const Duration(seconds: 32),
        maxAttempts: 3,
      );
    } catch (otherError) {
      rethrow;
    }
  }
}
