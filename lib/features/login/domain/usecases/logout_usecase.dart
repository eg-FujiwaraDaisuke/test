import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/login/domain/repositories/logout_repository.dart';

class LogoutUser extends UseCase<Success, NoParams> {
  LogoutUser(this.logoutRepository);

  final LogoutRepository logoutRepository;

  @override
  Future<Either<Failure, Success>> call(NoParams params) async {
    return await logoutRepository.logoutUser();
  }
}
