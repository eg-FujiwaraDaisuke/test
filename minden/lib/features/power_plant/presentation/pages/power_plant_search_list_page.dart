import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_page.dart';
import 'package:minden/features/power_plant/presentation/viewmodel/power_plant_page_view_model.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/utile.dart';

class PowerPlantSearchListPage extends StatelessWidget {
  PowerPlantSearchListPage({required this.selectTag, Key? key})
      : super(key: key);
  final Tag selectTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '発電所を探す',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            color: const Color(0xFF575292),
            letterSpacing: calcLetterSpacing(letter: 4),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Center(
            child: SvgPicture.asset(
              'assets/images/common/leading_back.svg',
              fit: BoxFit.fill,
              width: 44,
              height: 44,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFFAF9F8),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 17),
                  Container(
                    width: 340,
                    height: 44,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFFE2E2E2),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 5, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TagListItem(
                            tag: selectTag,
                            onSelect: () {},
                            isSelected: true,
                          ),
                          Row(
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  'assets/images/power_plant/search.svg',
                                  width: 16,
                                  height: 16,
                                  color: const Color(0xFFA7A7A7),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                '検索結果･･･',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFA7A7A7),
                                  letterSpacing: calcLetterSpacing(letter: 4),
                                ),
                              ),
                              Text(
                                '３',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF575292),
                                  letterSpacing: calcLetterSpacing(letter: 4),
                                ),
                              ),
                              Text(
                                '件',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'NotoSansJP',
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF575292),
                                  letterSpacing: calcLetterSpacing(letter: 4),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 43),
                  Text(
                    'このタグを選んだ人が応援している発電所',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF575292),
                        letterSpacing: calcLetterSpacing(letter: 4)),
                  ),
                  const SizedBox(height: 31),
                  // TODO 大量のエラーがでる
                  // _PowerPlantSeachList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 発電所一覧
class _PowerPlantSeachList extends ConsumerWidget {
  const _PowerPlantSeachList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(powerPlantPageViewModelProvider);

    return Column(
      children: [
        ListView.builder(
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
        ),
      ],
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
