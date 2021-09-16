import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';
import 'package:minden/features/localize/domain/repositories/localized_repository.dart';

// domain - usecase

class GetLocalizedEvent extends UseCase<Localized, LocalizedInfoParams> {
  final LocalizedRepository repository;

  GetLocalizedEvent(this.repository);

  Future<Either<Failure, Localized>> call(
      LocalizedInfoParams params) async {
    return await repository.getLocalizedInfo(params.languageCode);
  }

  Future<Either<Failure, Localized>> update(
      LocalizedInfoParams params) async {
    return await repository.updateLocalizedInfo(params.languageCode);
  }
}

class LocalizedInfoParams extends Equatable {
  final String languageCode;

  const LocalizedInfoParams(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}
