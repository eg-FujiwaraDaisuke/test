import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/fcm/domain/repositories/fcm_token_repository.dart';

class UpdateFcmToken extends UseCase<Success, Params> {
  UpdateFcmToken(this.fcmTokenRepository);
  final FcmTokenRepository fcmTokenRepository;

  @override
  Future<Either<Failure, Success>> call(Params params) async {
    return await fcmTokenRepository.updateFcmToken(params.fcmToken);
  }
}

class Params extends Equatable {
  const Params({required this.fcmToken});

  final String fcmToken;

  @override
  List<Object> get props => [fcmToken];
}
