import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_pickup_page.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_detail_page_view_model.dart';

/// 発電所詳細
class PowerPlantDetailPage extends ConsumerWidget {
  const PowerPlantDetailPage({
    Key? key,
    required this.powerPlantId,
  }) : super(key: key);

  final String powerPlantId;
  final bool isFromUserPage = true;

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
      body: CustomScrollView(
        slivers: <Widget>[
          isFromUserPage
              ? Text('aaaa')
              : SliverAppBar(
                  flexibleSpace: FlexibleSpaceBar(
                    background: PowerPlantPickup(),
                  ),
                  expandedHeight: 220,
                  backgroundColor: Colors.transparent,
                ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Stack(
                  children: [
                    // 画像
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/power_plant/power_plant_header_bg.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    // メッセージ
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 28,
                        top: 24,
                        right: 24,
                        bottom: 56,
                      ),
                      child: Text(
                        data.value!.catchphrase!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF575292),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                if (data.value == null) Container(),
                if (data.value != null) _generateDetail(data.value!),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 48, vertical: 12),
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
        ],
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
