import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagCategory>>> getAllTags();

  Future<Either<Failure, List<TagCategory>>> getTags();

  Future<Either<Failure, List<TagCategory>>> getPlantsTags();

  Future<Either<Failure, List<TagCategory>>> getPlantTags(
      {required String plantId});

  Future<Either<Failure, Success>> updateTags({
    required List<int> tags,
  });
}
