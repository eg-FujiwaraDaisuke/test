import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/domain/repositories/profile_repository.dart';

// domain - usecase
class GetProfile extends UseCase<Profile, GetProfileParams> {
  GetProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, Profile>> call(GetProfileParams params) async {
    return await repository.get(
      userId: params.userId,
    );
  }
}

class GetProfileParams extends Equatable {
  const GetProfileParams(
    this.userId,
  );

  final String userId;

  @override
  List<Object> get props => [userId];
}

// domain - usecase
class UpdateProfile extends UseCase<Profile, UpdateProfileParams> {
  UpdateProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, Profile>> call(UpdateProfileParams params) async {
    return await repository.update(
      name: params.name,
      icon: params.icon,
      bio: params.bio,
      wallPaper: params.wallPaper,
    );
  }
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams(
    this.name,
    this.icon,
    this.bio,
    this.wallPaper,
  );

  final String name;
  final String icon;
  final String bio;
  final String wallPaper;

  @override
  List<Object> get props => [name];
}
