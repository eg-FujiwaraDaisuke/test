import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/features/startup/domain/entities/startup_info.dart';

// domain - repository

// 実装ガイド
// GetStartupInfoユースケースがデータ取得する際にリポジトリを使用しますが、
// その「定義」をStartupRepositoryにて記述します。
// ここでの定義は、Future<Either<Failure, StartupInfo>> というデータ型で返すことと
// getStartupInfoというメソッド名がその定義になります。
// Future<Either<Failure, StartupInfo>> getStartupInfo(); <- この「定義」のことをインターフェイスと言っています。
// ユースケースがデータを取得するリポジトリは、ドメイン層とデータ層の両方に属します。
// 「定義」はドメイン層で、「実装」はデータ層に属します。

// ドメイン層では、repositoryはEntityを返すことと、エラーはFailureとして返すようにします。
abstract class StartupRepository {
  Future<Either<Failure, StartupInfo>> getStartupInfo();
}