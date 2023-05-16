part of 'issue_report_bloc.dart';

abstract class IssueReportEvent extends Equatable {
  const IssueReportEvent();
}

class SendIssueReportEvent extends IssueReportEvent {
  const SendIssueReportEvent({
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
