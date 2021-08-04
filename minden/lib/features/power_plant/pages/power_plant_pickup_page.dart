import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/viewmodel/power_plant_page_view_model.dart';

/// 電力会社ピックアップ一覧
class PowerPlantPickup extends ConsumerWidget {
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final viewModel = watch(powerPlantPageViewModelProvider.notifier);
    final data = watch(powerPlantPageViewModelProvider);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // カルーセル
            CarouselSlider(
              items: data.value.map((data) {
                return Builder(builder: (context) {
                  return _PickupImage();
                });
              }).toList(),
              options: _generateCarouselOpts(
                  (index) => viewModel.setSelectedPickupIndex(index)),
              carouselController: _carouselController,
            ),
            // カルーセル操作ボタン
            CarouselNextPrevController(controller: _carouselController),
          ],
        ),
        // 電力会社名
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    data.value[data.selectedCompanyIndex].name,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF787877),
                      height: 1.45,
                    ),
                  ),
                ),
              ),
              TextButton(
                child: Text(
                  i18nTranslate(context, 'pickup_see_details'),
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF8C00),
                      height: 1.45),
                ),
                style: TextButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                onPressed: () {
                  logD("詳しくみる");
                },
              ),
            ],
          ),
        ),
        // インジケーター
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.value.asMap().entries.map((entry) {
            return _PickupIndicator(index: entry.key);
          }).toList(),
        ),
        // TODO 現状デザイン通りではあるが、以下の余白は不要かもしれない
        SizedBox(height: 62),
      ],
    );
  }

  CarouselOptions _generateCarouselOpts(Function(int index) onPageChanged) {
    return CarouselOptions(
      height: 282,
      aspectRatio: 16 / 9,
      viewportFraction: 1.0,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      enlargeCenterPage: true,
      onPageChanged: (index, reason) => onPageChanged(index),
      scrollDirection: Axis.horizontal,
    );
  }
}

/// カルーセルの操作UI（Next/Prev操作）
class CarouselNextPrevController extends StatelessWidget {
  static const double _radius = 35;

  final CarouselController controller;

  const CarouselNextPrevController({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _generatePrevButton(),
        Spacer(),
        _generateNextButton(),
      ],
    );
  }

  Widget _generatePrevButton() {
    return GestureDetector(
      onTap: () => controller.previousPage(curve: Curves.decelerate),
      child: Container(
        height: _radius * 2,
        width: _radius,
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: SvgPicture.asset(
            'assets/images/common/ic_arrow_prev.svg',
            fit: BoxFit.none,
          ),
        ),
        decoration: BoxDecoration(
          color: const Color(0x9CFFFFFF),
          borderRadius: BorderRadius.only(
            topRight: const Radius.circular(_radius),
            bottomRight: const Radius.circular(_radius),
          ),
        ),
      ),
    );
  }

  Widget _generateNextButton() {
    return GestureDetector(
      onTap: () => controller.nextPage(curve: Curves.decelerate),
      child: Container(
        height: _radius * 2,
        width: _radius,
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: SvgPicture.asset(
            'assets/images/common/ic_arrow_next.svg',
            fit: BoxFit.none,
          ),
        ),
        decoration: BoxDecoration(
          color: const Color(0x9CFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(_radius),
            bottomLeft: const Radius.circular(_radius),
          ),
        ),
      ),
    );
  }
}

/// 電力会社ピックアップカルーセルのインジケーター
class _PickupIndicator extends ConsumerWidget {
  static const double indicatorSize = 6.0;

  final int index;

  _PickupIndicator({required this.index});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return Row(
      children: [
        Container(
          width: indicatorSize,
          height: indicatorSize,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: _specificColor(data)),
        ),
      ],
    );
  }

  Color _specificColor(PowerPlantPageState data) {
    if (data.selectedCompanyIndex == index) {
      return Color(0xFF000000);
    } else {
      return Color(0xFFC4C4C4);
    }
  }
}

/// 電力会社ピックアップ画像
class _PickupImage extends StatelessWidget {
  final String imageUrl;
  final String description;

  const _PickupImage({
    Key? key,
    this.imageUrl = 'assets/images/sample/power_plant_pickup_sample.png',
    this.description = '米沢米の田んぼの上にソーラーパネルを設置した発電所。農薬を減らしておいしいお米をつくっている。',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 画像
        Container(
          width: MediaQuery.of(context).size.width,
          height: 282,
          child: Image.asset(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
        // テキスト
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          decoration: BoxDecoration(
            gradient: _generateUnderTextGradient(),
          ),
        ),
      ],
    );
  }

  LinearGradient _generateUnderTextGradient() {
    return LinearGradient(
      begin: FractionalOffset.bottomCenter,
      end: FractionalOffset.topCenter,
      colors: [
        const Color(0xFF8B9884),
        const Color(0x7DABC17D),
        const Color(0x00C4C4C4),
      ],
      stops: const [
        0.0,
        0.53,
        1.0,
      ],
    );
  }
}
