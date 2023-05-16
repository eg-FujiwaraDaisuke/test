import 'package:dartz/dartz.dart';

import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/fcm/data/datasources/fcm_token_data_source.dart';
import 'package:minden/features/fcm/domain/repositories/fcm_token_repository.dart';

class FcmTokenRepositoryImpl implements FcmTokenRepository {
  FcmTokenRepositoryImpl({required this.fcmTokenDataSource});
  final FcmTokenDataSource fcmTokenDataSource;

  @override
  Future<Either<Failure, Success>> updateFcmToken(String fcmToken) async {
    try {
      final status = await fcmTokenDataSource.updateFcmToken(fcmToken);
      return Right(status);
    } on ServerException {
      return left(Failure());
    }
  }
}
