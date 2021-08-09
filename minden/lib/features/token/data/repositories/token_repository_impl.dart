import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:minden/features/token/domain/entities/token.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

class TokenRepositoryImpl implements TokenRepository {
  const TokenRepositoryImpl({required this.tokenDataSource});

  final TokenDataSource tokenDataSource;

  @override
  Future<Either<TokenFailure, Token>> getToken(String refreshToken) async {
    try {
      final token = await tokenDataSource.getToken(refreshToken);
      return Right(token);
    } on ServerException {
      return left(TokenFailure());
    }
  }
}
