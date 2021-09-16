import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';
import 'package:minden/features/localize/domain/repositories/localized_repository.dart';

// domain - usecase

class GetLocalizedEvent extends UseCase<Localized, LocalizedInfoParams> {
  GetLocalizedEvent(this.repository);

  final LocalizedRepository repository;

  Future<Either<Failure, Localized>> call(LocalizedInfoParams params) async {
    return await repository.getLocalizedInfo(params.languageCode);
  }

  Future<Either<Failure, Localized>> update(LocalizedInfoParams params) async {
    return await repository.updateLocalizedInfo(params.languageCode);
  }
}

class LocalizedInfoParams extends Equatable {
  const LocalizedInfoParams(this.languageCode);

  final String languageCode;

  @override
  List<Object> get props => [languageCode];
}
