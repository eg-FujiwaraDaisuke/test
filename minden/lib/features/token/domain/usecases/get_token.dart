import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/token/domain/entities/token.dart';
import 'package:minden/features/token/domain/repositories/token_repository.dart';

class GetToken extends UseCase<Token, Params> {
  GetToken(this.tokenRepository);

  final TokenRepository tokenRepository;

  @override
  Future<Either<TokenFailure, Token>> call(Params params) async {
    return tokenRepository.getToken(params.refreshToken);
  }
}

class Params extends Equatable {
  const Params({required this.refreshToken});

  final String refreshToken;

  @override
  List<Object> get props => [refreshToken];
}
