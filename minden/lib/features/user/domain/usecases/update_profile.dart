import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/domain/repositories/profile_repository.dart';

// domain - usecase
class UpdateProfile extends UseCase<Profile, ProfileParams> {
  UpdateProfile(this.repository);

  final ProfileRepository repository;

  Future<Either<Failure, Profile>> call(ProfileParams params) async {
    return await repository.update(
      name: params.name,
      icon: params.icon,
      bio: params.bio,
      wallPaper: params.wallPaper,
    );
  }
}

class ProfileParams extends Equatable {
  const ProfileParams(
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
