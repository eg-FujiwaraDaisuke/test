import 'package:flutter/material.dart';
import 'package:minden/features/support_plant/domain/entities/participant.dart';
import 'package:minden/features/support_plant/presentation/support_participants_dialog.dart';
import 'package:minden/features/support_plant/presentation/support_plant_decide_dialog.dart';

class SupportPlantDialogDebugPage extends StatelessWidget {
  const SupportPlantDialogDebugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('契約件数1/応援0の場合'),
              onPressed: () {
                SupportPlantDialog(context: context).showDialog();
              },
            ),
            ElevatedButton(
              child: Text('契約件数1/応援1の場合'),
              onPressed: () {
                SupportPlantDialog(context: context).showDialog();
              },
            ),
            ElevatedButton(
              child: Text('契約件数2/応援2の場合'),
              onPressed: () {
                SupportPlantDialog(context: context).showDialog();
              },
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: Text('サポートしてる人たち'),
              onPressed: () {
                SupportParticipantsDialog(
                        context: context, participants: participantsDammyData)
                    .showDialog();
              },
            ),
          ],
        ),
      ),
    );
  }
}
