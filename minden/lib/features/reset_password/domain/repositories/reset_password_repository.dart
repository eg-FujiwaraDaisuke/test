import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';

abstract class ResetPasswordRepository {
  Future<Either<Failure, Success>> resetPassword({required String loginId});
  Future<Either<Failure, Success>> updatePassword(
      {required String loginId,
      required String confirmationCode,
      required String newPassword});
}
