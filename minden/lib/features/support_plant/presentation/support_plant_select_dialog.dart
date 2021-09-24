import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/regist_power_plant.dart';
import 'package:minden/utile.dart';

class SupportPlantSelectDialog {
  SupportPlantSelectDialog({
    required this.context,
    required this.selectPowerPlant,
    required this.registPowerPlants,
    required this.user,
  }) : super();

  final BuildContext context;
  final PowerPlant selectPowerPlant;
  List<RegistPowerPlant> registPowerPlants;
  final User user;

  Future<bool?> showDialog() {
    return Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (
          context,
          setState,
        ) {
          final canRegistPowerPlants = registPowerPlants
              .where((registPowerPlant) => registPowerPlant.isRegist)
              .toList();

          return Stack(
            children: [
              Positioned(
                child: Container(
                  width: 338,
                  padding: const EdgeInsets.only(top: 60, bottom: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // 契約件数１件で応援中１件の場合
                      if (user.supportableNumber == 1 &&
                          registPowerPlants.length == 1)
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: i18nTranslate(context, 'now'),
                                    style: const TextStyle(
                                      color: Color(0xFF575292),
                                      fontSize: 16,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text: i18nTranslate(
                                        context, 'bracket_before'),
                                    style: const TextStyle(
                                      color: Color(0xFF575292),
                                      fontSize: 18,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: registPowerPlants[0].powerPlant.name,
                                    style: const TextStyle(
                                      color: Color(0xFF575292),
                                      fontSize: 18,
                                      fontFamily: 'NotoSansJP',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        i18nTranslate(context, 'bracket_after'),
                                    style: const TextStyle(
                                      color: Color(0xFF575292),
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
                              height: 6,
                            ),
                            Text(
                              i18nTranslate(
                                  context, 'support_plant_select_supporting'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF575292),
                                fontSize: 16,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              '「${selectPowerPlant.name}」',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF8C00),
                                fontSize: 18,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              i18nTranslate(context,
                                  'support_plant_select_change_alright'),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF575292),
                                fontSize: 16,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      else
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: i18nTranslate(context,
                                    'support_plant_select_can_be_supported'),
                                style: const TextStyle(
                                  color: Color(0xFF575292),
                                  fontSize: 16,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: user.supportableNumber.toString(),
                                style: const TextStyle(
                                  color: Color(0xFF575292),
                                  fontSize: 16,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: i18nTranslate(
                                    context, 'support_plant_select_unit'),
                                style: const TextStyle(
                                  color: Color(0xFF575292),
                                  fontSize: 16,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),

                      const SizedBox(
                        height: 14,
                      ),

                      SizedBox(
                        width: 294,
                        child: Text(
                          i18nTranslate(context,
                              'support_plant_select_lift_can_be_supported'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF787877),
                            fontSize: 12,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 14,
                      ),
                      _buildSelectedPlantListItem(canRegistPowerPlants),

                      const SizedBox(
                        height: 25,
                      ),

                      _buildSupportingPlantList(setState),

                      const SizedBox(
                        height: 19,
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
                      if (user.supportableNumber > canRegistPowerPlants.length)
                        Button(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          text: i18nTranslate(context, 'to_next'),
                          size: ButtonSize.S,
                        )
                      else
                        Button(
                          onTap: () {},
                          text: i18nTranslate(context, 'to_next'),
                          isActive: false,
                          size: ButtonSize.S,
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context, false);
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
                  onTap: () {
                    Navigator.pop(context, false);
                  },
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

  Widget _buildSupportingPlantList(setState) {
    return Column(
      children: [
        Text(
          i18nTranslate(context, 'support_plant_select_current_support'),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF575292),
            fontSize: 13,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Column(
          children: registPowerPlants
              .map(
                (registPowerPlant) =>
                    _buildSupportingPlantListItem(registPowerPlant, setState),
              )
              .toList(),
        )
      ],
    );
  }

  Widget _buildSupportingPlantListItem(
      RegistPowerPlant registPowerPlant, setState) {
    return SizedBox(
      width: 253,
      child: Column(
        children: [
          const SizedBox(
            height: 9,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 153,
                child: Text(
                  registPowerPlant.powerPlant.name,
                  style: const TextStyle(
                    color: Color(0xFF575292),
                    fontSize: 13,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    registPowerPlant.isRegist = !registPowerPlant.isRegist;
                  });
                },
                child: Container(
                  width: 71,
                  height: 31,
                  decoration: BoxDecoration(
                    color: registPowerPlant.isRegist
                        ? const Color(0xFF75C975)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: const Color(0xFF75C975),
                      width: registPowerPlant.isRegist ? 0 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      registPowerPlant.isRegist
                          ? i18nTranslate(
                              context, 'support_plant_select_deselect')
                          : i18nTranslate(
                              context, 'support_plant_select_released'),
                      style: TextStyle(
                        color: registPowerPlant.isRegist
                            ? const Color(0xFFFFFFFF)
                            : const Color(0xFF75C975),
                        fontSize: 10,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 9,
          ),
          Container(
            color: const Color(0xFFDADADA),
            width: 287,
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedPlantListItem(
      List<RegistPowerPlant> canRegistPowerPlants) {
    return Container(
      width: 286,
      height: 80,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
            color: user.supportableNumber > canRegistPowerPlants.length
                ? const Color(0xFF828282)
                : const Color(0xFFE2E2E2).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: CachedNetworkImage(
              imageUrl: selectPowerPlant.plantImage1,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return Image.asset(
                  'assets/images/power_plant/power_plant_header_bg.png',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(
            width: 27,
          ),
          SizedBox(
            width: 157,
            child: Text(
              selectPowerPlant.name,
              style: TextStyle(
                color: const Color(0xFF575292),
                fontSize: 13,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.w700,
                height: calcFontHeight(fontSize: 13, lineHeight: 19.5),
              ),
            ),
          )
        ],
      ),
    );
  }
}
