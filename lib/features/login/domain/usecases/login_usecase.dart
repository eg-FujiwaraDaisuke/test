import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';

class GetLoginUser extends UseCase<User, Params> {
  GetLoginUser(this.loginRepository);

  final LoginRepository loginRepository;

  @override
  Future<Either<LoginFailure, User>> call(Params params) async {
    return await loginRepository.getLoginUser(params.id, params.password);
  }
}

class Params extends Equatable {
  const Params({required this.id, required this.password});

  final String id;
  final String password;

  @override
  List<Object> get props => [id, password];
}
