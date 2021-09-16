import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/support_plant/presentation/support_plant_dialog_debug_page.dart';
import 'package:minden/utile.dart';

class SupportPlantDecisionDialog {
  SupportPlantDecisionDialog({
    required this.context,
    required this.selectPowerPlant,
    required this.registPowerPlants,
    required this.user,
  }) : super();

  final BuildContext context;
  final PowerPlant selectPowerPlant;
  final List<RegistPowerPlant> registPowerPlants;
  final User user;

  Future<void> showDialog() async {
    await Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (context, setState) {
          final canRegistPowerPlants = registPowerPlants
              .where((registPowerPlant) => registPowerPlant.isRegist)
              .toList();

          final newRegistPowerPlants = [
            ...canRegistPowerPlants
                .map((powerPlant) => powerPlant.powerPlant)
                .toList(),
            selectPowerPlant
          ];

          return Stack(
            children: [
              Positioned(
                child: Container(
                  width: 338,
                  padding: const EdgeInsets.only(top: 69, bottom: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      if (newRegistPowerPlants.length == 1)
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: i18nTranslate(
                                        context, 'bracket_before'),
                                    style: const TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontSize: 18,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: selectPowerPlant.name,
                                    style: const TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontSize: 18,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        i18nTranslate(context, 'bracket_after'),
                                    style: const TextStyle(
                                      color: Color(0xFFFF8C00),
                                      fontSize: 18,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              i18nTranslate(
                                  context, 'support_plant_decide_alright'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF575292),
                                fontSize: 16,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          i18nTranslate(context,
                              'support_plant_decide_next_month_alright'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: const Color(0xFF575292),
                            fontSize: 16,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                            height:
                                calcFontHeight(fontSize: 16, lineHeight: 27.2),
                          ),
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        children: newRegistPowerPlants
                            .map(_buildSelectedPlantListItem)
                            .toList(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        i18nTranslate(context, 'support_plant_can_be_changed'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF787877),
                          fontSize: 12,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Button(
                          onTap: () {
                            // TODO ここで応援APIを叩く
                            _hideDialog();
                          },
                          text: i18nTranslate(context, 'decide'),
                          size: ButtonSize.S),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          registPowerPlants.forEach((registPowerPlant) =>
                              registPowerPlant.isRegist = true);
                          _hideDialog();
                        },
                        child: Text(
                          i18nTranslate(context, 'cancel_katakana'),
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 25,
                right: 27,
                child: GestureDetector(
                  onTap: _hideDialog,
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          );
        }),
        isAndroidBackEnable: false,
      ),
    );
  }

  Widget _buildSelectedPlantListItem(powerPlant) {
    return Column(
      children: [
        const SizedBox(
          height: 9,
        ),
        Container(
          width: 286,
          height: 80,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: const Color(0xFF828282),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Image.network(
                  powerPlant.image,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 27,
              ),
              SizedBox(
                width: 157,
                child: Text(
                  powerPlant.name,
                  style: TextStyle(
                    color: Color(0xFF575292),
                    fontSize: 13,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    height: calcFontHeight(fontSize: 13, lineHeight: 19.5),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /*
   * 非表示
   */
  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
