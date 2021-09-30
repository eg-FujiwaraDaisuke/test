import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';

abstract class FcmTokenRepository {
  Future<Either<Failure, Success>> updateFcmToken(String fcmToken);
}
