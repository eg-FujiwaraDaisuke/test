import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/localize/data/datasources/localized_info_datasource.dart';
import 'package:minden/features/localize/domain/entities/localized.dart';
import 'package:minden/features/localize/domain/repositories/localized_repository.dart';

// data - repository

class LocalizedInfoRepositoryImpl implements LocalizedRepository {
  LocalizedInfoRepositoryImpl({
    required this.dataSource,
  });

  final LocalizedInfoDataSource dataSource;

  @override
  Future<Either<Failure, Localized>> getLocalizedInfo(
      String languageCode) async {
    try {
      final localizedInfo =
          await dataSource.getLocalizedInfo(osLanguageCode: languageCode);
      print('[get localized info] ${localizedInfo.toJson().toString()}');
      return Right(localizedInfo);
    } on LocalCacheException {
      return Left(LocalCacheFailure());
    }
  }

  @override
  Future<Either<Failure, Localized>> updateLocalizedInfo(
      String languageCode) async {
    try {
      final localizedInfo = await dataSource.updateLocalizedInfo(languageCode);
      print('[update localized info] ${localizedInfo.toJson().toString()}');
      return Right(localizedInfo);
    } on LocalCacheException {
      return Left(LocalCacheFailure());
    }
  }
}
