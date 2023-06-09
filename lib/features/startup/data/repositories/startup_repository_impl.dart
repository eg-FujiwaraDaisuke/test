import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/startup/data/datasources/startup_info_datasource.dart';
import 'package:minden/features/startup/domain/entities/startup.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';

// data - repository

// 実装ガイド
// ドメイン層では、usecaseがrepositoryを使ってentityを返す仕組みを作りました。
// データ層も構造は似ていて、repositoryの実装で、datasourceを使って、modelを返します。
// 異なる点としては、
// ドメイン層では、repositoryはEntityを返すことと、エラーはFailureとして返すことです。
// データ層では、datasourceはModelを返すことと、エラーはexceptionを投げることです。
class StartupRepositoryImpl implements StartupRepository {
  StartupRepositoryImpl({
    required this.dataSource,
  });

  final StartupInfoDataSource dataSource;

  @override
  Future<Either<Failure, Startup>> getStartupInfo() async {
    final hasConnection = await (Connectivity().checkConnectivity());
    if (hasConnection == ConnectivityResult.none) {
      return Left(ConnectionFailure());
    }
    try {
      final startupInfo = await dataSource.getStartupInfo();
      logD('[startup Info] ${startupInfo.toJson().toString()}');
      return Right(startupInfo);
    } on SupportVersionException catch (e) {
      return Left(SupportVersionFailure(
        actionUrl: e.storeUrl,
        supportVersion: e.supportVersion,
      ));
    } on MaintenanceException catch (e) {
      return Left(UnderMaintenanceFailure(
        description: e.maintenanceDescription,
        actionUrl: e.maintenanceUrl,
      ));
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
