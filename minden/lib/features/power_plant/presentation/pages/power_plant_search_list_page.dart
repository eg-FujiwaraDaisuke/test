import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/hook/use_logger.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/color_code_util.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_gift.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/utile.dart';

enum PowerPlantSearchType {
  tag,
  gift,
}

/// 発電所を探す画面
/// 選択したタグに基づく、発電所一覧を表示する
class PowerPlantSearchListPage extends StatefulWidget {
  const PowerPlantSearchListPage({
    this.selectTag,
    this.selectGift,
    Key? key,
  }) : super(key: key);

  static const String routeName = '/home/top/search/powerPlant';

  PowerPlantSearchType get searchType {
    if (selectTag != null) {
      return PowerPlantSearchType.tag;
    } else if (selectGift != null) {
      return PowerPlantSearchType.gift;
    } else {
      logW('selectTag and selectGift is null.');
      return PowerPlantSearchType.tag;
    }
  }

  final Tag? selectTag;

  final PowerPlantGift? selectGift;

  @override
  _PowerPlantSearchListPageState createState() =>
      _PowerPlantSearchListPageState();
}

class _PowerPlantSearchListPageState extends State<PowerPlantSearchListPage> {
  late GetPowerPlantsBloc _getPowerPlantsBloc;

  @override
  void initState() {
    super.initState();
    Loading.hide();
    _getPowerPlantsBloc = GetPowerPlantsBloc(
      const PowerPlantStateInitial(),
      GetPowerPlants(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    switch (widget.searchType) {
      case PowerPlantSearchType.tag:
        // タグから探す
        _getPowerPlantsBloc.add(
          GetPowerPlantsEvent(tagId: widget.selectTag!.tagId.toString()),
        );
        break;
      case PowerPlantSearchType.gift:
        // 特典から探す
        _getPowerPlantsBloc.add(
          GetPowerPlantsEvent(
              giftTypeId: widget.selectGift!.giftTypeId.toString()),
        );
        break;
    }
  }

  @override
  void dispose() {
    _getPowerPlantsBloc.close();
    Loading.hide();
    super.dispose();
  }

  String descriptionTextKey() {
    switch (widget.searchType) {
      case PowerPlantSearchType.tag:
        return 'power_plant_serch_selected_tag_support';
      case PowerPlantSearchType.gift:
        return 'power_plant_search_selected_gift';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          i18nTranslate(context, 'power_plant_serch_power_plant'),
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
            child: BlocProvider.value(
          value: _getPowerPlantsBloc,
          child: BlocListener<GetPowerPlantsBloc, PowerPlantState>(
            listener: (context, state) {
              if (state is PowerPlantLoading) {
                Loading.show(context);
                return;
              }
              Loading.hide();
            },
            child: BlocBuilder<GetPowerPlantsBloc, PowerPlantState>(
              builder: (context, state) {
                if (state is PowerPlantsLoaded) {
                  return Container(
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
                              padding:
                                  const EdgeInsets.only(left: 5, right: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    clipBehavior: Clip.antiAlias,
                                    children: [
                                      Container(
                                        width: 150,
                                      ),
                                      Positioned(
                                        top: 4,
                                        child: _buildSelectedLabel(),
                                      ),
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: FractionalOffset.topLeft,
                                            end: FractionalOffset.topRight,
                                            colors: [
                                              const Color(0xffffffff)
                                                  .withOpacity(0),
                                              const Color(0xffffffff)
                                                  .withOpacity(1),
                                            ],
                                            stops: const [
                                              0.6,
                                              1.0,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        i18nTranslate(context,
                                            'power_plant_serch_result'),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'NotoSansJP',
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFA7A7A7),
                                          letterSpacing:
                                              calcLetterSpacing(letter: 4),
                                        ),
                                      ),
                                      Text(
                                        state.powerPlants.powerPlants.length
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'NotoSansJP',
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF575292),
                                          letterSpacing:
                                              calcLetterSpacing(letter: 4),
                                        ),
                                      ),
                                      Text(
                                        i18nTranslate(context,
                                            'power_plant_serch_result_unit'),
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'NotoSansJP',
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF575292),
                                          letterSpacing:
                                              calcLetterSpacing(letter: 4),
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
                            i18nTranslate(context, descriptionTextKey()),
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'NotoSansJP',
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF575292),
                                letterSpacing: calcLetterSpacing(letter: 4)),
                          ),
                          const SizedBox(height: 31),
                          _PowerPlantSearchList(
                              powerPlants: state.powerPlants.powerPlants),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildSelectedLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.transparent,
        ),
        color: getColorFromCode(widget.selectTag?.colorCode ?? '1'),
      ),
      child: Text(
        '#${widget.selectTag?.tagName ?? widget.selectGift?.giftTypeName}',
        style: const TextStyle(
          color: Color(0xFF575292),
          fontSize: 14,
          fontFamily: 'NotoSansJP',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

/// 発電所一覧
class _PowerPlantSearchList extends StatelessWidget {
  _PowerPlantSearchList({required this.powerPlants});

  final List<PowerPlant> powerPlants;

  @override
  Widget build(BuildContext context) {
    var index = 0;
    final plants = [];
    powerPlants.forEach((element) {
      final direction = searchDirectionByIndex(index);
      index++;
      plants.add(PowerPlantListItem(
        powerPlant: element,
        direction: direction,
      ));
    });
    return Column(
      children: [...plants],
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
