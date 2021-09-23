import 'package:flutter/material.dart';
import 'package:minden/features/violate/presentation/violate_dialog.dart';
import 'package:minden/features/violate/presentation/violate_report_complete_dialog.dart';
import 'package:minden/features/violate/presentation/violate_report_dialog.dart';

class ViolateDialogDebugPage extends StatefulWidget {
  @override
  _ViolateDialogDebugPageState createState() => _ViolateDialogDebugPageState();
}

class _ViolateDialogDebugPageState extends State<ViolateDialogDebugPage> {
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
                    await ViolateDialog(context: context).showDialog();

                final isReport = isShowReport!
                    ? await ViolateReportDialog(context: context).showDialog()
                    : false;

                isReport!
                    ? ViolateReportCompleteDialog(context: context).showDialog()
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
