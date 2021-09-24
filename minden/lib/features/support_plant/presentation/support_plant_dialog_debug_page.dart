import 'package:flutter/material.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/regist_power_plant.dart';
import 'package:minden/features/support_plant/presentation/support_plant_decision_dialog.dart';
import 'package:minden/features/support_plant/presentation/support_plant_select_dialog.dart';
import 'package:minden/features/user/domain/entities/profile.dart';

class SupportPlantDialogDebugPage extends StatefulWidget {
  const SupportPlantDialogDebugPage({Key? key}) : super(key: key);

  @override
  _SupportPlantDialogDebugPageState createState() =>
      _SupportPlantDialogDebugPageState();
}

class _SupportPlantDialogDebugPageState
    extends State<SupportPlantDialogDebugPage> {
  PowerPlant _selectPowerPlant = PowerPlant(
    plantId: 'MP000386',
    areaCode: '1',
    name: 'いとうせいこう',
    viewAddress: '',
    voltageType: '',
    powerGenerationMethod: '',
    renewableType: '1',
    generationCapacity: 1,
    displayOrder: 1,
    isRecommend: true,
    ownerName: '',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    plantImage1:
        'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
  );

  User _user = User(
    loginId: 'nakajo@minden.co.jp',
    accountId: 'step1_02@minden.co.jp',
    contractor: 'ぽーたるてすと に',
    limitedPlantId: '',
    supportableNumber: 3,
    profile: Profile(
      userId: 'MC20210808006',
      name: 'hogehoge',
      icon: '',
      bio: '',
      wallPaper: '',
      tags: [],
      selectedPowerPlants: [
        PowerPlant(
          plantId: 'MP000386',
          areaCode: '1',
          name: 'いとうせいこう',
          viewAddress: '',
          voltageType: '',
          powerGenerationMethod: '',
          renewableType: '1',
          generationCapacity: 1,
          displayOrder: 1,
          isRecommend: true,
          ownerName: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          plantImage1:
              'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
        ),
        PowerPlant(
          plantId: 'MP000386',
          areaCode: '1',
          name: 'いとうせいこう',
          viewAddress: '',
          voltageType: '',
          powerGenerationMethod: '',
          renewableType: '1',
          generationCapacity: 1,
          displayOrder: 1,
          isRecommend: true,
          ownerName: '',
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          plantImage1:
              'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=2250&q=80',
        ),
      ],
    ),
    isNewbie: false,
    supports: [],
  );

  List<RegistPowerPlant> registPowerPlants = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      registPowerPlants = _user.profile.selectedPowerPlants
          .map((selectedPowerPlant) =>
              RegistPowerPlant(isRegist: true, powerPlant: selectedPowerPlant))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                // 契約件数１応援０の場合
                if (_user.supportableNumber >
                    _user.profile.selectedPowerPlants.length) {
                  await SupportPlantDecisionDialog(
                    context: context,
                    selectPowerPlant: _selectPowerPlant,
                    registPowerPlants: registPowerPlants,
                    user: _user,
                  ).showDialog();
                } else {
                  final isSelected = await SupportPlantSelectDialog(
                    context: context,
                    selectPowerPlant: _selectPowerPlant,
                    registPowerPlants: registPowerPlants,
                    user: _user,
                  ).showDialog();

                  isSelected ??
                      setState(() {
                        registPowerPlants = _user.profile.selectedPowerPlants
                            .map((selectedPowerPlant) => RegistPowerPlant(
                                isRegist: true, powerPlant: selectedPowerPlant))
                            .toList();
                      });

                  isSelected!
                      ? await SupportPlantDecisionDialog(
                          context: context,
                          selectPowerPlant: _selectPowerPlant,
                          registPowerPlants: registPowerPlants,
                          user: _user,
                        ).showDialog()
                      : setState(() {
                          registPowerPlants = _user.profile.selectedPowerPlants
                              .map((selectedPowerPlant) => RegistPowerPlant(
                                  isRegist: true,
                                  powerPlant: selectedPowerPlant))
                              .toList();
                        });
                }
              },
              child: Text('応援する'),
            ),
          ],
        ),
      ),
    );
  }
}
