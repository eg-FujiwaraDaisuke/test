import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:retry/retry.dart' as backoff;

import '../../injection_container.dart';

mixin RetryProcessMixin {
  /// http requestでの401エラーが発生した場合に自動的にリトライする
  /// リトライは指数バックオフで行います
  Future<T> retryRequest<T>(FutureOr<T> Function() function) async {
    try {
      return await backoff.retry(
        () => function(),
        retryIf: (e) async {
          if (e is TokenExpiredException) {
            final dataSource = TokenDataSourceImpl(
              client: http.Client(),
              encryptionTokenDataSource: si<EncryptionTokenDataSourceImpl>(),
            );
            await dataSource.getAppToken(true);
            return true;
          }
          return false;
        },
        delayFactor: const Duration(seconds: 1),
        maxDelay: const Duration(seconds: 32),
        maxAttempts: 2,
      );
    } catch (otherError) {
      rethrow;
    }
  }
}