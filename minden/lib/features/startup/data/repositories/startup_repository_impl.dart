import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/data/datasources/maintenance_info_datasource.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';

import '../../domain/entities/maintenance_info.dart';

// data - repository

// 実装ガイド
// ドメイン層では、usecaseがrepositoryを使ってentityを返す仕組みを作りました。
// データ層も構造は似ていて、repositoryの実装で、datasourceを使って、modelを返します。
// 異なる点としては、
// ドメイン層では、repositoryはEntityを返すことと、エラーはFailureとして返すことです。
// データ層では、datasourceはModelを返すことと、エラーはexceptionを投げることです。
class StartupRepositoryImpl implements StartupRepository {
  final MaintenanceInfoDataSource dataSource;

  StartupRepositoryImpl({
    @required this.dataSource,
  });

  Future<Either<Failure, MaintenanceInfo>> getMaintenanceInfo() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return Left(ConnectionFailure());
    }
    try {
      final maintenanceInfo = await dataSource.getMaintenanceInfo();
      return Right(maintenanceInfo);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
