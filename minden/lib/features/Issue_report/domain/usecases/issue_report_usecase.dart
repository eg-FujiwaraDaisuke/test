import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/failure.dart';
import 'package:minden/core/success/success.dart';
import 'package:minden/core/usecase/usecase.dart';
import 'package:minden/features/Issue_report/domain/repositories/issue_report_repository.dart';

class SendIssueReport extends UseCase<Success, SendIssueReportParams> {
  SendIssueReport(this.repository);
  final IssueReportRepository repository;

  @override
  Future<Either<Failure, Success>> call(SendIssueReportParams params) async {
    return await repository.sendIssueReport(
        userId: params.userId,
        targetUserId: params.targetUserId,
        issueType: params.issueType,
        message: params.message);
  }
}

class SendIssueReportParams extends Equatable {
  const SendIssueReportParams({
    required this.userId,
    required this.targetUserId,
    required this.issueType,
    required this.message,
  });

  final String userId;
  final String targetUserId;
  final List<int> issueType;
  final String message;

  @override
  List<Object> get props => [userId];
}
