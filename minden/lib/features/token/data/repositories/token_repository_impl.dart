import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/token/data/datasources/token_data_source.dart';
import 'package:minden/features/token/domain/entities/token.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

final tokenRepositoryProvider = Provider<TokenRepository>((ref) =>
    TokenRepositoryImpl(tokenDataSource: ref.read(tokenDataSourceProvider)));

class TokenRepositoryImpl implements TokenRepository {
  const TokenRepositoryImpl({required this.tokenDataSource});

  final TokenDataSource tokenDataSource;

  @override
  Future<Either<RenewTokenFailure, Token>> getToken(String refreshToken) async {
    try {
      final token = await tokenDataSource.requestRefreshToken(refreshToken);
      return Right(token);
    } on ServerException {
      return left(RenewTokenFailure());
    }
  }
}
