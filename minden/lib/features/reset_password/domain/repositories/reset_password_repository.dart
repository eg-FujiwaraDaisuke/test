import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';

abstract class ResetPasswordRepository {
  Future<Either<ResetPasswordFailure, Success>> resetPassword(
      {required String loginId});
  Future<Either<ResetPasswordFailure, Success>> updatePassword(
      {required String loginId,
      required String confirmationCode,
      required String newPassword});
}
