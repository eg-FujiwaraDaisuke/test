import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/regist_power_plant.dart';
import 'package:minden/features/support_power_plant/data/datasources/support_power_plant_datasources.dart';
import 'package:minden/features/support_power_plant/data/repositories/support_power_plant_repository_impl.dart';
import 'package:minden/features/support_power_plant/domain/usecases/support_power_plant_usecase.dart';
import 'package:minden/features/support_power_plant/presentation/bloc/support_power_plant_bloc.dart';
import 'package:minden/utile.dart';
import 'package:http/http.dart' as http;

class SupportPowerPlantDecisionDialog {
  SupportPowerPlantDecisionDialog({
    required this.context,
    required this.selectPowerPlant,
    required this.registPowerPlants,
    required this.user,
  }) : super();

  final BuildContext context;
  final PowerPlant selectPowerPlant;
  final List<RegistPowerPlant> registPowerPlants;
  final User user;
  final _updateSupportPowerPlantBloc = UpdateSupportPowerPlantBloc(
    const SupportPowerPlantInitial(),
    UpdateSupportPowerPlant(
      SupportPowerPlantRepositoryImpl(
        dataSource: SupportPowerPlantDataSourceImpl(
          client: http.Client(),
        ),
      ),
    ),
  );

  Future<bool?> showDialog() async {
    await Navigator.push(
      context,
      CustomDialogOverlay(
        StatefulBuilder(builder: (context, setState) {
          // 登録可能な発電所のみ保持
          final canRegistPowerPlants = registPowerPlants
              .where((registPowerPlant) => registPowerPlant.isRegist)
              .toList();

          // 新しく登録する予定の発電所
          final newRegistPowerPlants = [
            ...canRegistPowerPlants
                .map((registPowerPlants) => registPowerPlants.powerPlant)
                .toList(),
            selectPowerPlant
          ];

          _updateSupportPowerPlantBloc.stream.listen((event) {
            if (event is SupportPowerPlantUpdating) {
              Loading.show(context);
              return;
            }
            Loading.hide();
            if (event is SupportPowerPlantUpdated) {
              Navigator.pop(context, true);
              return;
            }
          });

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
                                    // TODO 発電所の名前が入ってないので一旦ID入れる
                                    text: selectPowerPlant.plantId,
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
                            final plantIdList = {
                              'plantIdList': newRegistPowerPlants
                                  .map((powerPlant) =>
                                      {'plantId': powerPlant.plantId})
                                  .toList()
                            };

                            _updateSupportPowerPlantBloc
                                .add(UpdateSupportPowerPlantEvent(plantIdList));
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

  Widget _buildSelectedPlantListItem(PowerPlant powerPlant) {
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
                child: CachedNetworkImage(
                  imageUrl: powerPlant.plantImage1,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return Image.asset(
                      'assets/images/power_plant/power_plant_header_bg.png',
                      fit: BoxFit.cover,
                    );
                  },
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/power_plant/power_plant_header_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 27,
              ),
              SizedBox(
                width: 157,
                child: Text(
                  // TODO 発電所の名前が入ってないので一旦ID入れる
                  powerPlant.plantId,
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
        ),
      ],
    );
  }
}
