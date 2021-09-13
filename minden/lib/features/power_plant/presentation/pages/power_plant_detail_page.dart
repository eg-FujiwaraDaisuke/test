import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_detail_page_view_model.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

/// 発電所詳細
class PowerPlantDetailPage extends ConsumerWidget {
  const PowerPlantDetailPage({
    Key? key,
    required this.powerPlantId,
  }) : super(key: key);

  final String powerPlantId;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    // TODO 初期データ取得
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context
          .read(powerPlantDetailPageViewModelProvider.notifier)
          .fetchByPlantId(powerPlantId);
    });

    final data = watch(powerPlantDetailPageViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [],
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  if (data.value == null) Container(),
                  if (data.value != null) _generateDetail(data.value!),
                ],
              ),
            ),
            // この発電所を応援する
            Container(
              height: 82,
              padding: const EdgeInsets.only(bottom: 20),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Color(0xFFFF8C00),
                  Color(0xFFFFC277),
                ],
                stops: [
                  0.0,
                  1.0,
                ],
              )),
              child: Center(
                child: InkWell(
                  child: OutlinedButton(
                    onPressed: () => {logD('この発電所を応援する')},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(42),
                      ),
                      side: const BorderSide(color: Colors.white),
                    ),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                      child: Text(
                        'この発電所を応援する',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _generateDetail(PowerPlantDetail detail) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                height: 1,
                color: Color(0xFFE2E2E2),
              ),
              const SizedBox(height: 15),
              // 発電所名
              Text(
                detail.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF575292),
                  height: 1.43,
                ),
              ),
              // 所在地
              const SizedBox(height: 20),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/power_plant/location.svg',
                    width: 13,
                    height: 15,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    detail.viewAddress,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFA7A7A7),
                      height: 1.48,
                    ),
                  ),
                ],
              ),
              // 発電方法
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      detail.powerGenerationMethod,
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D7E7F),
                        height: 1.48,
                      ),
                    ),
                  ),
                  const Text(
                    '発電出力 / ',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D7E7F),
                      height: 1.48,
                    ),
                  ),
                  Text(
                    '${detail.generationCapacity}kWh',
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7D7E7F),
                      height: 1.48,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 45),
              _generateDetailTags(),
              _generateDetailMessages(detail),
              const SizedBox(height: 47),
            ],
          ),
        ),
      ],
    );
  }

  Widget _generateDetailTags() {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
        const SizedBox(height: 10),
        const Text(
          'この発電所を応援しているみんなが大切にしていること',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            color: Color(0xFF575292),
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _generateDetailMessages(PowerPlantDetail detail) {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
        const SizedBox(height: 10),
        _generateExpandableText(detail.ownerMessage!),
      ],
    );
  }

  Widget _generateExpandableText(String message) {
    return ExpandableNotifier(
      // <-- Provides ExpandableController to its children
      child: Column(
        children: [
          Expandable(
            // <-- Driven by ExpandableController from ExpandableNotifier
            collapsed: ExpandableButton(
              // <-- Expands when tapped on the cover photo
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'オーナーより',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF575292),
                            height: 1.43,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 2),
                        child: Text(
                          'もっと見る',
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7D7E7F),
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      SvgPicture.asset(
                        'assets/images/common/ic_arrow_collapse.svg',
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF7D7E7F),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            expanded: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'オーナーより',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF575292),
                      height: 1.43,
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/common/ic_arrow_expand.svg',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7E7F),
                  height: 1.6,
                ),
              ),
            ]),
          ),
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
