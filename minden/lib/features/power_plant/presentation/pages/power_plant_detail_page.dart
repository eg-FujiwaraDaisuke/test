import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/core/util/string_util.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/login/domain/entities/user.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
import 'package:minden/features/power_plant/domain/entities/regist_power_plant.dart';
import 'package:minden/features/power_plant/domain/entities/support_history.dart';
import 'package:minden/features/power_plant/domain/usecase/power_plant_usecase.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_bloc.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_event.dart';
import 'package:minden/features/power_plant/presentation/bloc/power_plant_state.dart';
import 'package:minden/features/power_plant/presentation/pages/power_plant_pickup_page.dart';
import 'package:minden/features/profile_setting/data/datasources/tag_datasource.dart';
import 'package:minden/features/profile_setting/data/repositories/tag_repository_impl.dart';
import 'package:minden/features/profile_setting/domain/usecases/tag_usecase.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_bloc.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_event.dart';
import 'package:minden/features/profile_setting/presentation/bloc/tag_state.dart';
import 'package:minden/features/support_participant/presentation/support_participants_dialog.dart';
import 'package:minden/features/support_power_plant/presentation/support_power_plant_decision_dialog.dart';
import 'package:minden/features/support_power_plant/presentation/support_power_plant_select_dialog.dart';
import 'package:minden/features/token/data/datasources/encryption_token_data_source.dart';
import 'package:minden/utile.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../injection_container.dart';

class PowerPlantDetailPage extends StatefulWidget {
  const PowerPlantDetailPage({
    Key? key,
    required this.plantId,
  }) : super(key: key);

  final String plantId;

  @override
  State<StatefulWidget> createState() {
    return PowerPlantDetailPageState(plantId: plantId);
  }
}

/// 発電所詳細
class PowerPlantDetailPageState extends State<PowerPlantDetailPage> {
  PowerPlantDetailPageState({
    required this.plantId,
  });

  final String plantId;
  late GetPowerPlantBloc _plantBloc;
  late GetParticipantBloc _participantBloc;
  late GetPlantTagsBloc _plantTagsBloc;
  late GetPowerPlantsHistoryBloc _historyBloc;
  List<RegistPowerPlant> _registPowerPlants = [];
  late List<SupportHistoryPowerPlant> _supportHistory = [];
  late bool _isLoadedSupportHistroy = false;

  @override
  void initState() {
    super.initState();

    _plantBloc = GetPowerPlantBloc(
      const PowerPlantStateInitial(),
      GetPowerPlant(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _plantBloc.stream.listen((event) async {
      if (event is PowerPlantLoadError) {
        if (event.needLogin) {
          BlocProvider.of<LogoutBloc>(context).add(LogoutEvent());
          await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
              (_) => false);
        }
      }
    });

    _participantBloc = GetParticipantBloc(
      const PowerPlantStateInitial(),
      GetPowerPlantParticipant(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _plantTagsBloc = GetPlantTagsBloc(
      const TagStateInitial(),
      GetPlantTags(
        TagRepositoryImpl(
          dataSource: TagDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _historyBloc = GetPowerPlantsHistoryBloc(
      const PowerPlantStateInitial(),
      GetPowerPlantsHistory(
        PowerPlantRepositoryImpl(
          powerPlantDataSource: PowerPlantDataSourceImpl(
            client: http.Client(),
          ),
        ),
      ),
    );

    _historyBloc.stream.listen((event) {
      if (event is HistoryLoading) {
        Loading.show(context);
        return;
      }
      Loading.hide();
      if (event is HistoryLoaded) {
        setState(() {
          _isLoadedSupportHistroy = true;
          _supportHistory = event.history.powerPlants;
        });
      }
    });

    _getPowerPlantsHistory();
    _plantTagsBloc.add(GetTagEvent(plantId: widget.plantId));
    _participantBloc.add(GetPowerPlantEvent(plantId: widget.plantId));
    _plantBloc.add(GetPowerPlantEvent(plantId: widget.plantId));
  }

  void _getPowerPlantsHistory() {
    // TODO 応援予約APIがなにも返さないので一旦応援履歴から取得する
    _historyBloc.add(GetSupportHistoryEvent(historyType: 'history'));
  }

  @override
  void dispose() {
    _plantBloc.close();
    _participantBloc.close();
    _historyBloc.close();
    _plantTagsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _plantBloc,
      child: BlocListener<GetPowerPlantBloc, PowerPlantState>(
        listener: (context, state) {
          if (state is PowerPlantLoading) {
            Loading.show(context);
            return;
          }
          Loading.hide();
        },
        child: BlocBuilder<GetPowerPlantBloc, PowerPlantState>(
          builder: (context, state) {
            if (state is PowerPlantLoaded) {
              final images = <String>[];
              final detail = state.powerPlant;
              final isSupport = _supportHistory
                  .map((powerPlant) => powerPlant.plantId)
                  .contains(detail.plantId);

              if (detail.plantImage1.isNotEmpty) {
                images.add(detail.plantImage1);
              }
              if (detail.plantImage2?.isNotEmpty ?? false) {
                images.add(detail.plantImage2!);
              }
              if (detail.plantImage3?.isNotEmpty ?? false) {
                images.add(detail.plantImage3!);
              }
              if (detail.plantImage4?.isNotEmpty ?? false) {
                images.add(detail.plantImage4!);
              }

              return Scaffold(
                backgroundColor: Colors.white,
                body: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      flexibleSpace: Stack(children: [
                        FlexibleSpaceBar(
                          background: PowerPlantPickup(
                            images: images,
                          ),
                        ),
                        if (isSupport && _isLoadedSupportHistroy)
                          Positioned(
                            top: 266,
                            left: 0,
                            child: Container(
                              width: 91,
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(14),
                                    bottomRight: Radius.circular(14)),
                                color: const Color(0xFFFF8C00).withOpacity(0.6),
                              ),
                              child: const Center(
                                child: Text(
                                  '応援中',
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                    fontFamily: 'NotoSansJP',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ]),
                      expandedHeight: 270,
                      backgroundColor: Colors.transparent,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          Stack(
                            children: [
                              // メッセージ
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 28,
                                  top: 24,
                                  right: 24,
                                  bottom: 56,
                                ),
                                child: Text(
                                  detail.catchphrase ?? '',
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
                          _generateDetail(detail),
                          // この発電所を応援する
                          FutureBuilder(
                            future: _getUserjson(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                final isArtistPowerPlant =
                                    detail.limitedIntroducerId == 'ARTIST';

                                final isArtistPlan =
                                    snapshot.data.limitedPlantId != null;

                                // アーティスト発電所でアーティストプランの場合
                                if (isArtistPowerPlant && isArtistPlan) {
                                  return Container();
                                }
                                // 普通の発電所でアーティストプランの場合
                                if (!isArtistPowerPlant && isArtistPlan) {
                                  return Container();
                                }

                                if (isSupport) {
                                  return Container();
                                }
                                if (!_isLoadedSupportHistroy) {
                                  return Container();
                                }

                                return _buildSupportButton(detail, isArtistPlan,
                                    snapshot.data, _supportHistory);
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Scaffold(
              backgroundColor: Colors.white,
            );
          },
        ),
      ),
    );
  }

  dynamic _getUserjson() async {
    final userJsonData =
        await si<EncryptionTokenDataSourceImpl>().restoreUser();
    final userJson = json.decode(userJsonData);
    return User.fromJson(userJson);
  }

  Widget _generateDetail(
    PowerPlantDetail detail,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 発電所名
              Text(
                detail.projectName ?? '',
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
                    detail.viewAddress ?? '',
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
              const SizedBox(height: 14),
              // 発電方法
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      _getGenerationMethod(detail.powerGenerationMethod!),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D7E7F),
                        height: 1.48,
                      ),
                    ),
                  ),
                  Text(
                    i18nTranslate(
                        context, 'power_plant_detail_generate_output'),
                    style: const TextStyle(
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
              _generateDetailParticipant(),
              _generateDetailMessages(detail),
              const SizedBox(height: 47),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportButton(
    PowerPlantDetail detail,
    bool isArtistPlan,
    User user,
    List<SupportHistoryPowerPlant> powerPlants,
  ) {
    final isArtistPowerPlant = detail.limitedIntroducerId == 'ARTIST';
    final supportableNumber = user.supportableNumber;

    final selectPowerPlant = PowerPlant(
      plantId: detail.plantId,
      areaCode: detail.areaCode,
      name: detail.name ?? '',
      viewAddress: detail.viewAddress ?? '',
      voltageType: detail.voltageType,
      powerGenerationMethod: detail.powerGenerationMethod ?? '',
      renewableType: detail.renewableType,
      generationCapacity: detail.generationCapacity,
      displayOrder: detail.displayOrder,
      isRecommend: detail.isRecommend,
      ownerName: detail.ownerMessage ?? '',
      startDate: detail.startDate,
      endDate: detail.endDate,
      plantImage1: detail.plantImage1,
    );

    return Container(
      padding: const EdgeInsets.only(top: 11, bottom: 20),
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: [
          if (isArtistPowerPlant)
            const Color(0xFF5CD2F8)
          else
            const Color(0xFFFF8C00),
          if (isArtistPowerPlant)
            const Color(0xFF5CD2F8)
          else
            const Color(0xFFFFC277),
        ],
        stops: const [
          0.0,
          1.0,
        ],
      )),
      child: Center(
        child: Column(
          children: [
            InkWell(
              child: OutlinedButton(
                onPressed: () async {
                  //  アーティスト発電所でアーティストをサポートしてる場合
                  if (isArtistPowerPlant && isArtistPlan) {
                    return;
                  }

                  // 通常の発電所
                  if (!isArtistPowerPlant) {
                    setState(() {
                      _registPowerPlants = powerPlants
                          .map((powerPlant) => RegistPowerPlant(
                                isRegist: true,
                                powerPlant:
                                    PowerPlant.fromJson(powerPlant.toJson()),
                              ))
                          .toList();
                    });

                    // 契約件数が現在の応援件数より少ない場合
                    if (supportableNumber > powerPlants.length) {
                      final isUpdate = await SupportPowerPlantDecisionDialog(
                        context: context,
                        selectPowerPlant: selectPowerPlant,
                        registPowerPlants: _registPowerPlants,
                        user: user,
                      ).showDialog();

                      // TODO isUpdateがnullになって返ってくる問題がある
                      if (isUpdate ?? true) {
                        _getPowerPlantsHistory();
                      }
                    } else {
                      // 応援プラントを選択する
                      final isSelected = await SupportPowerPlantSelectDialog(
                        context: context,
                        selectPowerPlant: selectPowerPlant,
                        registPowerPlants: _registPowerPlants,
                        user: user,
                      ).showDialog();

                      // 応援プラントを選択した場合、確定ダイアログに飛ばす
                      if (isSelected ?? false) {
                        final isUpdate = await SupportPowerPlantDecisionDialog(
                          context: context,
                          selectPowerPlant: selectPowerPlant,
                          registPowerPlants: _registPowerPlants,
                          user: user,
                        ).showDialog();

                        // TODO isUpdateがnullになって返ってくる問題がある
                        if (isUpdate ?? true) {
                          _getPowerPlantsHistory();
                        }
                      } else {
                        // 応援プラントを選択しなかった場合、stateの中身をリセット
                        setState(
                          () {
                            _registPowerPlants = powerPlants
                                .map(
                                  (selectedPowerPlant) => RegistPowerPlant(
                                    isRegist: true,
                                    powerPlant: PowerPlant.fromJson(
                                        selectedPowerPlant.toJson()),
                                  ),
                                )
                                .toList();
                          },
                        );
                      }
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(42),
                  ),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                  child: Text(
                    _getSupportButtonText(isArtistPowerPlant, isArtistPlan),
                    style: const TextStyle(
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

            // 普通の発電所でアーティストプランの場合
            if (!isArtistPowerPlant && isArtistPlan) Container(),

            // アーティスト発電所でアーティストプランの場合
            if (isArtistPowerPlant && isArtistPlan) Container(),

            // アーティスト発電所でアーティストプランではない場合
            if (isArtistPowerPlant && !isArtistPlan)
              Container(
                padding: const EdgeInsets.only(top: 9),
                width: 310,
                child: Text(
                  i18nTranslate(
                      context, 'power_plant_detail_add_expectant_artist'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'NotoSansJP',
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: calcFontHeight(fontSize: 13, lineHeight: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getSupportButtonText(
      bool isArtistPowerPlant, bool canSupportArtistPowerPlant) {
    if (!isArtistPowerPlant) {
      return i18nTranslate(context, 'power_plant_detail_support');
    }

    if (isArtistPowerPlant && !canSupportArtistPowerPlant) {
      return i18nTranslate(context, 'power_plant_detail_can_not_support');
    }

    if (isArtistPowerPlant && canSupportArtistPowerPlant) {
      return i18nTranslate(context, 'power_plant_detail_support');
    }

    return i18nTranslate(context, 'power_plant_detail_support');
  }

  Widget _generateDetailParticipant() {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
        const SizedBox(height: 10),
        Text(
          i18nTranslate(context, 'power_plant_detail_everyone_important'),
          style: const TextStyle(
            fontSize: 15,
            fontFamily: 'NotoSansJP',
            fontWeight: FontWeight.w700,
            color: Color(0xFF575292),
            height: 1.43,
          ),
        ),
        BlocProvider.value(
          value: _participantBloc,
          child: BlocListener<GetParticipantBloc, PowerPlantState>(
            listener: (context, state) {},
            child: BlocBuilder<GetParticipantBloc, PowerPlantState>(
                builder: (context, state) {
              if (state is ParticipantLoaded) {
                return GestureDetector(
                  onTap: () {
                    SupportParticipantsDialog(
                      context: context,
                      participants: state.participant,
                    ).showDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ParticipantUserIconGroup(participant: state.participant),
                    ],
                  ),
                );
              }
              return Container();
            }),
          ),
        ),
        // 大切にしていることタグ
        const SizedBox(height: 16),
        _generateTag(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _generateTag() {
    return BlocProvider.value(
      value: _plantTagsBloc,
      child: BlocListener<GetPlantTagsBloc, TagState>(
        listener: (context, state) {},
        child: BlocBuilder<GetPlantTagsBloc, TagState>(
          builder: (context, state) {
            if (state is TagGetSucceed) {
              return Container(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 10,
                  children: state.tags
                      .map((tag) => TagListItem(
                            tag: tag,
                            onSelect: () {},
                            isSelected: true,
                          ))
                      .toList(),
                ),
              );
            }
            return Container();
          },
        ),
      ),
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
        _generateExpandableText(detail.ownerMessage ?? '',
            i18nTranslate(context, 'power_plant_detail_from_owner')),
        const SizedBox(height: 10),
        const Divider(
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
        const SizedBox(height: 17),
        _generateExpandableText(detail.aboutPlant ?? '',
            i18nTranslate(context, 'power_plant_detail_about')),
        const SizedBox(height: 10),
        const Divider(
          height: 1,
          color: Color(0xFFE2E2E2),
        ),
        const SizedBox(height: 17),
        _generateExpandableText(detail.prospect ?? '',
            i18nTranslate(context, 'power_plant_detail_prospect')),
      ],
    );
  }

  Widget _generateExpandableText(String message, String title) {
    return ExpandableNotifier(
      child: Column(
        children: [
          Expandable(
            collapsed: ExpandableButton(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'NotoSansJP',
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF575292),
                            height: 1.43,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          i18nTranslate(context, 'power_plant_detail_see_more'),
                          style: const TextStyle(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
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
                  Text(
                    title,
                    style: const TextStyle(
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
              Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  }
                },
                text: message,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'NotoSansJP',
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7D7E7F),
                  height: 1.6,
                ),
                linkStyle: const TextStyle(color: Colors.blueAccent),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  String _getGenerationMethod(String powerGenerationMethod) {
    switch (powerGenerationMethod) {
      case '1':
        return i18nTranslate(context, 'solar_power_generate');
      case '2':
        return i18nTranslate(context, 'wind_power_generate');
      case '3':
        return i18nTranslate(context, 'geothermal_power_generate');
      case '4':
        return i18nTranslate(context, 'hydroelectric_power_generate');
      case '5':
        return i18nTranslate(context, 'biomass_power_generate');
      default:
        return '';
    }
  }
}

/// 応援ユーザー表示
class ParticipantUserIconGroup extends StatelessWidget {
  const ParticipantUserIconGroup({Key? key, required this.participant})
      : super(key: key);

  /// 表示可能な最大ユーザーアイコン数
  static const maxUserIconCount = 3;

  /// 表示可能な最大アイコン数
  static const maxIconCount = 4;

  /// アイコン同士の重なり度合い
  static const overlapLength = 36.0;

  /// アイコンサイズ（直径）
  static const iconSize = 52.0;

  final PowerPlantParticipant participant;

  @override
  Widget build(BuildContext context) {
    return _generateParticipant(participant);
  }

  Widget _generateParticipant(PowerPlantParticipant participant) {
    final icons = _generateParticipantIcons(participant);
    if (icons.isEmpty) return Container();
    return Stack(
      children: List.generate(
        icons.length,
        (index) {
          return Padding(
            padding: EdgeInsets.fromLTRB(
                (maxIconCount - index) * overlapLength, 0, 0, 0),
            child: icons[index],
          );
        },
      ),
    );
  }

  List<Widget> _generateParticipantIcons(PowerPlantParticipant participant) {
    final total = participant.total;
    if (maxUserIconCount < total) {
      // 4人以上応援ユーザーがいる場合、
      return [
        _generateCircleRemainIcon(total),
        ...participant.userList
            .take(maxUserIconCount)
            .map((p) => _generateCircleUserIcon(p.icon))
            .toList()
      ];
    } else {
      // 3人以下の応援ユーザーしかいないため、「+X」表記を行わない
      return participant.userList
          .map((p) => _generateCircleUserIcon(p.icon))
          .toList();
    }
  }

  Widget _generateCircleUserIcon(String? imageUrl) {
    final valid = Uri.parse(imageUrl ?? '').isAbsolute;
    return Container(
      width: iconSize,
      height: iconSize,
      foregroundDecoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(iconSize / 2),
      ),
      // 魔法の padding
      padding: const EdgeInsets.all(0.5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(iconSize / 2),
        child: valid
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                placeholder: (context, url) {
                  return Image.asset(
                    'assets/images/user/icon_no_photo.png',
                    fit: BoxFit.cover,
                  );
                },
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/user/icon_no_photo.png',
                  fit: BoxFit.cover,
                ),
                width: iconSize,
                height: iconSize,
              )
            : Image.asset(
                'assets/images/user/icon_no_photo.png',
                fit: BoxFit.cover,
                width: iconSize,
                height: iconSize,
              ),
      ),
    );
  }

  Widget _generateCircleRemainIcon(int participantCount) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(iconSize / 2),
      child: Container(
        width: iconSize,
        height: iconSize,
        alignment: Alignment.center,
        color: const Color(0xFFEDCB50),
        padding: const EdgeInsets.only(left: 4),
        child: Text('+${participantCount - 3}',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.w500,
              fontSize: 12,
              height: 1.2,
            )),
      ),
    );
  }
}
