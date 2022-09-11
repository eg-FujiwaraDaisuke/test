import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:minden/core/firebase/dynamic_links_route_mapper.dart';
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/provider/firebase_dynamic_links_provider.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/button/button.dart';
import 'package:minden/features/common/widget/button/button_size.dart';
import 'package:minden/features/common/widget/custom_dialog_overlay/custom_dialog_overlay.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/utile.dart';
import 'package:share_plus/share_plus.dart';

/// 発電所の応援完了ダイアログ
class SupportPowerPlantCompleteDialog {
  SupportPowerPlantCompleteDialog({
    required this.context,
    required this.selectPowerPlant,
    required this.registeredPowerPlants,
  }) : super();

  static const String routeName = '/home/top/detail/support/complete';

  final BuildContext context;

  /// 今回応援対象に追加した発電所
  final PowerPlant selectPowerPlant;

  /// 応援済み発電所
  final List<PowerPlant> registeredPowerPlants;

  Future<bool?> showDialog() async {
    return Navigator.push(
      context,
      CustomDialogOverlay(
        HookConsumer(
          builder: (context, ref, child) {
            // シェア呼び出し
            // NOTE: DynamicLinksの処遇について決まったら、削除 or 復活させる
            // final createdDynamicLink = useProvider(
            //   createDynamicLink(
            //     '${DynamicLinksType.powerPlantDetail.pathByType}/${selectPowerPlant.plantId}',
            //   ),
            // );

            // シェアurl生成
            final shareUrl = createSimplyLink(
                '${DynamicLinksType.powerPlantDetail.pathByType}/${selectPowerPlant.plantId}');

            return StatefulBuilder(builder: (context, setState) {
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
                          // タイトル
                          Text(
                            i18nTranslate(
                                context, 'support_plant_complete_announce'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF575292),
                              fontSize: 16,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w500,
                              height: calcFontHeight(
                                  fontSize: 16, lineHeight: 27.2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // 来月から応援することになった発電所一覧
                          Column(
                            children: registeredPowerPlants
                                .map(_buildSelectedPlantListItem)
                                .toList(),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          // 応援する発電所の変更可能期限について表記
                          Text(
                            i18nTranslate(
                                context, 'support_plant_can_be_changed'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF787877),
                              fontSize: 12,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // 応援した発電所をシェアしようボタン
                          Button(
                              onTap: () {
                                logD('Share. url: $shareUrl');

                                Share.share(
                                  shareUrl.toString(),
                                  subject: '${selectPowerPlant.name}を応援しました',
                                );

                                // ダイアログを閉じる
                                Navigator.pop(context, false);
                              },
                              text: i18nTranslate(context,
                                  'support_plant_complete_suggest_share'),
                              size: ButtonSize.M),
                          const SizedBox(height: 12),
                          // 閉じるボタン
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              i18nTranslate(context, 'close'),
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
            });
          },
        ),
        isAndroidBackEnable: false,
        settings: const RouteSettings(name: routeName),
      ),
    );
  }

  /// 応援することにした発電所のWidget
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
                      'assets/images/common/placeholder.png',
                      fit: BoxFit.cover,
                    );
                  },
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/common/noimage.png',
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
                  powerPlant.name,
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
