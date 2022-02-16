import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';

// domain - repository

abstract class LocalizedRepository {
  Future<Either<Failure, Localized>> getLocalizedInfo(String languageCode);
  Future<Either<Failure, Localized>> updateLocalizedInfo(String languageCode);
}
