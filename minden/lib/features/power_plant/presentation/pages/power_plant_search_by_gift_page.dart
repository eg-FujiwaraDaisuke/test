import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_search_list_page.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/utile.dart';

/// 特典から探す
class PowerPlantSearchByGift extends StatefulWidget {
  const PowerPlantSearchByGift({Key? key}) : super(key: key);

  static const String routeName = '/home/top/search/gift';

  @override
  _PowerPlantSearchByGiftState createState() => _PowerPlantSearchByGiftState();
}

class _PowerPlantSearchByGiftState extends State<PowerPlantSearchByGift> {
  List<Tag?> _selectedTags = [];
  late GetGiftBloc _powerPlantGiftBloc;

  @override
  void initState() {
    super.initState();

    _powerPlantGiftBloc = GetGiftBloc(
        const PowerPlantStateInitial(),
        GetGift(
          PowerPlantRepositoryImpl(
            powerPlantDataSource: PowerPlantDataSourceImpl(
              client: http.Client(),
            ),
          ),
        ));

    _powerPlantGiftBloc.stream.listen((event) {
      if (event is TagLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();
    });

    _powerPlantGiftBloc.add(const GetGiftEvent());
  }

  @override
  void dispose() {
    _powerPlantGiftBloc.close();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            color: const Color(0xFFFAF9F8),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/power_plant/present_box_header.png',
                  fit: BoxFit.contain,
                  width: 253,
                  height: 48,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    i18nTranslate(context, 'power_plant_search_select_gift'),
                    style: TextStyle(
                      color: const Color(0xFF575292),
                      fontSize: 13,
                      fontFamily: 'NotoSansJP',
                      fontWeight: FontWeight.w500,
                      height: calcFontHeight(fontSize: 13, lineHeight: 17),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                BlocProvider.value(
                  value: _powerPlantGiftBloc,
                  child: BlocListener<GetGiftBloc, PowerPlantState>(
                    listener: (context, state) {
                      if (state is GiftLoading) {
                        Loading.show(context);
                        return;
                      }
                      Loading.hide();
                    },
                    child: BlocBuilder<GetGiftBloc, PowerPlantState>(
                      builder: (context, state) {
                        if (state is GiftLoaded) {
                          return _buildGifts(state.powerPlantGifts);
                        }
                        return Container();
                      },
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

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        i18nTranslate(context, 'power_plant_search_by_gift'),
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
    );
  }

  Widget _buildGifts(List<PowerPlantGift> gifts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 338,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Wrap(
            spacing: 5,
            runSpacing: 10,
            children: gifts
                .map(
                  (gift) => GiftListItem(
                    gift: gift,
                    onSelect: (gift) {
                      // 選択した特典に合致する発電所一覧を表示
                      logD('Selected gift type. name: ${gift.giftTypeName}');

                      // 検索結画面に飛ばす
                      final route = MaterialPageRoute(
                        builder: (context) =>
                            PowerPlantSearchListPage(selectGift: gift),
                        settings: const RouteSettings(
                            name: PowerPlantSearchListPage.routeName),
                      );
                      Navigator.of(context, rootNavigator: true).push(route);
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class GiftListItem extends StatefulWidget {
  const GiftListItem({
    required this.gift,
    required this.onSelect,
  }) : super();
  final PowerPlantGift gift;
  final Function(PowerPlantGift gift) onSelect;

  @override
  _GiftListItemState createState() => _GiftListItemState();
}

class _GiftListItemState extends State<GiftListItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect(widget.gift);
      },
      child: _buildItem(),
    );
  }

  Widget _buildItem() {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 102),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: const Color(0xFFE2E2E2),
          ),
          color: Colors.white,
        ),
        child: Text(
          '#${widget.gift.giftTypeName}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF787877),
            fontSize: 14,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
