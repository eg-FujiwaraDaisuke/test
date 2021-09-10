import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/features/uploader/data/datasources/media_datasource.dart';
import 'package:minden/features/uploader/domain/entities/media.dart';
import 'package:minden/features/uploader/domain/repositories/media_repository.dart';

// data - repository

class MediaRepositoryImpl
    with RetryProcessMixin
    implements MediaRepository {
  const MediaRepositoryImpl({
    required this.dataSource,
  });

  final MediaDataSource dataSource;

  @override
  Future<Either<Failure, Media>> upload(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final Media =
          await retryRequest(() => dataSource.upload(bytes: bytes));
      return Right(Media);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
