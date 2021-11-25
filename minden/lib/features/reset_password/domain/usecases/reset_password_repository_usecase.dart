import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/reset_password/domain/repositories/reset_password_repository.dart';

class ResetPassword extends UseCase<Success, ResetPasswordParams> {
  ResetPassword(this.repository);
  final ResetPasswordRepository repository;

  @override
  Future<Either<Failure, Success>> call(ResetPasswordParams params) async {
    return await repository.resetPassword(loginId: params.loginId);
  }
}

class UpdatePassword extends UseCase<Success, UpdatePasswordParams> {
  UpdatePassword(this.repository);
  final ResetPasswordRepository repository;

  @override
  Future<Either<Failure, Success>> call(UpdatePasswordParams params) async {
    return await repository.updatePassword(
      loginId: params.loginId,
      confirmationCode: params.confirmationCode,
      newPassword: params.newPassword,
    );
  }
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({required this.loginId});
  final String loginId;

  @override
  List<Object> get props => [loginId];
}

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams(
      {required this.loginId,
      required this.confirmationCode,
      required this.newPassword});

  final String loginId;
  final String confirmationCode;
  final String newPassword;

  @override
  List<Object> get props => [loginId, confirmationCode, newPassword];
}
