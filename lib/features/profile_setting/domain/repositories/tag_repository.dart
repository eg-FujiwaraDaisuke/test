import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';

abstract class TagRepository {
  Future<Either<Failure, List<TagCategory>>> getAllTags();

  Future<Either<Failure, List<Tag>>> getTags({required String userId});

  Future<Either<Failure, List<Tag>>> getPlantsTags();

  Future<Either<Failure, List<Tag>>> getPlantTags({required String plantId});

  Future<Either<Failure, Success>> updateTags({
    required List<int> tags,
  });
}
