import 'package:dartz/dartz.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/domain/entities/startup_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';

import '../../domain/entities/startup_info.dart';

// data - repository

// 実装ガイド
// ドメイン層では、usecaseがrepositoryを使ってentityを返す仕組みを作りました。
// データ層も構造は似ていて、repositoryの実装で、datasourceを使って、modelを返します。
// 異なる点としては、
// ドメイン層では、repositoryはEntityを返すことと、エラーはFailureとして返すことです。
// データ層では、datasourceはModelを返すことと、エラーはexceptionを投げることです。
class StartupRepositoryImpl implements StartupRepository {
  final StartupInfoDataSource dataSource;

  StartupRepositoryImpl({
    @required this.dataSource,
  });

  Future<Either<Failure, StartupInfo>> getStartupInfo() async {
    final hasConnection = await (DataConnectionChecker().hasConnection);
    if (!hasConnection) {
      return Left(ConnectionFailure());
    }
    try {
      final startupInfo = await dataSource.getStartupInfo();
      return Right(startupInfo);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
