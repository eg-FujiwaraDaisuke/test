import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:minden/core/error/exceptions.dart';
import 'package:minden/features/Issue_report/domain/usecases/issue_report_usecase.dart';

part 'issue_report_event.dart';
part 'issue_report_state.dart';

class SendIssueReportBloc extends Bloc<IssueReportEvent, IssueReportState> {
  SendIssueReportBloc(
    IssueReportState initialState,
    this.usecase,
  ) : super(initialState);
  final SendIssueReport usecase;

  @override
  Stream<IssueReportState> mapEventToState(
    IssueReportEvent event,
  ) async* {
    if (event is SendIssueReportEvent) {
      try {
        yield const IssueReportSending();
        final failureOrUser = await usecase(
          SendIssueReportParams(
              userId: event.userId,
              targetUserId: event.targetUserId,
              issueType: event.issueType,
              message: event.message),
        );

        yield failureOrUser.fold<IssueReportState>(
          (failure) => throw failure,
          (success) => const IssueReportSended(),
        );
      } on RefreshTokenExpiredException catch (e) {
        yield IssueReportError(message: e.toString(), needLogin: true);
      } catch (e) {
        yield IssueReportError(message: e.toString(), needLogin: false);
      }
    }
  }
}
