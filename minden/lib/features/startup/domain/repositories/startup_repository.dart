import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';

// domain - repository

// 実装ガイド
// GetMaintenanceInfoユースケースがデータ取得する際にリポジトリを使用しますが、
// その「定義」をStartupRepositoryにて記述します。
// ここでの定義は、Future<Either<Failure, MaintenanceInfo>> というデータ型で返すことと
// getMaintenanceInfoというメソッド名がその定義になります。
// Future<Either<Failure, MaintenanceInfo>> getMaintenanceInfo(); <- この「定義」のことをインターフェイスと言っています。
// ユースケースがデータを取得するリポジトリは、ドメイン層とデータ層の両方に属します。
// 「定義」はドメイン層で、「実装」はデータ層に属します。

// ドメイン層では、repositoryはEntityを返すことと、エラーはFailureとして返すようにします。
abstract class StartupRepository {
  Future<Either<Failure, MaintenanceInfo>> getMaintenanceInfo();
}