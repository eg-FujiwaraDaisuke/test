import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/localize/domain/entities/localized_info.dart';
import 'package:minden/features/localize/domain/repositories/localized_repository.dart';

// domain - usecase

class GetLocalizedInfo extends UseCase<LocalizedInfo, LocalizedInfoParams> {
  final LocalizedRepository repository;

  GetLocalizedInfo(this.repository);

  Future<Either<Failure, LocalizedInfo>> call(
      LocalizedInfoParams params) async {
    return await repository.getLocalizedInfo(params.languageCode);
  }

  Future<Either<Failure, LocalizedInfo>> update(
      LocalizedInfoParams params) async {
    return await repository.updateLocalizedInfo(params.languageCode);
  }
}

class LocalizedInfoParams extends Equatable {
  final String languageCode;

  LocalizedInfoParams(this.languageCode);

  @override
  List<Object> get props => [languageCode];
}