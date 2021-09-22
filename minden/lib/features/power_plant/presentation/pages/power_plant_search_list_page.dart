import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_list_item.dart';
import 'package:minden/features/profile_setting/domain/entities/tag.dart';
import 'package:minden/utile.dart';

class PowerPlantSearchListPage extends StatelessWidget {
  const PowerPlantSearchListPage({required this.selectTag, Key? key})
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
                          Stack(
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Container(
                                width: 150,
                              ),
                              Positioned(
                                top: 4,
                                child: TagListItem(
                                  tag: selectTag,
                                  onSelect: (tag) {},
                                  isSelected: true,
                                ),
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.topRight,
                                    colors: [
                                      const Color(0xffffffff).withOpacity(0),
                                      const Color(0xffffffff).withOpacity(1),
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
                  _PowerPlantSearchList(
                    tagId: selectTag.tagId.toString(),
                  ),
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
class _PowerPlantSearchList extends StatefulWidget {
  const _PowerPlantSearchList({required this.tagId});

  final String tagId;

  @override
  State<StatefulWidget> createState() {
    return _PowerPlantSearchListState();
  }
}

class _PowerPlantSearchListState extends State<_PowerPlantSearchList> {
  late GetPowerPlantsBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = GetPowerPlantsBloc(
      const PowerPlantStateInitial(),
      GetPowerPlants(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _bloc.add(GetPowerPlantsEvent(tagId: widget.tagId));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
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
              var index = 0;
              final plants = [];
              state.powerPlants.powerPlants.forEach((element) {
                final direction = searchDirectionByIndex(index);
                index++;
                plants.add(PowerPlantListItem(
                  key: ValueKey(element.plantId),
                  powerPlant: element,
                  direction: direction,
                ));
              });
              return Column(
                children: [...plants],
              );
            }
            return Container();
          },
        ),
      ),
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
