import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/util/no_animation_router.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

/// 発電所一覧
class PowerPlantList extends ConsumerWidget {
  const PowerPlantList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return ListView.builder(
      itemCount: data.value.length,
      itemBuilder: (BuildContext context, int index) {
        final powerPlant = data.value[index];
        final direction = searchDirectionByIndex(index);

        return PowerPlantListItem(
          key: ValueKey(powerPlant.plantId),
          powerPlant: powerPlant,
          direction: direction,
        );
      },
    );
  }

  Direction searchDirectionByIndex(int index) {
    switch (index % 4) {
      case 0:
        return Direction.topLeft;
      case 1:
        return Direction.topRight;
      case 2:
        return Direction.bottomRight;
      case 3:
        return Direction.bottomLeft;
      default:
        return Direction.topLeft;
    }
  }
}

/// 発電所一覧要素におけるキャッチコピー表示位置
enum Direction {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
}

/// 発電所一覧要素
class PowerPlantListItem extends StatelessWidget {
  const PowerPlantListItem({
    Key? key,
    required this.powerPlant,
    required this.direction,
  }) : super(key: key);

  static const cornerRadius = Radius.circular(11);

  final PowerPlant powerPlant;

  final Direction direction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: InkWell(
        onTap: () {
          logD('onTapped power plant.');
          final detail = PowerPlantDetail(
            plantId: powerPlant.plantId,
            areaCode: powerPlant.areaCode,
            name: powerPlant.name,
            viewAddress: powerPlant.viewAddress,
            voltageType: powerPlant.voltageType,
            powerGenerationMethod: powerPlant.powerGenerationMethod,
            renewableType: powerPlant.renewableType,
            generationCapacity: powerPlant.generationCapacity,
            displayOrder: powerPlant.displayOrder,
            isRecommend: powerPlant.isRecommend,
            ownerName: powerPlant.ownerName,
            startDate: powerPlant.startDate,
            endDate: powerPlant.endDate,
            plantImage1: powerPlant.plantImage1,
          );

          final route = NoAnimationMaterialPageRoute(
            builder: (context) =>
                PowerPlantDetailPage(powerPlantId: powerPlant.plantId),
            settings: const RouteSettings(name: '/home/top/detail'),
          );
          Navigator.push(context, route);
        },
        child: AspectRatio(
          aspectRatio: 340 / 320,
          child: Container(
            decoration: _generateCircularRadius(),
            child: Column(
              children: [
                // ヘッダー画像・キャッチフレーズ
                _generateSHortCatchphraseOnImage(powerPlant.plantImage1),
                // 発電署名・所在地
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              powerPlant.name ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF575292),
                                height: 1.43,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/power_plant/location.svg',
                                width: 10,
                                height: 12,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                powerPlant.viewAddress,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFA7A7A7),
                                  height: 1.48,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 短いキャッチフレーズを重ねて表示するヘッダー画像
  Widget _generateSHortCatchphraseOnImage(String imageUrl) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: cornerRadius, topRight: cornerRadius),
          child: SizedBox(
            width: 418,
            height: 280,
            child: FadeInImage.assetNetwork(
              // TODO replace place holder
              placeholder:
                  'assets/images/power_plant/power_plant_header_bg.png',
              image: imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 短いキャッチフレーズ
        _generateShortCatchphrase(powerPlant, direction),
      ],
    );
  }

  /// 四隅角丸のBoxDecorationを生成する
  BoxDecoration _generateCircularRadius() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(cornerRadius),
      boxShadow: [
        BoxShadow(
          color: Color(0x32DADADA),
          spreadRadius: 5,
          blurRadius: 8,
          offset: Offset(0, 6),
        )
      ],
    );
  }

  /// 画像に重ねて表示するキャッチフレーズ
  Widget _generateShortCatchphrase(
    PowerPlant powerPlant,
    Direction direction,
  ) {
    double? left;
    double? top;
    double? right;
    double? bottom;
    final TextAlign textAlignment;

    switch (direction) {
      case Direction.topLeft:
        {
          left = 0;
          top = 0;
          textAlignment = TextAlign.left;
          break;
        }
      case Direction.topRight:
        {
          top = 0;
          right = 0;
          textAlignment = TextAlign.right;
          break;
        }
      case Direction.bottomRight:
        {
          right = 0;
          bottom = 0;
          textAlignment = TextAlign.right;
          break;
        }
      case Direction.bottomLeft:
        {
          left = 0;
          bottom = 0;
          textAlignment = TextAlign.left;
          break;
        }
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          powerPlant.shortCatchphrase ?? '',
          textAlign: textAlignment,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            fontSize: 35,
            height: 1.2,
            shadows: [
              Shadow(
                color: Color(0x980C2460),
                blurRadius: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
