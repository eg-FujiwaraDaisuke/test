import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagCategory>>> getAllTags();

  Future<Either<Failure, List<Tag>>> getTags();

  Future<Either<Failure, List<Tag>>> getPlantsTags();

  Future<Either<Failure, List<Tag>>> getPlantTags(
      {required String plantId});

  Future<Either<Failure, Success>> updateTags({
    required List<int> tags,
  });
}
