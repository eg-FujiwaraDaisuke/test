import 'package:dartz/dartz.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';

abstract class IssueReportRepository {
  Future<Either<Failure, Success>> sendIssueReport({
    required String userId,
    required String targetUserId,
    required List<int>? issueType,
    required String message,
  });
}
