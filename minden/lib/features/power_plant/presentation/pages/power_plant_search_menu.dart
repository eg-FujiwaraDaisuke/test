import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_by_gift_page.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_by_tag_page.dart';
import 'package:minden/utile.dart';

/// メニューから、発電所の探し方を選択する
class PowerPlantSearchMenu extends StatefulWidget {
  const PowerPlantSearchMenu({Key? key}) : super(key: key);

  static const String routeName = '/home/top/search/menu';

  @override
  _PowerPlantSearchMenuState createState() => _PowerPlantSearchMenuState();
}

class _PowerPlantSearchMenuState extends State<PowerPlantSearchMenu> {
  static const cornerRadius = Radius.circular(11);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 大切にしていることから探す
          _generateSearchMenu(
            context,
            'power_plant_search_menu_by_tag_title',
            'power_plant_search_menu_by_tag_description',
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 7),
              child: Image.asset(
                'assets/images/power_plant/balloon.png',
                width: 76,
                height: 52,
              ),
            ),
            () {
              // 大切にしていることから探す画面を表示
              final route = MaterialPageRoute(
                builder: (context) => const PowerPlantSearchByTag(),
                settings:
                    const RouteSettings(name: PowerPlantSearchByTag.routeName),
              );
              Navigator.push(context, route);
            },
          ),
          // 特典から探す
          _generateSearchMenu(
            context,
            'power_plant_search_menu_by_gift_title',
            'power_plant_search_menu_by_gift_description',
            Padding(
              padding: const EdgeInsets.only(top: 9, right: 19),
              child: Image.asset(
                'assets/images/power_plant/present_box.png',
                width: 66,
                height: 39,
              ),
            ),
            () {
              // 特典から探す画面を表示
              final route = MaterialPageRoute(
                builder: (context) => const PowerPlantSearchByGift(),
                settings:
                    const RouteSettings(name: PowerPlantSearchByGift.routeName),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }

  Widget _generateSearchMenu(
    BuildContext context,
    String titleKey,
    String descriptionKey,
    Widget backgroundImage,
    VoidCallback onTapMenu,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _generateCircularRadius(),
      child: GestureDetector(
        onTap: onTapMenu,
        child: Column(
          children: [
            // カラーバー
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: cornerRadius,
                topRight: cornerRadius,
              ),
              child: Container(
                height: 26,
                color: const Color(0xFFDCF6DA),
              ),
            ),
            Stack(
              alignment: Alignment.topRight,
              children: [
                // 背景画像
                backgroundImage,
                // メニュー
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                  child: Column(
                    children: [
                      // タイトル
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/power_plant/search.svg',
                            width: 16,
                            height: 16,
                            color: const Color(0xFF575292),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            i18nTranslate(context, titleKey),
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'NotoSansJP',
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF575292),
                              height: calcFontHeight(
                                  fontSize: 16, lineHeight: 23.17),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 詳細
                      Text(
                        i18nTranslate(context, descriptionKey),
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'NotoSansJP',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF575292),
                          height:
                              calcFontHeight(fontSize: 13, lineHeight: 16.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
}
