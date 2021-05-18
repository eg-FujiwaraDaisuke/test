import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/startup/domain/entities/maintenance_info.dart';
import 'package:minden/features/startup/domain/repositories/startup_repository.dart';

// domain - usecase
//
// 実装ガイド
// GetMaintenanceInfoはユースケースで、ビジネスロジックが実装されます。
// ビジネスロジック : 表示制御ではない、データ取得保存などの制御でもない、具体的な業務の仕様を表現したものです。
// ここでは「メンテナンスに関係する情報を取得する」ことです。
// データの取得はリポジトリで行うのですが、リポジトリクラスをユースケースクラスで生成するのではなく
// StartupRepositoryを外部から渡してもらいます。（dependency injection）
class GetMaintenanceInfo extends UseCase<MaintenanceInfo, NoParams> {
  final StartupRepository repository;

  GetMaintenanceInfo(this.repository);

  Future<Either<Failure, MaintenanceInfo>> call(NoParams params) async {
    return await repository.getMaintenanceInfo();
  }
}
