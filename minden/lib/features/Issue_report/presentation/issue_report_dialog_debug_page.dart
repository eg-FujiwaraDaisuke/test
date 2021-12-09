import 'package:flutter/material.dart';
import 'issue_report_complete_dialog.dart';
import 'issue_report_dialog.dart';
import 'issue_report_message_dialog.dart';

class IssueReportDialogDebugPage extends StatefulWidget {
  @override
  _IssueReportDialogDebugPageState createState() =>
      _IssueReportDialogDebugPageState();
}

class _IssueReportDialogDebugPageState
    extends State<IssueReportDialogDebugPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                final isShowReport =
                    await IssueReportDialog(context: context).showDialog();

                final isReport = isShowReport!
                    ? await IssueReportMessageDialog(context: context)
                        .showDialog()
                    : false;

                isReport!
                    ? IssueReportCompleteDialog(context: context).showDialog()
                    : null;
              },
              child: Text('通報する'),
            ),
          ],
        ),
      ),
    );
  }
}
