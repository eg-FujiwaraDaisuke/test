import 'package:flutter/material.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/support_participant/domain/entities/participant.dart';
import 'package:minden/features/support_participant/presentation/support_participants_dialog.dart';
import 'package:minden/features/support_plant/domain/entities/support.dart';

import 'package:minden/features/support_plant/presentation/support_plant_decide_dialog.dart';
import 'package:minden/features/support_plant/presentation/support_plant_select_dialog.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class PowerPlant {
  PowerPlant({
    required this.plantId,
    required this.name,
    required this.image,
  });

  String plantId;
  String name;
  String image;
}

class RegistPowerPlant {
  RegistPowerPlant({
    required this.isRegist,
    required this.powerPlant,
  });
  bool isRegist;
  PowerPlant powerPlant;
}

class SupportPlantDialogDebugPage extends StatefulWidget {
  const SupportPlantDialogDebugPage({Key? key}) : super(key: key);

  @override
  _SupportPlantDialogDebugPageState createState() =>
      _SupportPlantDialogDebugPageState();
}

class _SupportPlantDialogDebugPageState
    extends State<SupportPlantDialogDebugPage> {
  PowerPlant selectPowerPlantDammy = PowerPlant(
    plantId: 'plantId',
    name: 'みつばち発電所',
    image:
        'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
  );

  User userDammy = User(
    loginId: 'nakajo@minden.co.jp',
    accountId: 'step1_02@minden.co.jp',
    contractor: 'ぽーたるてすと に',
    limitedPlantId: '',
    supportableNumber: 2,
    profile: Profile(
      userId: 'MC20210808006',
      name: 'hogehoge',
      icon: '',
      bio: '',
      wallPaper: '',
      tags: [],
    ),
    supports: [
      Support(
        plantId: 'MP2021080808',
        status: 3,
        yearMonth: '202109',
        fromApp: true,
      ),
      Support(
        plantId: 'MP2021080809',
        status: 3,
        yearMonth: '202110',
        fromApp: true,
      )
    ],
  );

  List<RegistPowerPlant> registPowerPlants = [];

  @override
  void initState() {
    super.initState();

    // TODO userのsupportsを元にPowerPlantのデータを取得して格納
    setState(() {
      registPowerPlants = [
        RegistPowerPlant(
          isRegist: true,
          powerPlant:
              PowerPlant(plantId: 'MP2021080808', name: 'test1', image: ''),
        ),
        RegistPowerPlant(
          isRegist: true,
          powerPlant:
              PowerPlant(plantId: 'MP2021080809', name: 'test2', image: ''),
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              child: Text('応援する'),
              onPressed: () {
                // 契約件数１応援０の場合
                if (userDammy.supportableNumber > registPowerPlants.length) {
                  SupportPlantDecideDialog(
                          context: context,
                          selectPowerPlant: selectPowerPlantDammy)
                      .showDialog();
                } else {
                  SupportPlantSelectDialog(
                          context: context,
                          selectPowerPlant: selectPowerPlantDammy,
                          user: userDammy,
                          registPowerPlants: registPowerPlants)
                      .showDialog();
                }
              },
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
