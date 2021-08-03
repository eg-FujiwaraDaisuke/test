import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/domain/power_plant.dart';
import 'package:minden/features/power_plant/pages/power_plant_pickup_page.dart';
import 'package:minden/features/power_plant/viewmodel/power_plant_page_view_model.dart';

/// ホーム - トップ
class HomeTopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(powerPlantPageViewModelProvider.notifier).fetch();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 電力会社一覧
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                child: Text(
                  i18nTranslate(context, 'plant_list'),
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.04,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    height: 1.45,
                  ),
                ),
              ),
              _PowerPlantList(),
              // ピックアップ
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
                child: Text(
                  i18nTranslate(context, 'pickup'),
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 0.04,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF000000),
                    height: 1.45,
                  ),
                ),
              ),
              PowerPlantPickup(),
              // 大切にしていることから探す
              // 電力会社一覧
            ],
          ),
        ),
      ),
    );
  }
}

/// 電力会社一覧
class _PowerPlantList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return Column(
      children: data.value.map((p) => _generateListItem(p)).toList(),
    );
  }

  Widget _generateListItem(PowerPlant powerPlant) {
    return Container(
      height: 134,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // 画像
          Flexible(
            flex: 5,
            child: _PowerPlantSummaryImage(),
          ),
          // 発電所情報
          Flexible(
            flex: 6,
            child: _PowerPlantInfo(powerPlant: powerPlant),
          )
        ],
      ),
    );
  }
}

/// 電力会社画像
/// 画像左上にNEWマークを表示するスタイル
class _PowerPlantSummaryImage extends StatelessWidget {
  final String imageUrl;
  final bool isNew;

  const _PowerPlantSummaryImage({
    Key? key,
    this.imageUrl = 'assets/images/sample/power_plant_sample.png',
    this.isNew = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 画像
        Image.asset(
          imageUrl,
        ),
        // NEWマーク
        if (isNew)
          SvgPicture.asset(
            'assets/images/power_plant/power_plant_summary_new_mark.svg',
          ),
      ],
    );
  }
}

/// 電力会社詳細
class _PowerPlantInfo extends StatelessWidget {
  final PowerPlant powerPlant;

  const _PowerPlantInfo({
    Key? key,
    required this.powerPlant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 発電所名
          Text(
            powerPlant.name,
            style: _generateTextStyle(14, FontWeight.w500),
          ),
          SizedBox(height: 8),
          // 発電所スペック
          Row(
            children: [
              Text(
                powerPlant.powerGenerationMethods,
                style: _generateTextStyle(9, FontWeight.w500),
              ),
              SizedBox(width: 24),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/power_plant/capacity.svg',
                    fit: BoxFit.fitHeight,
                    width: 10,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '${powerPlant.capacity}kWh',
                    style: _generateTextStyle(9, FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/power_plant/location.svg',
                    fit: BoxFit.fitHeight,
                    width: 7,
                  ),
                  SizedBox(width: 2),
                  Text(
                    '所在地 ${powerPlant.location}',
                    style: _generateTextStyle(9, FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 8),
          // 発電所説明
          Text(
            '米沢米の田んぼの上にソーラーパネルを設置した発電所。農薬を減らしておいしいお米をつくっている。',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: _generateTextStyle(12, FontWeight.w500),
          ),
          SizedBox(height: 8),
          // ユーザーレビュー
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TODO: svgにユーザー名を含まない形でassetを用意する必要がある
              Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                SvgPicture.asset(
                  'assets/images/power_plant/user_no_image.svg',
                ),
                Text(
                  'お名前お名前',
                  style: _generateTextStyle(5, FontWeight.w400),
                )
              ]),
              SizedBox(width: 2),
              Flexible(
                child: Text(
                  'お客様の声お客様の声お客様の声お客様の声お客様の声お客様の声'
                  'お客様の声お客様の声お客様の声お客様の声お客様の声お客様の声お客様の声お客…',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: _generateTextStyle(9, FontWeight.w500),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  TextStyle _generateTextStyle(double fontSize, FontWeight fontWeight) {
    return TextStyle(
      fontSize: fontSize,
      letterSpacing: 0.04,
      fontFamily: 'NotoSansJP',
      fontWeight: fontWeight,
      color: Color(0xFF828282),
      // NOTE: デザイン通りの指定だと、高さが134pxを超えてしまうため、要調整
      height: 1.22,
    );
  }
}
