import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/features/user/data/datasources/profile_datasource.dart';
import 'package:minden/features/user/domain/entities/profile.dart';
import 'package:minden/features/user/domain/repositories/profile_repository.dart';

// data - repository

class ProfileRepositoryImpl
    with RetryProcessMixin
    implements ProfileRepository {
  const ProfileRepositoryImpl({
    required this.dataSource,
  });

  final ProfileDataSource dataSource;

  @override
  Future<Either<Failure, Profile>> update({
    required String name,
    required String icon,
    required String bio,
    required String wallPaper,
    required String freeLink,
    required String twitterLink,
    required String facebookLink,
    required String instagramLink,
  }) async {
    try {
      final profile = await retryRequest(() => dataSource.update(
            name: name,
            icon: icon,
            bio: bio,
            wallPaper: wallPaper,
            freeLink: freeLink,
            twitterLink: twitterLink,
            facebookLink: facebookLink,
            instagramLink: instagramLink,
          ));

      logD('${profile.toJson()}');
      return Right(profile);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Profile>> get({required String userId}) async {
    logD('### $userId');
    try {
      final profile = await retryRequest(() => dataSource.get(userId: userId));
      logD('${profile.toJson()}');
      return Right(profile);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
