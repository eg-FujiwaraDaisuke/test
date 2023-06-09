import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/token/domain/entities/token.dart';

abstract class TokenRepository {
  Future<Either<RenewTokenFailure, Token>> getToken(String refreshToken);
}
