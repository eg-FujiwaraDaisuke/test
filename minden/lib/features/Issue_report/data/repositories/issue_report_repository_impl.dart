import 'package:dartz/dartz.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/repository/retry_process_mixin.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/features/Issue_report/data/datasources/issue_report_datasource.dart';
import 'package:minden/features/Issue_report/domain/repositories/issue_report_repository.dart';

class IssueReportRepositoryImpl
    with RetryProcessMixin
    implements IssueReportRepository {
  const IssueReportRepositoryImpl({required this.dataSource});

  final IssueReportDataSource dataSource;

  @override
  Future<Either<Failure, Success>> sendIssueReport({
    required String userId,
    required String targetUserId,
    List<int>? issueType,
    required String message,
  }) async {
    try {
      final success = await retryRequest(
        () => dataSource.sendIssueReport(
          userId: userId,
          targetUserId: targetUserId,
          issueType: issueType,
          message: message,
        ),
      );
      return Right(success);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
