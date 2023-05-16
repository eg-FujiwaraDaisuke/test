import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/login/data/datasources/user_data_source.dart';
import 'package:minden/features/login/domain/repositories/logout_repository.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  LogoutRepositoryImpl({required this.userDataSource});

  final UserDataSource userDataSource;

  @override
  Future<Either<Failure, Success>> logoutUser() async {
    try {
      final status = await userDataSource.logoutUser();
      return Right(status);
    } on ServerException {
      return left(Failure());
    }
  }
}
