import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:minden/core/ext/logger_ext.dart';
import 'package:minden/core/util/bot_toast_helper.dart';
import 'package:minden/features/common/widget/tag/tag_list_item.dart';
import 'package:minden/features/login/presentation/bloc/logout_bloc.dart';
import 'package:minden/features/login/presentation/bloc/logout_event.dart';
import 'package:minden/features/login/presentation/pages/login_page.dart';
import 'package:minden/features/power_plant/data/datasources/power_plant_data_source.dart';
import 'package:minden/features/power_plant/data/repositories/power_plant_repository_impl.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_detail.dart';
import 'package:minden/features/power_plant/domain/entities/power_plant_participant.dart';
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

    _plantBloc.add(GetPowerPlantEvent(plantId: widget.plantId));

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
    _participantBloc.add(GetPowerPlantEvent(plantId: widget.plantId));

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
    _plantTagsBloc.add(GetTagEvent(plantId: widget.plantId));
  }

  @override
  void dispose() {
    _plantBloc.close();
    _participantBloc.close();
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
                      flexibleSpace: FlexibleSpaceBar(
                        background: PowerPlantPickup(
                          images: images,
                        ),
                      ),
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
            return Scaffold(
              backgroundColor: Colors.white,
            );
          },
        ),
      ),
    );
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
                detail.name ?? '',
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
              // 発電方法
              const SizedBox(height: 14),
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
              _generateDetailParticipant(),
              _generateDetailMessages(detail),
              const SizedBox(height: 47),
            ],
          ),
        ),
      ],
    );
  }

  Widget _generateDetailParticipant() {
    return BlocProvider.value(
      value: _participantBloc,
      child: BlocListener<GetParticipantBloc, PowerPlantState>(
        listener: (context, state) {},
        child: BlocBuilder<GetParticipantBloc, PowerPlantState>(
          builder: (context, state) {
            if (state is ParticipantLoaded) {
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
                  // 応援ユーザー
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ParticipantUserIconGroup(participant: state.participant),
                    ],
                  ),
                  // 大切にしていることタグ
                  const SizedBox(height: 16),
                  _generateTag(),
                  const SizedBox(height: 16),
                ],
              );
            }
            return Container();
          },
        ),
      ),
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
        _generateExpandableText(detail.ownerMessage ?? ''),
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

  String _getGenerationMethod(String powerGenerationMethod) {
    switch (powerGenerationMethod) {
      case '1':
        return '太陽光発電';
      case '2':
        return '風力発電';
      case '3':
        return '地熱発電';
      case '4':
        return '水力発電';
      case '5':
        return 'バイオマス発電';
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
  static const overlapLength = 22.0;

  /// アイコンサイズ（直径）
  static const iconSize = 30.0;

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
        child: Image.network(
          // TODO replace icon url
          valid ? imageUrl! : 'https://placeimg.com/480/480/any',
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
