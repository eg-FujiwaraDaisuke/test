import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/localize/domain/entities/localized_info.dart';

// domain - repository

abstract class LocalizedRepository {
  Future<Either<Failure, LocalizedInfo>> getLocalizedInfo(String languageCode);
  Future<Either<Failure, LocalizedInfo>> updateLocalizedInfo(String languageCode);
}
