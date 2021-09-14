import 'package:flutter/material.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/support_plant/presentation/support_plant_decision_dialog.dart';
import 'package:minden/features/support_plant/presentation/support_plant_dialog_debug_page.dart';
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

  Future<void> showDialog() async {
    await Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (context, setState) {
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
                            Text(
                              '現在「${registPowerPlants[0].powerPlant.name}」',
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
                            const Text(
                              'を応援中です。',
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                            const Text(
                              'に変更してよろしいですか？',
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
                          '応援出来る発電所は${user.supportableNumber}件までです。',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF575292),
                            fontSize: 16,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                      const SizedBox(
                        height: 14,
                      ),

                      const SizedBox(
                        width: 294,
                        child: Text(
                          '現在の選択を解除すると新規応援先を選択出来るようになります',
                          textAlign: TextAlign.center,
                          style: TextStyle(
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
                      const Text(
                        '応援する発電所は今月末まで変更可能です',
                        textAlign: TextAlign.center,
                        style: TextStyle(
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
                            _hideDialog();
                          },
                          text: '次へ',
                          size: ButtonSize.S,
                        )
                      else
                        Button(
                          onTap: () {},
                          text: '次へ',
                          isActive: false,
                          size: ButtonSize.S,
                        ),
                      const SizedBox(
                        height: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          registPowerPlants.forEach((registPowerPlant) =>
                              registPowerPlant.isRegist = true);
                          _hideDialog();
                        },
                        child: const Text(
                          'キャンセル',
                          style: TextStyle(
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
                  child: Icon(Icons.close),
                  onTap: _hideDialog,
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
        const Text(
          '＜現在応援中の発電所＞',
          textAlign: TextAlign.center,
          style: TextStyle(
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
              Text(
                registPowerPlant.powerPlant.name,
                style: const TextStyle(
                  color: Color(0xFF575292),
                  fontSize: 13,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO 登録フラグを切り替える
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
                      color: Color(0xFF75C975),
                      width: registPowerPlant.isRegist ? 0 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      registPowerPlant.isRegist ? '選択解除' : '解除済み',
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

  Widget _buildSelectedPlantListItem(canRegistPowerPlants) {
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
            child: Image.network(
              selectPowerPlant.image,
              fit: BoxFit.cover,
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

  /*
   * 非表示
   */
  void _hideDialog() {
    Navigator.of(context).pop();
  }
}
