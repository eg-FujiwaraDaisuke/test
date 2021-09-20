import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';
import 'package:minden/features/profile_setting/domain/repositories/tag_repository.dart';

// data - repository

class TagRepositoryImpl with RetryProcessMixin implements TagRepository {
  const TagRepositoryImpl({
    required this.dataSource,
  });

  final TagDataSource dataSource;

  @override
  Future<Either<Failure, List<TagCategory>>> getAllTags() async {
    try {
      final categories = await retryRequest(() => dataSource.getAllTags());
      return Right(categories);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getTags({required String userId}) async {
    try {
      final tags = await retryRequest(() => dataSource.getTags(userId));
      return Right(tags);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> updateTags({required List<int> tags}) async {
    try {
      final success =
          await retryRequest(() => dataSource.updateTags(tags: tags));
      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getPlantTags(
      {required String plantId}) async {
    try {
      final tags = await retryRequest(() => dataSource.getPlantTags(plantId));
      return Right(tags);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getPlantsTags() async {
    try {
      final tags = await retryRequest(dataSource.getPlantsTags);
      return Right(tags);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
