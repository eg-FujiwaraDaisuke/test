part of 'issue_report_bloc.dart';

abstract class IssueReportState extends Equatable {
  const IssueReportState();
}

class IssueReportInit extends IssueReportState {
  const IssueReportInit();

  @override
  List<Object> get props => [];
}

class IssueReportSending extends IssueReportState {
  const IssueReportSending();

  @override
  List<Object> get props => [];
}

class IssueReportSended extends IssueReportState {
  const IssueReportSended();
  @override
  List<Object> get props => [];
}

class IssueReportError extends IssueReportState {
  const IssueReportError({
    required this.message,
    required this.needLogin,
  });

  final String message;
  final bool needLogin;

  @override
  List<Object> get props => [message];
}
