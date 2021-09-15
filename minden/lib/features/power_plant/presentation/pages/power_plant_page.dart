import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_pickup_page.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

class PowerPlantHomeTabData {
  PowerPlantHomeTabData({
    required this.tabName,
    required this.tabPage,
  });

  late final String tabName;
  late final WidgetBuilder tabPage;
}

/// ホーム - トップ
class PowerPlantHomePage extends StatelessWidget {
  PowerPlantHomePage({Key? key}) : super(key: key);

  final tabs = [
    PowerPlantHomeTabData(
        tabName: '発電所一覧', tabPage: (_) => const PowerPlantList()),
    PowerPlantHomeTabData(
        tabName: '発電所を探す', tabPage: (_) => const SearchPowerPlant()),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO 初期データ取得
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read(powerPlantPageViewModelProvider.notifier).fetch();
    });

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TabBar(
                indicatorColor: Color(0xFFFF8C00),
                tabs: tabs
                    .map((tab) => Text(
                          tab.tabName,
                          textAlign: TextAlign.center,
                        ))
                    .toList(),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: TabBarView(
            children: tabs.map((tab) => tab.tabPage(context)).toList(),
          ),
        ),
      ),
    );
  }
}

class SearchPowerPlant extends ConsumerWidget {
  const SearchPowerPlant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 電力会社一覧（旧）
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              i18nTranslate(context, 'plant_list'),
              style: const TextStyle(
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              i18nTranslate(context, 'pickup'),
              style: const TextStyle(
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
    );
  }
}

/// 電力会社一覧
class _PowerPlantList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return Column(
      children: data.value.map(_generateListItem).toList(),
    );
  }

  Widget _generateListItem(PowerPlant powerPlant) {
    return Container(
      height: 134,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 画像
          const Flexible(
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
  const _PowerPlantSummaryImage({
    Key? key,
    this.imageUrl = 'assets/images/sample/power_plant_sample.png',
    this.isNew = true,
  }) : super(key: key);

  final String imageUrl;
  final bool isNew;

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
  const _PowerPlantInfo({
    Key? key,
    required this.powerPlant,
  }) : super(key: key);

  final PowerPlant powerPlant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 発電所名
          Text(
            powerPlant.name,
            style: _generateTextStyle(14, FontWeight.w500),
          ),
          const SizedBox(height: 8),
          // 発電所スペック
          Row(
            children: [
              Text(
                powerPlant.powerGenerationMethod,
                style: _generateTextStyle(9, FontWeight.w500),
              ),
              const SizedBox(width: 24),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/power_plant/capacity.svg',
                    fit: BoxFit.fitHeight,
                    width: 10,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${powerPlant.generationCapacity}kWh',
                    style: _generateTextStyle(9, FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/power_plant/location.svg',
                    fit: BoxFit.fitHeight,
                    width: 7,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '所在地 ${powerPlant.viewAddress}',
                    style: _generateTextStyle(9, FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          // 発電所説明
          Text(
            '米沢米の田んぼの上にソーラーパネルを設置した発電所。農薬を減らしておいしいお米をつくっている。',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: _generateTextStyle(12, FontWeight.w500),
          ),
          const SizedBox(height: 8),
          // ユーザーレビュー
          Row(
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
              const SizedBox(width: 2),
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
      color: const Color(0xFF828282),
      // NOTE: デザイン通りの指定だと、高さが134pxを超えてしまうため、要調整
      height: 1.22,
    );
  }
}
