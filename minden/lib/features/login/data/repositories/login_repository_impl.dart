import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final UserDataSource userDataSource;

  LoginRepositoryImpl({required this.userDataSource});

  @override
  Future<Either<LoginFailure, User>> getLoginUser(
    String id,
    String password,
  ) async {
    try {
      final user = await userDataSource.getLoginUser(id, password);
      return Right(user);
    } on ServerException {
      return left(LoginFailure());
    }
  }
}
