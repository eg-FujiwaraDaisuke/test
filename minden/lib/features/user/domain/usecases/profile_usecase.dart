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
      freeLink: params.freeLink,
      twitterLink: params.twitterLink,
      facebookLink: params.facebookLink,
      instagramLink: params.instagramLink,
    );
  }
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams(
    this.name,
    this.icon,
    this.bio,
    this.wallPaper,
    this.freeLink,
    this.twitterLink,
    this.facebookLink,
    this.instagramLink,
  );

  final String name;
  final String icon;
  final String bio;
  final String wallPaper;
  final String freeLink;
  final String twitterLink;
  final String facebookLink;
  final String instagramLink;

  @override
  List<Object> get props => [name];
}
