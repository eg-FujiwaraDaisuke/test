import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/domain/entities/tag_category.dart';
import 'package:minden/features/profile_setting/domain/repositories/tag_repository.dart';

// domain - usecase
class UpdateTags extends UseCase<Success, UpdateTagParams> {
  UpdateTags(this.repository);

  final TagRepository repository;

  @override
  Future<Either<Failure, Success>> call(UpdateTagParams params) async {
    return await repository.updateTags(tags: params.tags);
  }
}

class GetAllTags extends UseCase<List<TagCategory>, NoParams> {
  GetAllTags(this.repository);

  final TagRepository repository;

  @override
  Future<Either<Failure, List<TagCategory>>> call(NoParams params) async {
    return await repository.getAllTags();
  }
}

class GetTags extends UseCase<List<Tag>, NoParams> {
  GetTags(this.repository);

  final TagRepository repository;

  @override
  Future<Either<Failure, List<Tag>>> call(NoParams params) async {
    return await repository.getTags();
  }
}

class UpdateTagParams extends Equatable {
  const UpdateTagParams(
    this.tags,
  );

  final List<int> tags;

  @override
  List<Object> get props => [tags];
}
