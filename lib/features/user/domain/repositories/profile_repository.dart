import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> update({
    required String name,
    required String icon,
    required String bio,
    required String wallPaper,
    required String freeLink,
    required String twitterLink,
    required String facebookLink,
    required String instagramLink,
  });

  Future<Either<Failure, Profile>> get({
    required String userId,
  });
}
