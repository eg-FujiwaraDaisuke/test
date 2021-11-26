import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/reset_password/data/datasources/reset_password_repository_datasource.dart';
import 'package:minden/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPasswordRepositoryImpl implements ResetPasswordRepository {
  const ResetPasswordRepositoryImpl({required this.dataSource});
  final ResetPasswordDataSource dataSource;

  @override
  Future<Either<Failure, Success>> resetPassword(
      {required String loginId}) async {
    try {
      final success = await dataSource.resetPassword(loginId: loginId);
      return Right(success);
    } on ResetPasswordException catch (e) {
      return Left(
          ResetPasswordFailure(statusCode: e.statusCode, message: e.message));
    }
  }

  @override
  Future<Either<Failure, Success>> updatePassword(
      {required String loginId,
      required String confirmationCode,
      required String newPassword}) async {
    try {
      final success = await dataSource.updatePassword(
          loginId: loginId,
          confirmationCode: confirmationCode,
          newPassword: newPassword);
      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
