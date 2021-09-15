import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';

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
                  return const _PowerPlantImage();
                });
              }).toList(),
              options: _generateCarouselOpts(viewModel.setSelectedPickupIndex),
              carouselController: _carouselController,
            ),
            // カルーセル操作ボタン
            CarouselNextPrevController(controller: _carouselController),
          ],
        ),
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
  const CarouselNextPrevController({
    Key? key,
    required this.controller,
  }) : super(key: key);

  static const double _radius = 35;

  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _generatePrevButton(),
        const Spacer(),
        _generateNextButton(),
      ],
    );
  }

  Widget _generatePrevButton() {
    return InkWell(
      onTap: () => controller.previousPage(curve: Curves.decelerate),
      child: Container(
        height: _radius * 2,
        width: _radius,
        decoration: const BoxDecoration(
          color: Color(0x9CFFFFFF),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: SvgPicture.asset(
            'assets/images/common/ic_arrow_prev.svg',
            fit: BoxFit.none,
          ),
        ),
      ),
    );
  }

  Widget _generateNextButton() {
    return InkWell(
      onTap: () => controller.nextPage(curve: Curves.decelerate),
      child: Container(
        height: _radius * 2,
        width: _radius,
        decoration: const BoxDecoration(
          color: Color(0x9CFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 4),
          child: SvgPicture.asset(
            'assets/images/common/ic_arrow_next.svg',
            fit: BoxFit.none,
          ),
        ),
      ),
    );
  }
}

/// 発電所ヘッダー画像
class _PowerPlantImage extends StatelessWidget {
  const _PowerPlantImage({
    Key? key,
    this.imageUrl = 'assets/images/sample/power_plant_pickup_sample.png',
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 282,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
