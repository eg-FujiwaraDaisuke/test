import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';

class GetLoginUser {
  final LoginRepository loginRepository;
  GetLoginUser(this.loginRepository);

  Future<Either<LoginFailure, User>> execute(
      {required String id, required String password}) async {
    return await loginRepository.getLoginUser(id, password);
  }
}
