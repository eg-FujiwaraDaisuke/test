import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_detail_page.dart';

/// 発電所一覧要素におけるキャッチコピー表示位置
enum Direction {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
}

/// 発電所一覧要素
class PowerPlantListItem extends StatelessWidget {
  PowerPlantListItem(
      {required this.powerPlant,
      required this.direction,
      this.isShowCatchphras = true,
      this.fromApp = false,
      this.supportedData,
      this.reservedDate});

  static const cornerRadius = Radius.circular(11);

  final PowerPlant powerPlant;
  final Direction direction;
  final bool isShowCatchphras;
  final String? supportedData;
  final String? reservedDate;
  final bool fromApp;

  double _thumbnailImageHeight = 0;
  double _thumbnailImageWidth = 0;

  @override
  Widget build(BuildContext context) {
    _thumbnailImageWidth = MediaQuery.of(context).size.width;
    _thumbnailImageHeight = _thumbnailImageWidth / 1.28;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: InkWell(
        onTap: () {
          final route = MaterialPageRoute(
            builder: (context) =>
                PowerPlantDetailPage(plantId: powerPlant.plantId),
            settings: const RouteSettings(name: '/home/top/detail'),
          );
          Navigator.push(context, route);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: _generateCircularRadius(),
          child: Column(
            children: [
              // ヘッダー画像・キャッチフレーズ
              _generateSHortCatchphraseOnImage(powerPlant.plantImage1),
              // 発電署名・所在地

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          child: Text(
                            powerPlant.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF575292),
                              height: 1.43,
                            ),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                'assets/images/power_plant/location.svg',
                                width: 10,
                                height: 12,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  powerPlant.viewAddress,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFA7A7A7),
                                    height: 1.48,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (reservedDate != null || supportedData != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            reservedDate == null
                                ? ''
                                : '🚩${reservedDate}${i18nTranslate(context, 'power_plant_support_start_date')}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFFF8C00),
                            ),
                          ),
                          Text(
                            supportedData == null
                                ? ''
                                : '${supportedData}${!fromApp ? 'WEB' : ''}${i18nTranslate(context, 'power_plant_support_start_date_short')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFA7A7A7),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ],
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
            height: _thumbnailImageHeight,
            width: _thumbnailImageWidth,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
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
              fit: BoxFit.cover,
            ),
          ),
        ),
        // 短いキャッチフレーズ
        if (isShowCatchphras)
          _generateShortCatchphrase(powerPlant, direction)
        else
          Container(),
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
