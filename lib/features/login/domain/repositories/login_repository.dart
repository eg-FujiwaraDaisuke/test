import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/login/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<LoginFailure, User>> getLoginUser(String id, String password);
}
